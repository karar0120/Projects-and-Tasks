import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';


class ThemeController extends ChangeNotifier {
  bool? _isDark;

  bool _knowIsDark =true;

  bool? get isDark => _isDark;
  bool get knowIsDark => _knowIsDark;

  setTheme(bool value) {
    _isDark = value;
    notifyListeners();
  }


  getPreviousSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getBool(CacheConsts.isDarkMode);
    bool isDarkMode() {
      final darkMode = WidgetsBinding.instance.window.platformBrightness;
      if (darkMode == Brightness.dark) {
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    }
    if (mode==null){
      if (isDarkMode()==true){
        prefs.setBool(CacheConsts.isDarkMode,false);
        them();
      }else if(isDarkMode()==false){
        prefs.setBool(CacheConsts.isDarkMode,true);
        them();
      }
    }else if (mode==true){
      prefs.setBool(CacheConsts.isDarkMode,false);
      them();

    }else if (mode==false){
      prefs.setBool(CacheConsts.isDarkMode,true);
      them();
    }
    pp();

    notifyListeners();
  }
  void them()async{
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getBool(CacheConsts.isDarkMode);
    if (mode==null){
      _isDark= null;
      notifyListeners();
    }else if (mode==true){
      _isDark=true;
      notifyListeners();
    }
    else if (mode==false){
      _isDark =false;
      notifyListeners();
    }
  }

  void pp()async{
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getBool(CacheConsts.isDarkMode);
    if (mode==null){
      final darkMode = WidgetsBinding.instance.window.platformBrightness;
      if (darkMode==Brightness.dark){
        _knowIsDark=true;
      }
      else {
        _knowIsDark=false;

      }
    }else {
      _knowIsDark=mode;
    }
    notifyListeners();
  }
}
