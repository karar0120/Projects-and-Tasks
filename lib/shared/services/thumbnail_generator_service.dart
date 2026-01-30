import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

/// Service for generating thumbnails from videos and PDFs
class ThumbnailGeneratorService {
  ThumbnailGeneratorService._();
  static final ThumbnailGeneratorService instance = ThumbnailGeneratorService._();

  // Cache directory for thumbnails
  Directory? _thumbnailCacheDir;

  /// Initialize thumbnail cache directory
  Future<void> initialize() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      _thumbnailCacheDir = Directory(path.join(docDir.path, 'thumbnails'));

      if (!await _thumbnailCacheDir!.exists()) {
        await _thumbnailCacheDir!.create(recursive: true);
        debugPrint('✅ Thumbnail cache directory created: ${_thumbnailCacheDir!.path}');
      }
    } catch (e) {
      debugPrint('❌ Error initializing thumbnail cache: $e');
    }
  }

  /// Get cache directory, initialize if needed
  Future<Directory> _getCacheDir() async {
    if (_thumbnailCacheDir == null) {
      await initialize();
    }
    return _thumbnailCacheDir!;
  }

  /// Generate thumbnail from video file
  /// Returns path to thumbnail file or null if generation fails
  Future<String?> generateVideoThumbnail(File videoFile) async {
    try {
      final fileName = path.basenameWithoutExtension(videoFile.path);
      final thumbnailFileName = '${fileName}_thumb.jpg';

      final cacheDir = await _getCacheDir();
      final thumbnailPath = path.join(cacheDir.path, thumbnailFileName);

      // Check if thumbnail already exists in cache
      final cachedThumbnail = File(thumbnailPath);
      if (await cachedThumbnail.exists()) {
        // Verify cached thumbnail is valid
        try {
          final fileSize = await cachedThumbnail.length();
          if (fileSize > 0) {
            debugPrint('✅ Using cached video thumbnail: $thumbnailPath (${fileSize} bytes)');
            return thumbnailPath;
          } else {
            debugPrint('⚠️ Cached thumbnail is empty, regenerating');
            await cachedThumbnail.delete();
          }
        } catch (e) {
          debugPrint('⚠️ Error checking cached thumbnail: $e');
          await cachedThumbnail.delete();
        }
      }

      debugPrint('🎬 Generating video thumbnail for: ${videoFile.path}');

      // Check if video file exists and has size
      if (!await videoFile.exists()) {
        debugPrint('❌ Video file does not exist: ${videoFile.path}');
        return null;
      }

      final videoSize = await videoFile.length();
      if (videoSize == 0) {
        debugPrint('❌ Video file is empty: ${videoFile.path}');
        return null;
      }

      debugPrint('📹 Video file size: ${videoSize} bytes');

      // Generate thumbnail using video_thumbnail package (more compatible than video_compress)
      final thumbnailData = await VideoThumbnail.thumbnailData(
        video: videoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400, // Max thumbnail width
        quality: 75, // JPEG quality
        timeMs: 500, // Get frame at 0.5 seconds
      );

      if (thumbnailData != null && thumbnailData.isNotEmpty) {
        debugPrint('📸 Generated thumbnail size: ${thumbnailData.length} bytes');

        // Write thumbnail data to file
        final thumbnailFile = File(thumbnailPath);
        await thumbnailFile.writeAsBytes(thumbnailData);

        // Verify the saved thumbnail
        if (await thumbnailFile.exists()) {
          final savedSize = await thumbnailFile.length();
          debugPrint('✅ Video thumbnail generated and cached: $thumbnailPath (${savedSize} bytes)');
          return thumbnailPath;
        } else {
          debugPrint('❌ Failed to save thumbnail to cache');
          return null;
        }
      } else {
        debugPrint('⚠️ VideoThumbnail returned null or empty data');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error generating video thumbnail: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Generate thumbnail from PDF file (first page)
  /// Note: This is a placeholder - requires native PDF rendering
  /// You may need to add a PDF package like 'pdf_render' or 'native_pdf_renderer'
  Future<String?> generatePdfThumbnail(File pdfFile) async {
    try {
      // TODO: Implement PDF thumbnail generation when a PDF package is added
      // For now, return null (will show placeholder icon)
      debugPrint('⚠️ PDF thumbnail generation not yet implemented');
      return null;
    } catch (e) {
      debugPrint('❌ Error generating PDF thumbnail: $e');
      return null;
    }
  }

  /// Clear thumbnail cache
  Future<void> clearCache() async {
    try {
      final cacheDir = await _getCacheDir();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create(); // Recreate empty directory
        debugPrint('✅ Thumbnail cache cleared');
      }
    } catch (e) {
      debugPrint('❌ Error clearing thumbnail cache: $e');
    }
  }

  /// Get cache size in bytes
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await _getCacheDir();
      if (!await cacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      debugPrint('❌ Error calculating cache size: $e');
      return 0;
    }
  }

  /// Clean up old thumbnails (older than 7 days)
  Future<void> cleanupOldThumbnails() async {
    try {
      final cacheDir = await _getCacheDir();
      if (!await cacheDir.exists()) {
        return;
      }

      final cutoffDate = DateTime.now().subtract(const Duration(days: 7));
      int deletedCount = 0;

      await for (final entity in cacheDir.list(recursive: false)) {
        if (entity is File) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await entity.delete();
            deletedCount++;
          }
        }
      }

      if (deletedCount > 0) {
        debugPrint('🗑️ Cleaned up $deletedCount old thumbnails');
      }
    } catch (e) {
      debugPrint('❌ Error cleaning up old thumbnails: $e');
    }
  }
}
