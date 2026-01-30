import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/main.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/GeneralComponents.dart';


import 'api_constants.dart';

enum DataSource {
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  // API_LOGIC_ERROR,
  DEFAULT
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int PAYMENT_REQUIRED = 402; // subscription expired
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found
  static const int API_LOGIC_ERROR = 422; // API , lOGIC ERROR
  static const int TOO_MANY_REQUESTS_BLOCKED = 426; // custom: blocked due to exceeded requests

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String NO_CONTENT =
      ApiErrors.noContent; // success with no data (no content)
  static const String BAD_REQUEST =
      ApiErrors.badRequestError; // failure, API rejected request
  static const String UNAUTORISED =
      ApiErrors.unauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN =
      ApiErrors.forbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR =
      ApiErrors.internalServerError; // failure, crash in server side
  static const String NOT_FOUND =
      ApiErrors.notFoundError; // failure, crash in server side

  // local status code
  static String CONNECT_TIMEOUT = ApiErrors.timeoutError;
  static String CANCEL = ApiErrors.defaultError;
  static String RECIEVE_TIMEOUT = ApiErrors.timeoutError;
  static String SEND_TIMEOUT = ApiErrors.timeoutError;
  static String CACHE_ERROR = ApiErrors.cacheError;
  static String NO_INTERNET_CONNECTION = ApiErrors.noInternetError;
  static String DEFAULT = ApiErrors.defaultError;
}

extension DataSourceExtension on DataSource {
  ApiErrorModel getFailure() {
    switch (this) {
      case DataSource.NO_CONTENT:
        return const ApiErrorModel(
            code: ResponseCode.NO_CONTENT, message: ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return const ApiErrorModel(
            code: ResponseCode.BAD_REQUEST,
            message: ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return const ApiErrorModel(
            code: ResponseCode.FORBIDDEN, message: ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return const ApiErrorModel(
            code: ResponseCode.UNAUTORISED,
            message: ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return const ApiErrorModel(
            code: ResponseCode.NOT_FOUND, message: ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return const ApiErrorModel(
            code: ResponseCode.INTERNAL_SERVER_ERROR,
            message: ResponseMessage.INTERNAL_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return ApiErrorModel(
            code: ResponseCode.CONNECT_TIMEOUT,
            message: ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return ApiErrorModel(
            code: ResponseCode.CANCEL, message: ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return ApiErrorModel(
            code: ResponseCode.RECIEVE_TIMEOUT,
            message: ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return ApiErrorModel(
            code: ResponseCode.SEND_TIMEOUT,
            message: ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return ApiErrorModel(
            code: ResponseCode.CACHE_ERROR,
            message: ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return ApiErrorModel(
            code: ResponseCode.NO_INTERNET_CONNECTION,
            message: ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return ApiErrorModel(
            code: ResponseCode.DEFAULT, message: ResponseMessage.DEFAULT);
    }
  }
}

class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      apiErrorModel = _handleError(error);
    } else {
      // default error
      apiErrorModel = DataSource.DEFAULT.getFailure();
    }
  }
}

/// Extracts a display message from API response body (plain string or JSON with message/error/result).
/// For validation responses (e.g. { "error": "Validation failed", "errors": { "password": "..." } })
/// uses ApiErrorModel.displayMessage so field errors are included.
String _extractMessageFromResponse(dynamic data, [String defaultMsg = 'Something went wrong']) {
  if (data == null) return defaultMsg;
  if (data is String) return data.trim().isEmpty ? defaultMsg : data.trim();
  if (data is Map<String, dynamic>) {
    try {
      final model = ApiErrorModel.fromJson(data);
      final dm = model.displayMessage;
      if (dm.isNotEmpty && dm != 'Something went wrong') return dm;
      final m = data['message'] ?? data['error'] ?? data['result'];
      if (m is String && m.isNotEmpty) return m;
      return defaultMsg;
    } catch (_) {
      final m = data['message'] ?? data['error'] ?? data['result'];
      if (m is String && m.isNotEmpty) return m;
      return defaultMsg;
    }
  }
  return defaultMsg;
}

ApiErrorModel _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badResponse:
if (error.response?.statusCode == 403) {
  final BuildContext? ctx = MyApp.navigatorKey.currentContext;
  String message = "";

  // Check if response data is not null and not empty
  if (error.response?.data != null && error.response!.data.toString().isNotEmpty) {
    try {
      // Try to parse as ApiErrorModel to extract the message
      final errorModel = ApiErrorModel.fromJson(error.response!.data);

      // Check for message, result, errors in order (matching Angular logic)
      if (errorModel.message != null && errorModel.message!.isNotEmpty) {
        message = errorModel.message!;
      } else if (errorModel.result != null && errorModel.result!.isNotEmpty) {
        message = errorModel.result!;
      } else if (errorModel.errors != null && errorModel.errors!.isNotEmpty) {
        message = errorModel.errors![0].toString();
      } else if (ctx != null) {
        message = AppLocalizations.of(ctx)!.trans(StringConsts.notAuthorized)??"";
      }
    } catch (e) {
      // If parsing fails, fall back to localized message
      if (ctx != null) {
        message = AppLocalizations.of(ctx)!.trans(StringConsts.notAuthorized)??"";
      }
    }
  } else if (ctx != null) {
    message = AppLocalizations.of(ctx)!.trans(StringConsts.notAuthorized)??"";
  }

  errorBotToast(title: message);
  return ApiErrorModel(code: ResponseCode.FORBIDDEN, message: message);
}
      // 400 / 422: e.g. register "Username is already in use" (body may be plain string or JSON without key)
      if (error.response?.statusCode == ResponseCode.BAD_REQUEST ||
          error.response?.statusCode == ResponseCode.API_LOGIC_ERROR) {
        final data = error.response?.data;
        final message = _extractMessageFromResponse(data, ResponseMessage.BAD_REQUEST);
        return ApiErrorModel(
          code: error.response!.statusCode,
          message: message,
        );
      }
      if (error.response != null &&
          error.response?.statusCode != null &&
          error.response?.data != null &&
          error.response!.data.toString().isNotEmpty &&
          error.response?.statusCode != ResponseCode.UNAUTORISED &&
          error.response?.statusCode != ResponseCode.PAYMENT_REQUIRED &&
          error.response?.statusCode != ResponseCode.BAD_REQUEST &&
          error.response?.statusCode != ResponseCode.API_LOGIC_ERROR &&
          error.response?.statusMessage != null) {
        // Handle custom status 426: show localized toast and return message
        if (error.response?.statusCode == ResponseCode.TOO_MANY_REQUESTS_BLOCKED) {
          final BuildContext? ctx = MyApp.navigatorKey.currentContext;
           String message= "";
          if (ctx != null) {
            message = AppLocalizations.of(ctx)!.trans(StringConsts.blockedExceededRequests)??"";
          }
          // Show toast
          errorBotToast(title: message);
          return ApiErrorModel(code: ResponseCode.TOO_MANY_REQUESTS_BLOCKED, message: message);
        }
        
        // Handle custom status 460: Feature Not Enabled
        if (error.response?.statusCode == 460) {
          final BuildContext? ctx = MyApp.navigatorKey.currentContext;
          String message = "";
          if (ctx != null) {
            message = AppLocalizations.of(ctx)!.trans(StringConsts.featureNotEnabledMessage) ?? 
                "This feature is not enabled for your subscription. Please contact your administrator for assistance.";
          } else {
            message = "This feature is not enabled for your subscription. Please contact your administrator for assistance.";
          }
          // Parse error model to get message from response if available
          try {
            final errorModel = ApiErrorModel.fromJson(error.response!.data);
            if (errorModel.message != null && errorModel.message!.isNotEmpty) {
              message = errorModel.message!;
            }
          } catch (e) {
            // Use default message if parsing fails
          }
          // Show toast
          errorBotToast(title: message);
          return ApiErrorModel(code: 460, message: message);
        }
      
        // For other errors, parse JSON or use plain string body
        final data = error.response!.data;
        if (data is String && data.trim().isNotEmpty) {
          return ApiErrorModel(
            code: error.response?.statusCode ?? ResponseCode.DEFAULT,
            message: data.trim(),
          );
        }
        try {
          final errorModel = ApiErrorModel.fromJson(data as Map<String, dynamic>);
          return ApiErrorModel(
            code: errorModel.code ?? error.response?.statusCode,
            message: errorModel.message ?? _extractMessageFromResponse(data),
            result: errorModel.result,
            errors: errorModel.errors,
            isSuccess: errorModel.isSuccess,
          );
        } catch (_) {
          return ApiErrorModel(
            code: error.response?.statusCode ?? ResponseCode.DEFAULT,
            message: _extractMessageFromResponse(data),
          );
        }
      } else if (error.response?.statusCode == ResponseCode.UNAUTORISED) {
        final data = error.response?.data;
        final message = _extractMessageFromResponse(data, 'Invalid username or password');
        return ApiErrorModel(
          code: ResponseCode.UNAUTORISED,
          message: message,
        );
      } else if (error.response?.statusCode == ResponseCode.PAYMENT_REQUIRED) {
        // Handle subscription expired - navigate to subscription expired screen
      
        return ApiErrorModel(
          code: ResponseCode.PAYMENT_REQUIRED,
          message: 'Subscription expired',
        );
      } else {
        return DataSource.DEFAULT.getFailure();
      }
    case DioExceptionType.unknown:
      // Server may return plain text (e.g. "Invalid username or password") causing FormatException when parsed as JSON
      if (error.response != null && error.response?.statusCode != null) {
        final data = error.response!.data;
        final statusCode = error.response!.statusCode!;
        String defaultMsg = 'Something went wrong';
        if (statusCode == ResponseCode.UNAUTORISED) defaultMsg = 'Invalid username or password';
        if (statusCode == ResponseCode.BAD_REQUEST) defaultMsg = ResponseMessage.BAD_REQUEST;
        final message = _extractMessageFromResponse(data, defaultMsg);
        return ApiErrorModel(code: statusCode, message: message);
      }
      // FormatException: server returned plain text (e.g. "Username is already in use"). Use path to pick message.
      if (error.error is FormatException) {
        final path = error.requestOptions.uri.path;
        final bool isLogin = path.contains('auth/login');
        final bool isRegister = path.contains('auth/register');
        String message = 'Invalid response from server. Please try again.';
        int code = ResponseCode.DEFAULT;
        if (isLogin) {
          message = 'Invalid username or password';
          code = ResponseCode.UNAUTORISED;
        } else if (isRegister) {
          message = 'Username is already in use';
          code = ResponseCode.BAD_REQUEST;
        }
        return ApiErrorModel(code: code, message: message);
      }
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.NO_INTERNET_CONNECTION.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.INTERNAL_SERVER_ERROR.getFailure();
  }
}

String checkErrorType(ApiErrorModel apiErrorModel) {
  List<dynamic> finalValue = [];
  if (apiErrorModel.result != null) {
    return apiErrorModel.result!;
  } else if (apiErrorModel.errors != null) {
    apiErrorModel.errors?.forEach((element) {
      finalValue.add(element);
    });
    for (var element in finalValue) {
      return element;
    }
  }
  return apiErrorModel.message!;
}
