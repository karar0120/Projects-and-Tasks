import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:projectsandtasks/core/network/dio_consumer.dart';

/// Simple wrapper around `background_downloader` for media uploads.
///
/// This does NOT decide the upload URL or headers – you pass them from
/// your repository/API layer. It only:
/// - creates an `UploadTask` for a single file
/// - allows mobile data & Wi‑Fi by setting `requiresWiFi: false`
/// - configures basic automatic retries.
class BackgroundUploadService {
  BackgroundUploadService._();
  static final BackgroundUploadService instance = BackgroundUploadService._();

  /// Start a single file upload in the background.
  ///
  /// [url]      -> your API upload endpoint
  /// [file]     -> compressed/validated file to upload
  /// [fieldName] -> multipart field name (default: "file")
  /// [headers]  -> authorization headers etc.
  /// [fields]   -> extra form fields (e.g. questionId, inspectionId)
  Future<UploadTask> uploadFile({
    required String url,
    required File file,
    String fieldName = 'file',
    Map<String, String>? headers,
    Map<String, String>? fields,
  }) async {
    final filename = file.path.split('/').last;

    final task = UploadTask(
      url: url,
      filename: filename,
      fileField: fieldName,
      headers: headers ?? const {},
      fields: fields ?? const {},
      requiresWiFi: false, // allow mobile data OR Wi‑Fi
      retries: 3, // automatic retries handled by background_downloader
    );

    // Fire-and-forget; background_downloader will handle retries and background work.
    await FileDownloader().upload(task);
    return task;
  }

  /// Upload a file to S3 using a pre-signed URL (PUT request).
  ///
  /// This method uploads files to S3 using PUT requests.
  /// S3 pre-signed URLs require a PUT request with the file bytes directly.
  /// Note: Retry logic is handled by BackgroundUploadWorker at the job level.
  ///
  /// [presignedUrl] -> S3 pre-signed URL for PUT request
  /// [file]         -> File to upload
  /// [contentType]  -> Content-Type header (e.g., "image/jpeg", "video/mp4")
  /// [headers]      -> Additional headers (Content-Length will be added automatically)
  /// [onProgress]   -> Optional progress callback (0.0 to 1.0)
  ///
  /// Returns: true if upload succeeded, false otherwise
  /// Throws: Exception if upload fails (retries are handled by BackgroundUploadWorker)
  Future<bool> uploadToS3({
    required String presignedUrl,
    required File file,
    required String contentType,
    Map<String, String>? headers,
    Function(double progress)? onProgress,
  }) async {
    final filename = file.path.split('/').last;
    final fileSize = await file.length();

    debugPrint('📤 Starting S3 upload: $filename (${fileSize} bytes)');
    debugPrint('🔗 Pre-signed URL: $presignedUrl');
    debugPrint('📝 Content-Type: $contentType');

    try {
      // Read file bytes
      final fileBytes = file.readAsBytesSync();

      // Prepare headers for S3 PUT request
      final uploadHeaders = <String, String>{
        'Content-Type': contentType,
        'Content-Length': fileSize.toString(),
        if (headers != null) ...headers,
      };

      // Report initial progress
      onProgress?.call(0.1);

      // Perform PUT request to S3 using WebService
      final response = await WebService.putNoLang(
        headers: uploadHeaders,
        isFromS3: true,
        body: fileBytes,
        controller: presignedUrl,
      );

      // Report progress
      onProgress?.call(0.9);

      // Handle response using Either fold
      final success = response.fold(
        (error) {
          debugPrint('❌ S3 upload failed: ${error.message}');
          throw Exception('S3 upload failed: ${error.message}');
        },
        (result) {
          if (result.statusCode == 200) {
            debugPrint('✅ S3 upload completed: $filename');
            onProgress?.call(1.0);
            return true;
          } else {
            debugPrint('❌ S3 upload failed with status: ${result.statusCode}');
            throw Exception('S3 upload failed with status: ${result.statusCode}');
          }
        },
      );

      return success;
    } catch (e) {
      debugPrint('❌ Error uploading to S3: $e');
      // Re-throw exception - BackgroundUploadWorker will handle retries at job level
      rethrow;
    }
  }
}

