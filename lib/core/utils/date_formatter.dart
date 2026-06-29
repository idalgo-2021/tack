import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class DateFormatter {
  static String _format(DateTime date, String pattern, [String? locale]) {
    final format = DateFormat(pattern, locale);
    return format.format(date);
  }

  static String formatAbsolute(DateTime date, [String? locale]) {
    return _format(date, 'dd.MM.yyyy HH:mm', locale);
  }

  static String formatAbsoluteWithWeekday(DateTime date, [String? locale]) {
    return '${_format(date, 'dd.MM.yyyy HH:mm', locale)} (${_format(date, 'E', locale)})';
  }

  static String formatRelative(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inHours < 1) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.hoursAgo(diff.inHours);
    return l10n.daysAgo(diff.inDays);
  }

  static String formatFileDate(DateTime date, [String? locale]) {
    return _format(date, 'yyyy-MM-dd_HHmmss', locale);
  }

  static String formatDMS(double lat, double lon) {
    String dms(double value, String pos, String neg) {
      final abs = value.abs();
      final d = abs.floor();
      final m = ((abs - d) * 60).toStringAsFixed(0);
      return '$d°$m′${value >= 0 ? pos : neg}';
    }
    return '${dms(lat, 'N', 'S')}, ${dms(lon, 'E', 'W')}';
  }

  static String formatDayGroup(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return l10n.dateToday;
    if (diff == 1) return l10n.dateYesterday;
    return _format(date, 'd MMMM yyyy', Localizations.localeOf(context).languageCode);
  }

  static String formatWeekGroup(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final week = _format(date, 'w', Localizations.localeOf(context).languageCode);
    return l10n.dateWeekHeader(week, date.year.toString());
  }

  static String formatMonthGroup(BuildContext context, DateTime date) {
    return _format(date, 'LLLL yyyy', Localizations.localeOf(context).languageCode);
  }
}
