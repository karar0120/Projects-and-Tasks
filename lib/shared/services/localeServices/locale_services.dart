
// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectsandtasks/core/constants/constance.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';

class LocaleServices {
  static LocaleServices? _instance;

  factory LocaleServices() => _instance ??= LocaleServices._();

  LocaleServices._();

  static String tokenKey = 'token';
  static String mobileKey = 'mobile';
  static String passwordKey = 'password';
  static String userDataKey = 'userData';
  static SharedPreferences? _sharedPreferences;
  late String userToken;

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static bool isContainKey({
    required String key,
  }) {
    return _sharedPreferences!.containsKey(key);
  }

  static getData({
    required String key,
  }) async {
    if (isContainKey(key: key)) {
      return _sharedPreferences!.get(key);
    } else {
      return null;
    }
  }

  Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _sharedPreferences!.setString(key, value);
    if (value is int) return await _sharedPreferences!.setInt(key, value);
    if (value is bool) return await _sharedPreferences!.setBool(key, value);

    return await _sharedPreferences!.setDouble(key, value);
  }

  Future<Map<String, dynamic>> getUserData({
    required String key,
  }) async {
    String? encodedMap = _sharedPreferences!.getString(key);
    print('egterwgr');
    print(encodedMap);

    var x = json.decode(encodedMap!);
    print(x.runtimeType);
    return x;
  }

  setUserData({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    print(value);
    String encodedMap = json.encode(value);
    print(encodedMap);
    return await _sharedPreferences!.setString(key, encodedMap);
  }

  Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    return await _sharedPreferences!.setBool(key, value);
  }

  static Future<bool> clearKey({
    required String key,
  }) async {
    return await _sharedPreferences!.remove(key);
  }

  Future<bool> clearAll() async {
    return await _sharedPreferences!.clear();
  }

  static dynamic getBoolean({required String key}) {
    return _sharedPreferences!.getBool(key);
  }

  static dynamic getString({required String key}) {
    return _sharedPreferences!.getString(key);
  }

  static dynamic getInt({required String key}) {
    return _sharedPreferences!.getInt(key);
  }

  static setData({required String key, required value}) async {
    debugPrint(
        "SharedPreferenceHelper: setData With key: $key and value :$value");
    switch (value.runtimeType) {
      case String:
        await _sharedPreferences!.setString(key, value);
        break;
      case int:
        await _sharedPreferences!.setInt(key, value);
        break;
      case bool:
        await _sharedPreferences!.setBool(key, value);
        break;
      case double:
        await _sharedPreferences!.setDouble(key, value);
        break;
      default:
        return null;
    }
  }
 static List<String> _cachedPermissions = [];

  static Future<void> saveList({required List<String> permissions}) async {
    _cachedPermissions = permissions; // keep in memory
    await _sharedPreferences!.setString(
      Constance.permissions,
      jsonEncode(permissions),
    );
  }

  static Future<List<String>> getList() async {
    if (_cachedPermissions.isNotEmpty) {
      return _cachedPermissions;
    }
    final data = _sharedPreferences!.getString(Constance.permissions);
    if (data != null) {
      _cachedPermissions = List<String>.from(jsonDecode(data));
      return _cachedPermissions;
    }
    return [];
  }

  /// Async check
  static Future<bool> hasPermission(String permission) async {
    final list = await getList();
    return list.contains(permission);
  }

  /// Sync check (after list is loaded at least once)
  static bool hasPermissionSync(String permission) {
    return _cachedPermissions.contains(permission);
  }


  /// Returns previously cached Base64 login response string, or null
  static String? getCachedLoginResponseBase64String({
    required String key,
  }) {
    return LocaleServices._sharedPreferences!.getString(key);
  }

  /// Build and cache a Base64 string from raw API login response (Map)
  static Future<void> cacheLoginResponseBase64(
      Map<String, dynamic> response) async {
    final String jsonString = jsonEncode(response);
    final String base64String = base64Encode(utf8.encode(jsonString));
    await LocaleServices._sharedPreferences!.setString(
      CacheConsts.loginResponseBase64,
      base64String,
    );
  }
}