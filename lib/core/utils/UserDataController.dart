import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/core/utils/localization_controller.dart';
import 'package:projectsandtasks/core/utils/change_index_controller.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';

class UserDataController extends ChangeNotifier {
  static UserDataController? _instance;

  factory UserDataController() => _instance ??= UserDataController._();

  UserDataController._() {
    _currentLanguage = LocaleServices.getString(key: CacheConsts.language) ?? 'en';
  }

  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void setCurrentLanguage(String language) {
    _currentLanguage = language;
    notifyListeners();
  }

  String? _locale;

  String get locale => _locale!;

  void setLocale(String? locale) {
    _locale = locale;
    notifyListeners();
  }

  /// Used by language selector and form_field_widget for RTL.
  String? langg;

  Future<void> changeCurrentLanguage(BuildContext context, dynamic value) async {
    final selectedLanguage = value.toString();

    await Provider.of<LocalizationController>(context, listen: false)
        .setLocale(Locale(selectedLanguage));

    await LocaleServices.setData(
        key: CacheConsts.language, value: selectedLanguage);

    langg = LocaleServices.getString(key: CacheConsts.language);
    setLocale(selectedLanguage);
    setCurrentLanguage(selectedLanguage);
    notifyListeners();
  }

  Future<void> getCurrentLanguage(BuildContext context) async {
    _locale = Provider.of<LocalizationController>(context, listen: false)
        .locale
        .languageCode;
    _currentLanguage =
        await LocaleServices.getData(key: CacheConsts.language) ?? 'en';
    await LocaleServices.setData(key: CacheConsts.language, value: _currentLanguage);
    langg = LocaleServices.getString(key: CacheConsts.language);
    await Provider.of<LocalizationController>(context, listen: false)
        .setLocale(Locale(_currentLanguage));
    notifyListeners();
  }

  Future<void> removeSharedPreferences(BuildContext context) async {
    await LocaleServices.clearKey(key: CacheConsts.accessToken);
    await LocaleServices.clearKey(key: CacheConsts.timeZone);
    await LocaleServices.clearKey(key: CacheConsts.language);
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    final changeIndexController =
        Provider.of<ChangeIndexController>(context, listen: false);
    changeIndexController.index = 0;
    await removeSharedPreferences(context);
    notifyListeners();
  }
}
