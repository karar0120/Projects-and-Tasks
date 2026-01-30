import 'package:hive/hive.dart';

/// Hive model for upload job persistence
/// Stores upload jobs that can be resumed even after app restart
/// Job handles ONLY attachments - stores presigned URLs for S3 upload
class UploadJobModel extends HiveObject {
  final String id;
  final String inspectionId;
  final int questionId;
  final List<String> filePaths; // Paths to files in documents directory
  final String presignedUrlsJson; // Serialized presigned URLs: [{fileName, s3Key, presignedUrl, contentType}]
  final DateTime createdAt;
  DateTime? lastAttemptAt;
  int retryCount;
  String status; // 'pending', 'uploading', 'completed', 'failed'
  double progress;
  String? errorMessage;

  UploadJobModel({
    required this.id,
    required this.inspectionId,
    required this.questionId,
    required this.filePaths,
    required this.presignedUrlsJson, // Presigned URLs for S3 upload
    required this.createdAt,
    this.lastAttemptAt,
    this.retryCount = 0,
    this.status = 'pending',
    this.progress = 0.0,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inspectionId': inspectionId,
      'questionId': questionId,
      'filePaths': filePaths,
      'presignedUrlsJson': presignedUrlsJson,
      'createdAt': createdAt.toIso8601String(),
      'lastAttemptAt': lastAttemptAt?.toIso8601String(),
      'retryCount': retryCount,
      'status': status,
      'progress': progress,
      'errorMessage': errorMessage,
    };
  }

  factory UploadJobModel.fromJson(Map<String, dynamic> json) {
    return UploadJobModel(
      id: json['id'] as String,
      inspectionId: json['inspectionId'] as String,
      questionId: json['questionId'] as int,
      filePaths: List<String>.from(json['filePaths'] as List),
      presignedUrlsJson: json['presignedUrlsJson'] as String? ?? json['existingAttachmentsJson'] as String? ?? '[]', // Support legacy format
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAttemptAt: json['lastAttemptAt'] != null
          ? DateTime.parse(json['lastAttemptAt'] as String)
          : null,
      retryCount: json['retryCount'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

/// Hive TypeAdapter for UploadJobModel
class UploadJobModelAdapter extends TypeAdapter<UploadJobModel> {
  @override
  final int typeId = 0;

  @override
  UploadJobModel read(BinaryReader reader) {
    final json = Map<String, dynamic>.from(reader.readMap());
    return UploadJobModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, UploadJobModel obj) {
    writer.writeMap(obj.toJson());
  }
}
