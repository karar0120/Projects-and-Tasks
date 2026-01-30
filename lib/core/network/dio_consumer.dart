import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/core/network/api_error_handler.dart';
import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';
import 'interceptor.dart';

class WebService {
  static late Dio dio;

  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    dio = Dio(BaseOptions(
      baseUrl: "",
      receiveDataWhenStatusError: true,
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
    ))
      ..interceptors.add(AppInterceptors());
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor());
    }
    await initSharedPreferences();
  }

  static initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Get current language from shared preferences
  static String getCurrentLanguage() {
    return _sharedPreferences.getString(CacheConsts.language) ?? 'en';
  }

  /// Update language in shared preferences and headers
  static Future<void> updateLanguage(String languageCode) async {
    await _sharedPreferences.setString(CacheConsts.language, languageCode);
  }

  static Future<Either<ApiErrorModel, Response>> get(
      {required String controller,
      String? endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    final lang = _sharedPreferences.getString(CacheConsts.language);
    var url = '$controller/$lang/$endpoint';
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      Response apiResponse = await dio.get(
        url,
        queryParameters: query,
        options: Options(
          method: 'GET',
          headers: headers ?? getRequestHeadersApplication(),
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future<Either<ApiErrorModel, Response>> getNoLang(
      {required String controller,
      String? endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    var url = '$controller/$endpoint';
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      Response apiResponse = await dio.get(
        url,
        queryParameters: query,
        options: Options(
          method: 'GET',
          headers: headers ?? getRequestHeadersApplication(),
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  /// Get request without language in URL, supports binary response (PDF, images, etc.)
  static Future<Either<ApiErrorModel, Response>> getNoLangBinary(
      {required String controller,
      String? endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? query}) async {
    var url = '$controller/$endpoint';
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      final defaultHeaders = getRequestHeadersApplication();
      final mergedHeaders = headers != null
          ? {...defaultHeaders, ...headers}
          : defaultHeaders;

      Response apiResponse = await dio.get(
        url,
        queryParameters: query,
        options: Options(
          method: 'GET',
          headers: mergedHeaders,
          responseType: ResponseType.bytes,
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future<Either<ApiErrorModel, Response>> postNoLangBinary(
      {required String controller,
      String? endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      Map<String, dynamic>? query}) async {
    var url = '$controller/$endpoint';
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      final defaultHeaders = getRequestHeadersApplication();
      final mergedHeaders = headers != null
          ? {...defaultHeaders, ...headers}
          : defaultHeaders;

      Response apiResponse = await dio.post(
        url,
        queryParameters: query,
        data: body,
        options: Options(
          method: 'POST',
          headers: mergedHeaders,
          responseType: ResponseType.bytes,
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future<Either<ApiErrorModel, Response>> getRefershToken(
      {required String controller,
      String? endpoint,
      Map<String, String>? headers,
      Map<String, dynamic>? body,

      Map<String, dynamic>? query}) async {
    var url = '$controller/$endpoint';
    try {
      Response apiResponse = await dio.post(
        url,
        queryParameters: query,
        data: body,
        options: Options(
          method: 'POST',
          headers: headers ?? getRequestHeadersApplication(),
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future<Either<ApiErrorModel, Response>> put({
    required String controller,
    String? endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    required dynamic body,
  }) async {
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      final lang = _sharedPreferences.getString(CacheConsts.language);
      var url = '$controller/$lang/$endpoint';
      Response apiResponse = await dio.put(
        url,
        data: body,
        queryParameters: query,
        options: Options(
          method: 'PUT',
          headers: headers ?? getRequestHeadersApplication(),
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future<Either<ApiErrorModel, Response>> putNoLang({
    required String controller,
    String? endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    required dynamic body,
    bool isFromS3 = false,
  }) async {
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      var url = isFromS3 ? controller : '$controller/$endpoint';
      Response apiResponse = await dio.put(
        url,
        data: body,
        queryParameters: query,
        options: Options(
          method: 'PUT',
          headers: headers ?? getRequestHeadersApplication(),
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future<Either<ApiErrorModel, Response>> post({
    required String controller,
    String? endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    required dynamic body,
  }) async {
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      final lang = _sharedPreferences.getString(CacheConsts.language);
      var url = '$controller/$lang/$endpoint';
      Response apiResponse = await dio.post(
        url,
        data: body,
        queryParameters: query,
        options: Options(
            method: 'POST', headers: headers ?? getRequestHeadersApplication()),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future<Either<ApiErrorModel, Response>> postNoLang({
    required String controller,
    String? endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    required dynamic body,
  }) async {
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      var url = '$controller/$endpoint';
      Response apiResponse = await dio.post(
        url,
        data: body,
        queryParameters: query,
        options: Options(
            method: 'POST', headers: headers ?? getRequestHeadersApplication()),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }


  static Future<Either<ApiErrorModel, Response>> patchNoLang({
    required String controller,
    String? endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    required dynamic body,
  }) async {
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      var url = '$controller/$endpoint';
      Response apiResponse = await dio.patch(
        url,
        data: body,
        queryParameters: query,
        options: Options(
            method: 'PATCH', headers: headers ?? getRequestHeadersApplication()),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future<Either<ApiErrorModel, Response>> delete({
    required String controller,
    String? endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      final lang = _sharedPreferences.getString(CacheConsts.language);
      var url = '$controller/$lang/$endpoint';
      Response apiResponse = await dio.delete(
        url,
        queryParameters: query,
        options: Options(
          method: 'DELETE',
          headers: headers ?? getRequestHeadersApplication(),
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  static Future validationsPost({
    required String controller,
    String? endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    required dynamic body,
  }) async {
    String? token = LocaleServices.getString(key: CacheConsts.accessToken);
    if (token != null && JwtDecoder.isExpired(token)) {
      await Validate.refreshToken();
    }
    final lang = _sharedPreferences.getString(CacheConsts.language);
    var url = '$controller/$lang/$endpoint';
    Response apiResponse = await dio.post(
      url,
      data: body,
      queryParameters: query,
      options: Options(
          method: 'POST', headers: headers ?? getRequestHeadersApplication()),
    );
    try {
      return apiResponse;
    } catch (exception) {
     print(exception);
    }
  }

  static Future<Either<ApiErrorModel, Response>> deleteNoLang({
    required String controller,
    String? endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    try {
      String? token = LocaleServices.getString(key: CacheConsts.accessToken);
      if (token != null && JwtDecoder.isExpired(token)) {
        await Validate.refreshToken();
      }
      var url = '$controller/$endpoint';
      Response apiResponse = await dio.delete(
        url,
        queryParameters: query,
        options: Options(
          method: 'DELETE',
          headers: headers ?? getRequestHeadersApplication(),
        ),
      );
      return right(apiResponse);
    } catch (exception) {
      return left(ErrorHandler.handle(exception).apiErrorModel);
    }
  }

  /// Get provider type: 2 for Android, 3 for iOS
  static String _getProviderType() {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'IOS';
    }
    return 'Android'; // Default to Android for other platforms
  }

  static Map<String, String> getRequestHeadersApplication() {
    final accessToken = LocaleServices.getString(key: CacheConsts.accessToken);
    final language = _sharedPreferences.getString(CacheConsts.language) ?? 'en';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'Accept-Language': language,
      'accept-language': language,
      'provider-type': _getProviderType(),
    };
  }

  static Map<String, String> getRequestHeadersMultipart() {
    final accessToken = LocaleServices.getString(key: CacheConsts.accessToken);
    final language = _sharedPreferences.getString(CacheConsts.language) ?? 'en';
    return {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $accessToken',
      'accept-language': language,
      'provider-type': _getProviderType(),
    };
  }

  static Map<String, String> getRequestHeadersNoToken() {
    final language = _sharedPreferences.getString(CacheConsts.language) ?? 'en';
    return {
      'Content-Type': 'application/json', 
      'Accept': 'application/json',
      'accept-language': language,
      'provider-type': _getProviderType(),
    };
  }

  static Map<String, String> getRequestHeadersVerifyKeyForCaptcha() {
    final language = _sharedPreferences.getString(CacheConsts.language) ?? 'en';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'accept-language': language,
      'provider-type': _getProviderType(),
    };
  }

  /// Get request headers with custom language override
  static Map<String, String> getRequestHeadersWithLanguage(String languageCode) {
    final accessToken = LocaleServices.getString(key: CacheConsts.accessToken);
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'accept-language': languageCode,
      'Provider-Type': _getProviderType(),
    };
  }

  /// Get request headers without token but with custom language
  static Map<String, String> getRequestHeadersNoTokenWithLanguage(String languageCode) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'accept-language': languageCode,
      'provider-type': _getProviderType(),
    };
  }
}