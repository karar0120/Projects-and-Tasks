import 'package:equatable/equatable.dart';

class ApiErrorModel extends Equatable {
  final String? result;
  final String? message;
  final int? code;
  final List<dynamic>? errors;
  final bool? isSuccess;
  /// Validation errors as map (e.g. {"email": "...", "password": "..."}).
  final Map<String, dynamic>? errorsMap;

  const ApiErrorModel({
    required this.message,
    this.code,
    this.result,
    this.errors,
    this.isSuccess,
    this.errorsMap,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'];
    Map<String, dynamic>? errorsMap;
    List<dynamic>? errorsList;
    if (rawErrors is Map<String, dynamic>) {
      errorsMap = rawErrors;
      errorsList = rawErrors.values.toList();
    } else if (rawErrors is List) {
      errorsList = rawErrors;
    }
    return ApiErrorModel(
      result: json['result'] as String?,
      message: (json['message'] ?? json['error']) as String?,
      code: (json['code'] ?? json['status']) as int?,
      errors: errorsList,
      errorsMap: errorsMap,
      isSuccess: json['isSuccess'],
    );
  }

  /// Single message for display: summary + validation field errors.
  /// Handles API format: { "error": "Validation failed", "errors": { "password": "...", "email": "..." } }
  String get displayMessage {
    final parts = <String>[];
    final summary = message ?? result;
    if (summary != null && summary.isNotEmpty) {
      parts.add(summary);
    }
    if (errorsMap != null && errorsMap!.isNotEmpty) {
      for (final entry in errorsMap!.entries) {
        final value = entry.value;
        if (value is String && value.isNotEmpty) {
          parts.add(value);
        }
      }
    } else if (errors != null && errors!.isNotEmpty) {
      for (final e in errors!) {
        if (e != null && e.toString().isNotEmpty) {
          parts.add(e.toString());
        }
      }
    }
    if (parts.isEmpty) return 'Something went wrong';
    return parts.join('. ');
  }

  @override
  List<Object?> get props => [
        message,
        code,
        result,
        errors,
        isSuccess,
        errorsMap,
      ];
}
