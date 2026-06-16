import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class DateFormatter {
  static String formatAbsolute(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  static String formatAbsoluteWithWeekday(DateTime date) {
    return '${DateFormat('dd.MM.yyyy HH:mm').format(date)} (${DateFormat('E').format(date)})';
  }

  static String formatRelative(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inHours < 1) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.daysAgo(diff.inDays);

    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }

  static String formatFileDate(DateTime date) {
    return DateFormat('yyyy-MM-dd_HHmmss').format(date);
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
    return DateFormat('d MMMM yyyy').format(date);
  }

  static String formatWeekGroup(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context);
    final week = DateFormat('w').format(date);
    return l10n.dateWeekHeader(week, date.year.toString());
  }

  static String formatMonthGroup(BuildContext context, DateTime date) {
    return DateFormat('LLLL yyyy').format(date);
  }
}
