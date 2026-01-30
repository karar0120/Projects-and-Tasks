import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';

class DateTimeUtils {
  /// Converts backend UTC string (even without "Z") to device local time
  /// Localized using provided [localeTag] or app language from LocaleServices
  static String utcToLocal(String? isoUtc, {String? localeTag, String? pattern}) {
    if (isoUtc == null || isoUtc.isEmpty) return '';

    try {
      // Normalize: ensure it's parsed as UTC even if "Z" is missing
      final normalized = isoUtc.endsWith('Z') ? isoUtc : '${isoUtc}Z';
      final utcDate = DateTime.parse(normalized).toUtc();

      // Convert to device local timezone
      final localDate = tz.TZDateTime.from(utcDate, tz.local);

      // Localized format using intl
      final lang = localeTag ?? (LocaleServices.getString(key: CacheConsts.language) ?? 'en');
      final fmt = DateFormat(pattern ?? 'dd-MM-yyyy hh:mm a', lang);
      return fmt.format(localDate);
    } catch (e) {
      return isoUtc;
    }
  }
}
