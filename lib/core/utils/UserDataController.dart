
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/core/network/dio_consumer.dart';
import 'package:projectsandtasks/core/utils/localization_controller.dart';
import 'package:projectsandtasks/shared/models/environment.dart';
import 'package:projectsandtasks/shared/models/home_page_model.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';
import 'change_index_controller.dart';
import 'package:projectsandtasks/shared/widgets/GeneralComponents.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/constants/constance.dart';
enum UserDataControllerStage { loading, done, error }

class UserDataController extends ChangeNotifier {
  static UserDataController? _instance;

  factory UserDataController() => _instance ??= UserDataController._();

  UserDataController._() {
    // Initialize current language from SharedPreferences
    _currentLanguage = LocaleServices.getString(key: CacheConsts.language) ?? 'en';
    debugPrint('🌍 UserDataController initialized with language: $_currentLanguage');
  }

  String abpUrl = Environment.abpUrl;
  UserDataControllerStage? permissionsStage;
  UserDataControllerStage? getMyProfileStage;

  /// Start Login Screen Attributes ////////////////

  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void setCurrentLanguage(String language) {
    _currentLanguage = language;
    notifyListeners();
  }

  bool connected = true;

  String? _locale;

  String get locale => _locale!;

  void setLocale(locale) {
    _locale = locale;
    notifyListeners();
  }

  void changeCurrentLanguage(context, value) async {
    // Use the selected value directly instead of toggling
    final selectedLanguage = value.toString();
    debugPrint('🌍 changeCurrentLanguage called with value: $selectedLanguage, current: $_currentLanguage');

    // Always update even if same, to ensure consistency between UI and state
    debugPrint('🌍 Changing language to: $selectedLanguage');

    // Update locale in LocalizationController
    await Provider.of<LocalizationController>(context, listen: false)
        .setLocale(Locale(selectedLanguage));
    debugPrint('🌍 Updated LocalizationController');

    // Save to SharedPreferences
    await LocaleServices.setData(
        key: CacheConsts.language, value: selectedLanguage);
    debugPrint('🌍 Saved to SharedPreferences');

    // Verify it was saved
    final savedLang = LocaleServices.getString(key: CacheConsts.language);
    debugPrint('🌍 Verified saved language: $savedLang');

    // Update local variables
    final lang = LocaleServices.getString(key: CacheConsts.language);
    langg = lang;

    // Update current language
    setLocale(selectedLanguage);
    setCurrentLanguage(selectedLanguage);

    debugPrint('🌍 Language change complete. New language: $_currentLanguage');
    notifyListeners();
  }

  String? langg;
  DateTime? selectedDay;

  Future getCurrentLanguage(context) async {
    _locale = Provider.of<LocalizationController>(context, listen: false)
        .locale
        .languageCode;
    _currentLanguage =
        await LocaleServices.getData(key: CacheConsts.language) ?? 'en';
    LocaleServices.setData(key: CacheConsts.language, value: _currentLanguage);
    final lang = LocaleServices.getString(key: CacheConsts.language);
    langg = lang;
    await Provider.of<LocalizationController>(context, listen: false)
        .setLocale(Locale(_currentLanguage));
  }

  bool? isFeatureCustomized;

  void permissions() async {
   

    isFeatureCustomized =
        LocaleServices.getBoolean(key: CacheConsts.isFeatureCustomized);
  }

  
  /// onBoarding Attribute
  bool isLast = false;

  /// End Change Password Screen Attributes ///////////

  ///Start Get User Image

  /// Start Get User Data
  static String? _userData;

  String? get userData => _userData;


  Future getMyProfile(context) async {
    getMyProfileStage = UserDataControllerStage.loading;
    String route = '$abpUrl/CurrentUser';
    final response = await WebService.getNoLang(
      endpoint: 'me',
      controller: route,
    );
    response.fold((l) {}, (result) {
      _userData = result.data['firstName'];

      // Update isGalleryRestricted from API response
      final data = result.data;
      if (data != null && data is Map<String, dynamic>) {
        final isGalleryRestricted = data['isGalleryRestricted'];
        if (isGalleryRestricted != null) {
          LocaleServices.setData(
            key: CacheConsts.isGalleryRestricted,
            value: isGalleryRestricted as bool,
          );
        }
      }

      getMyProfileStage = UserDataControllerStage.done;
      notifyListeners();
    });
  }



  /// Logout Method

  void removeSharedPreferences(context) async {
    LocaleServices.clearKey(key: CacheConsts.accessToken);
    LocaleServices.clearKey(key: CacheConsts.timeZone);
    LocaleServices.clearKey(key: CacheConsts.isFeatureCustomized);
    LocaleServices.clearKey(key: CacheConsts.frontendUrl);
    LocaleServices.clearKey(key: CacheConsts.bookingDetailPageUrl);
    LocaleServices.clearKey(key: CacheConsts.serviceDetailsPageUrl);
   
    LocaleServices.clearKey(key: CacheConsts.packagePriceId);
    notifyListeners();
  }

  bool logoutCard = true;

  void logout(context) async {
    final changeIndexController =
    Provider.of<ChangeIndexController>(context, listen: false);
    changeIndexController.index = 0;
    removeSharedPreferences(context);
    
    // On logout: Stop processing but DON'T delete jobs/files
    // Jobs and files will be preserved for same user, or cleared on login if different user
    
    
    logoutCard = false;
    
    notifyListeners();
  }

  Future<void> showLogoutConfirmation(BuildContext context) async {
    showAlertDialogYESNOLogout(
      context,
      content: "${AppLocalizations.of(context)!.trans(StringConsts.areYouSureYouWantToLogout)}",
      toggleLabel: "${AppLocalizations.of(context)!.trans(StringConsts.logoutFromAllDevices)}",
      initialValue: false,
      onYes: (bool logoutFromAllDevices) async {
        Navigator.of(context).pop();
        await performLogoutRequest(
          logoutFromAllDevices: logoutFromAllDevices,
        );
        if (context.mounted) {
          logout(context);
        }
      },
      onNo: () async {
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> performLogoutRequest({
    required bool logoutFromAllDevices,
  }) async {
    try {
      final deviceId = LocaleServices.getString(key: CacheConsts.deviceId) ?? '';
      final body = {
        "logoutFromAllDevices": logoutFromAllDevices,
        "deviceId": deviceId,
      };
      await WebService.postNoLang(
        controller: Environment.abpUrl,
        endpoint: 'Authenticate/logout',
        query: {
          'api-version': '1.0',
        },
        headers: WebService.getRequestHeadersApplication(),
        body: body,
      );
    } catch (_) {
      // Swallow errors; local logout still proceeds
    }
  }

  int? userIdPackage;

  void checkPermissions(context) async {
    final tenantId = LocaleServices.getInt(key: CacheConsts.tenantId);
    final userId = LocaleServices.getInt(key: CacheConsts.userId);

    // Sign in to Firebase Auth first
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "myslotsdemo@gmail.com",
          password: ";g]5HR3U2s*mI*3HrEpN");

      if (kDebugMode) {
        print('✅ Firebase Auth: Signed in successfully');
        print('   Email: ${userCredential.user?.email}');
        print('   UID: ${userCredential.user?.uid}');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        if (e.code == 'user-not-found') {
          print('❌ Firebase Auth: No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('❌ Firebase Auth: Wrong password provided.');
        } else {
          print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
        }
        print('');
        print('💡 Cannot connect to Firebase Realtime Database without authentication');
      }
      return; // Don't proceed without auth
    } catch (e) {
      if (kDebugMode) {
        print('❌ Unexpected Firebase Auth error: $e');
      }
      return;
    }

    if (tenantId == null || userId == null) {
      if (kDebugMode) {
        print('⚠️ tenantId or userId is null, cannot set up Firebase listeners');
        print('   tenantId: $tenantId');
        print('   userId: $userId');
      }
      return;
    }

    if (kDebugMode) {
      print('🔍 Setting up Firebase listeners for:');
      print('   Path: Companies/$tenantId/Users/$userId');
    }

    DatabaseReference starCountRef = FirebaseDatabase.instance
        .ref()
        .child("Companies/$tenantId/Users/$userId");

    // Listen specifically to lastModificationDate field
    DatabaseReference lastModificationDateRef = FirebaseDatabase.instance
        .ref()
        .child("Companies/$tenantId/Users/$userId/lastModificationDate");

    // Add error handling for permission denied
    starCountRef.onValue.listen(
      (DatabaseEvent event) {
        if (kDebugMode) {
          print('✅ Firebase Database: Data received from Companies/$tenantId/Users/$userId');
        }

        // Safely cast to Map with null check
        final data = event.snapshot.value as Map<dynamic, dynamic>?;

        if (data == null) {
          if (kDebugMode) {
            print('⚠️ Firebase snapshot value is null');
          }
          return;
        }

        checkPermissionsAll(data, context, userId!, tenantId);
        if (data['unReadNotificationCount'] != null) {
          unReadNotificationCount = data['unReadNotificationCount'];
        }
        notifyListeners();
      },
      onError: (error) {
        if (kDebugMode) {
          print('❌ Firebase Database Error at Companies/$tenantId/Users/$userId');
          print('   Error: $error');
          print('');
          print('💡 SOLUTION:');
          print('   1. Go to: https://console.firebase.google.com/');
          print('   2. Select your project');
          print('   3. Click "Realtime Database" → "Rules"');
          print('   4. Update rules to allow authenticated access');
          print('   5. Click "Publish"');
          print('');
          print('   See FIREBASE_DATABASE_SETUP.md for detailed instructions');
        }
      },
    );


    // Listen to lastModificationDate changes specifically
    lastModificationDateRef.onValue.listen(
      (DatabaseEvent event) {
        final lastModificationDateValue = event.snapshot.value;
        if (lastModificationDateValue != null) {
          try {
            final lastModificationDateUTC = DateTime.parse(lastModificationDateValue.toString());
            final timeNowUTCString = LocaleServices.getString(key: CacheConsts.dateTimeUTC);

            if (timeNowUTCString != null && timeNowUTCString.isNotEmpty) {
              final timeNowUTC = DateTime.parse(timeNowUTCString);

              if (lastModificationDateUTC.compareTo(timeNowUTC) == 1) {
                LocaleServices.setData(
                    key: CacheConsts.dateTimeUTC,
                    value: lastModificationDateUTC.toString());
                getMyPermissions(context);
              }
            } else {
              // If no stored UTC time, update it and refresh permissions
              LocaleServices.setData(
                  key: CacheConsts.dateTimeUTC,
                  value: lastModificationDateUTC.toString());
              getMyPermissions(context);
            }
          } catch (e) {
            if (kDebugMode) {
              print('⚠️ Error parsing lastModificationDate: $e');
            }
          }
          notifyListeners();
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('❌ Firebase Database Error at lastModificationDate path');
          print('   Error: $error');
        }
      },
    );
  }

  int unReadNotificationCount = 0;
  Future<void> fetchUnreadNotificationCount() async {
    try {
      final controller = '${Environment.abpUrl}/Notifications';
      final result = await WebService.getNoLang(
        controller: controller,
        endpoint: 'GetUnreadCount',
        query: {'api-version': '1.0'},
      );
      result.fold((_) {}, (r) {
        final data = r.data;
        int count = 0;
        if (data is Map && data['count'] != null) {
          count = (data['count'] as num).toInt();
        } else if (data is num) {
          count = data.toInt();
        }
        unReadNotificationCount = count;
        notifyListeners();
      });
    } catch (_) {
      // ignore errors
    }
  }
  bool? isFreeSubscription = true;

  void checkPermissionsAll(Map data, context, int userid, tenantId) async {
    DateTime? lastModificationDateUTC;

    // Get the stored UTC time as a nullable string
    final timeNowUTCString = LocaleServices.getString(key: CacheConsts.dateTimeUTC);

    // Parse lastModificationDate from Firebase data
    if (data['lastModificationDate'] != null) {
      try {
        lastModificationDateUTC = DateTime.parse(data['lastModificationDate']);
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Error parsing lastModificationDate in checkPermissionsAll: $e');
        }
        return; // Exit early if we can't parse the date
      }
    } else {
      if (kDebugMode) {
        print('⚠️ lastModificationDate is null in Firebase data');
      }
      return; // Exit early if data is missing
    }

    // If we have a stored time, compare it; otherwise, update permissions
    if (timeNowUTCString != null && timeNowUTCString.isNotEmpty) {
      try {
        final timeNowUTC = DateTime.parse(timeNowUTCString);
        if (lastModificationDateUTC.compareTo(timeNowUTC) == 1) {
          LocaleServices.setData(
              key: CacheConsts.dateTimeUTC,
              value: lastModificationDateUTC.toString());
          getMyPermissions(context);
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Error parsing stored dateTimeUTC: $e');
        }
        // Update the stored time and refresh permissions
        LocaleServices.setData(
            key: CacheConsts.dateTimeUTC,
            value: lastModificationDateUTC.toString());
        getMyPermissions(context);
      }
    } else {
      // No stored time, so update it and refresh permissions
      LocaleServices.setData(
          key: CacheConsts.dateTimeUTC,
          value: lastModificationDateUTC.toString());
      getMyPermissions(context);
    }
  }

  GetMyPermissions? getMyPermissionsModels;

  void getMyPermissions(context) async {
    permissionsStage = UserDataControllerStage.loading;
    removeSharedPreferencesAfterUpdatePermissions();
    String route = '$abpUrl/CurrentUser';
    final response = await WebService.getNoLang(
      endpoint: 'me',
      controller: route,
    );
    response.fold((error) {
      permissionsStage = UserDataControllerStage.error;
      notifyListeners();
    }, (result) {
      LocaleServices.saveList(permissions: result.data['grantedPermissions'].cast<String>());
      permissionsStage = UserDataControllerStage.done;
      notifyListeners();
      permissions();
    });
  }

  void removeSharedPreferencesAfterUpdatePermissions() async {
    LocaleServices.clearKey(key: Constance.permissions);
    notifyListeners();
  }


}
