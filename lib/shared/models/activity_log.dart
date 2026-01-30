import 'dart:io';

/// Generic Activity Log Type Enum (can be extended per feature)
enum ActivityLogTypeEnum {
  change(1),
  comment(2),
  attachment(3),
  auto(4);

  final int value;
  const ActivityLogTypeEnum(this.value);

  static ActivityLogTypeEnum? fromString(String? type) {
    if (type == null) return null;
    switch (type.toLowerCase()) {
      case 'change':
        return ActivityLogTypeEnum.change;
      case 'comment':
        return ActivityLogTypeEnum.comment;
      case 'attachment':
        return ActivityLogTypeEnum.attachment;
      case 'auto':
        return ActivityLogTypeEnum.auto;
      default:
        return null;
    }
  }

  static ActivityLogTypeEnum? fromInt(int? value) {
    if (value == null) return null;
    switch (value) {
      case 1:
        return ActivityLogTypeEnum.change;
      case 2:
        return ActivityLogTypeEnum.comment;
      case 3:
        return ActivityLogTypeEnum.attachment;
      case 4:
        return ActivityLogTypeEnum.auto;
      default:
        return null;
    }
  }
}

/// Generic Activity Log Model (reusable across features)
class ActivityLog {
  final int id;
  final DateTime creationTime;
  final int? creatorUserId;
  final String? creatorFullName;
  final String? creatorName;
  final String? creatorSurname;
  final bool isByCurrentUser;
  final int? profilePictureId;
  final String type; // "Auto", "Change", "Comment", "Attachment"
  final ActivityLogMessage log;
  final List<ActivityLogAttachment>? attachments;

  ActivityLog({
    required this.id,
    required this.creationTime,
    this.creatorUserId,
    this.creatorFullName,
    this.creatorName,
    this.creatorSurname,
    required this.isByCurrentUser,
    this.profilePictureId,
    required this.type,
    required this.log,
    this.attachments,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    // Parse creationTime as UTC and convert to local
    final creationTimeStr = json['creationTime'] as String;
    DateTime localTime;
    try {
      // Parse the string - if it doesn't have timezone, assume UTC
      DateTime parsed;
      if (creationTimeStr.endsWith('Z')) {
        // Has Z, parse as UTC
        parsed = DateTime.parse(creationTimeStr);
      } else if (creationTimeStr.contains('+') || creationTimeStr.contains('-')) {
        // Has timezone offset, parse as is
        parsed = DateTime.parse(creationTimeStr);
      } else {
        // No timezone indicator - assume UTC and add Z
        parsed = DateTime.parse('${creationTimeStr}Z');
      }

      // Ensure we have UTC time
      final utcTime = parsed.isUtc
          ? parsed
          : DateTime.utc(
              parsed.year,
              parsed.month,
              parsed.day,
              parsed.hour,
              parsed.minute,
              parsed.second,
              parsed.millisecond,
              parsed.microsecond,
            );

      // Convert to local time
      localTime = utcTime.toLocal();
    } catch (e) {
      // Fallback: try parsing directly and assume it's already in local or UTC
      try {
        final parsed = DateTime.parse(creationTimeStr);
        // If no timezone info, assume UTC
        if (!parsed.isUtc && !creationTimeStr.contains('+') && !creationTimeStr.contains('-') && !creationTimeStr.endsWith('Z')) {
          final utcTime = DateTime.utc(
            parsed.year,
            parsed.month,
            parsed.day,
            parsed.hour,
            parsed.minute,
            parsed.second,
            parsed.millisecond,
            parsed.microsecond,
          );
          localTime = utcTime.toLocal();
        } else {
          localTime = parsed.toLocal();
        }
      } catch (e2) {
        // Last resort: use current time
        localTime = DateTime.now();
      }
    }

    return ActivityLog(
      id: json['id'] as int,
      creationTime: localTime,
      creatorUserId: json['creatorUserId'] as int?,
      creatorFullName: json['creatorFullName'] as String?,
      creatorName: json['creatorName'] as String?,
      creatorSurname: json['creatorSurname'] as String?,
      isByCurrentUser: json['isByCurrentUser'] as bool? ?? false,
      profilePictureId: json['profilePictureId'] as int?,
      type: _parseType(json['type']),
      log: ActivityLogMessage.fromJson(json['log'] as Map<String, dynamic>),
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
              .map((e) => ActivityLogAttachment.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creationTime': creationTime.toIso8601String(),
      if (creatorUserId != null) 'creatorUserId': creatorUserId,
      if (creatorFullName != null) 'creatorFullName': creatorFullName,
      if (creatorName != null) 'creatorName': creatorName,
      if (creatorSurname != null) 'creatorSurname': creatorSurname,
      'isByCurrentUser': isByCurrentUser,
      if (profilePictureId != null) 'profilePictureId': profilePictureId,
      'type': type,
      'log': log.toJson(),
      if (attachments != null && attachments!.isNotEmpty)
        'attachments': attachments!.map((e) => e.toJson()).toList(),
    };
  }

  /// Get display name for the creator
  String get displayName {
    if (creatorFullName != null && creatorFullName!.isNotEmpty) {
      return creatorFullName!;
    }
    if (creatorName != null && creatorSurname != null) {
      return '$creatorName $creatorSurname';
    }
    if (creatorName != null) {
      return creatorName!;
    }
    return 'Unknown';
  }

  /// Get message text based on current locale
  String getMessageText(String? locale) {
    if (locale == 'ar' && log.messageAr != null && log.messageAr!.isNotEmpty) {
      return log.messageAr!;
    }
    return log.messageEn ?? '';
  }

  /// Parse type from JSON (handles both string and int)
  static String _parseType(dynamic typeValue) {
    if (typeValue == null) return 'Auto';

    // If it's already a string, return it
    if (typeValue is String) {
      return typeValue;
    }

    // If it's an int, convert to string enum name
    if (typeValue is int) {
      final enumType = ActivityLogTypeEnum.fromInt(typeValue);
      switch (enumType) {
        case ActivityLogTypeEnum.change:
          return 'Change';
        case ActivityLogTypeEnum.comment:
          return 'Comment';
        case ActivityLogTypeEnum.attachment:
          return 'Attachment';
        case ActivityLogTypeEnum.auto:
          return 'Auto';
        default:
          return 'Auto';
      }
    }

    return 'Auto';
  }

  /// Get activity log type enum
  ActivityLogTypeEnum? get typeEnum {
    return ActivityLogTypeEnum.fromString(type);
  }

  /// Check if this is an attachment type log
  bool get isAttachmentType => typeEnum == ActivityLogTypeEnum.attachment;

  /// Check if this is a comment type log
  bool get isCommentType => typeEnum == ActivityLogTypeEnum.comment;

  /// Check if this is a change type log
  bool get isChangeType => typeEnum == ActivityLogTypeEnum.change;

  /// Check if this is an auto type log
  bool get isAutoType => typeEnum == ActivityLogTypeEnum.auto;
}

/// Generic Activity Log Message Model
class ActivityLogMessage {
  final String? localizedKey;
  String? comment;
  final String? messageAr;
  final String? messageEn;
  final String type;
  final bool isNotifiable;
  // Attachment fields (when type is "Attachment")
  final String? attachmentId;
  final String? s3Key;
  final String? fileType;
  final String? fileName;

  ActivityLogMessage({
    this.localizedKey,
    this.comment,
    this.messageAr,
    this.messageEn,
    required this.type,
    this.isNotifiable = false,
    this.attachmentId,
    this.s3Key,
    this.fileType,
    this.fileName,
  });

  factory ActivityLogMessage.fromJson(Map<String, dynamic> json) {
    return ActivityLogMessage(
      localizedKey: json['localizedKey'] as String?,
      comment: json['comment'] as String?,
      messageAr: json['messageAr'] as String?,
      messageEn: json['messageEn'] as String?,
      type: json['type'] as String? ?? 'Auto',
      isNotifiable: json['isNotifiable'] as bool? ?? false,
      attachmentId: json['attachmentId'] as String?,
      s3Key: json['s3Key'] as String?,
      fileType: json['fileType'] as String?,
      fileName: json['fileName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (localizedKey != null) 'localizedKey': localizedKey,
      if (comment != null) 'comment': comment,
      if (messageAr != null) 'messageAr': messageAr,
      if (messageEn != null) 'messageEn': messageEn,
      'type': type,
      'isNotifiable': isNotifiable,
      if (attachmentId != null) 'attachmentId': attachmentId,
      if (s3Key != null) 's3Key': s3Key,
      if (fileType != null) 'fileType': fileType,
      if (fileName != null) 'fileName': fileName,
    };
  }

  /// Convert log attachment data to ActivityLogAttachment if available
  ActivityLogAttachment? toAttachment() {
    if (s3Key == null || fileName == null || fileType == null) {
      return null;
    }
    return ActivityLogAttachment(
      id: attachmentId != null ? int.tryParse(attachmentId!) : null,
      fileName: fileName!,
      s3Key: s3Key!,
      fileSize: 0, // File size not available in log
      contentType: fileType!,
      downloadUrl: null,
    );
  }
}

/// Generic Paged Response Model for Activity Logs
class ActivityLogsPagedResponse {
  final List<ActivityLog> items;
  final int? totalCount;

  ActivityLogsPagedResponse({
    required this.items,
    this.totalCount,
  });

  factory ActivityLogsPagedResponse.fromJson(Map<String, dynamic> json) {
    return ActivityLogsPagedResponse(
      items: (json['items'] as List? ?? [])
          .map((e) => ActivityLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int?,
    );
  }
}

/// Generic Activity Log Attachment Model
class ActivityLogAttachment {
  final int? id;
  final String fileName;
  final String s3Key;
  final int fileSize;
  final String contentType;
  final String? downloadUrl; // For display

  ActivityLogAttachment({
    this.id,
    required this.fileName,
    required this.s3Key,
    required this.fileSize,
    required this.contentType,
    this.downloadUrl,
  });

  factory ActivityLogAttachment.fromJson(Map<String, dynamic> json) {
    return ActivityLogAttachment(
      id: json['id'] as int?,
      fileName: json['fileName'] as String,
      s3Key: json['s3Key'] as String,
      fileSize: json['fileSize'] as int,
      contentType: json['contentType'] as String,
      downloadUrl: json['downloadUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'fileName': fileName,
      's3Key': s3Key,
      'fileSize': fileSize,
      'contentType': contentType,
      if (downloadUrl != null) 'downloadUrl': downloadUrl,
    };
  }
}

/// Pending attachment (before upload)
class PendingActivityLogAttachment {
  final File file;
  final String fileName;
  final String contentType;
  final int fileSize;

  PendingActivityLogAttachment({
    required this.file,
    required this.fileName,
    required this.contentType,
    required this.fileSize,
  });
}
