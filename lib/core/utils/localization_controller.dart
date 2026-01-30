import 'package:flutter/material.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';

class LocalizationController with ChangeNotifier {
  late Locale _locale;
  Locale get locale => _locale;

  LocalizationController() {
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    try {
      final savedLanguage = LocaleServices.getString(key: CacheConsts.language);
      debugPrint('🌍 LocalizationController: Loading saved language: $savedLanguage');
      if (savedLanguage != null && savedLanguage.isNotEmpty) {
        _locale = Locale(savedLanguage);
        debugPrint('🌍 LocalizationController: Set locale to: ${_locale.languageCode}');
      } else {
        _locale = const Locale('en');
        debugPrint('🌍 LocalizationController: No saved language, defaulting to: en');
      }
    } catch (e) {
      // If error, use default locale
      _locale = const Locale('en');
      debugPrint('🌍 LocalizationController: Error loading locale, defaulting to: en - $e');
    }
  }

  Future<void> setLocale(Locale locale, {bool save = true}) async {
    try {
      _locale = locale;
      if (save) {
        await LocaleServices.setData(key: CacheConsts.language, value: locale.languageCode);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('LocalizationController setLocale error: $e');
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
}
