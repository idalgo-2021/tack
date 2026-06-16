import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/note.dart';
import '../../settings/providers/settings_provider.dart';

class NoteCard extends ConsumerWidget {
  final Note note;
  final VoidCallback onTap;
  final bool isSelected;
  final bool showSelectionCheck;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.isSelected = false,
    this.showSelectionCheck = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showFilenames = ref.watch(showFileNamesProvider);
    final showTs = ref.watch(showTimestampProvider);
    final viewMode = ref.watch(viewModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final hasCoords = note.latitude != null && note.longitude != null;

    final card = Card(
      margin: viewMode == ViewMode.grid
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isSelected ? colorScheme.primaryContainer.withAlpha(100) : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showSelectionCheck)
                Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              if (showTs)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: viewMode == ViewMode.grid
                      ? Text(
                          DateFormatter.formatAbsoluteWithWeekday(note.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        )
                      : Text(
                          DateFormatter.formatAbsoluteWithWeekday(note.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                ),
              if (note.text != null && note.text!.isNotEmpty)
                _buildTextSection(note.text!, _textStyle(theme, fontSize), colorScheme, viewMode),
              if (note.imagePaths.isNotEmpty || note.audioPaths.isNotEmpty || note.filePaths.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      if (note.imagePaths.isNotEmpty)
                        _MediaBadge(icon: Icons.image, count: note.imagePaths.length, colorScheme: colorScheme, theme: theme),
                      if (note.audioPaths.isNotEmpty)
                        _MediaBadge(icon: Icons.mic, count: note.audioPaths.length, colorScheme: colorScheme, theme: theme),
                      if (note.filePaths.isNotEmpty)
                        _MediaBadge(icon: Icons.attach_file, count: note.filePaths.length, colorScheme: colorScheme, theme: theme),
                    ],
                  ),
                ),
              if (showFilenames && _allFiles(note).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _allFiles(note).map((p) => Text(
                      p.split('/').last,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )).toList(),
                  ),
                ),
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildTags(note.tags, viewMode, colorScheme),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatRelative(context, note.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (hasCoords) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.location_on, size: 14, color: colorScheme.onSurfaceVariant),
                    if (viewMode == ViewMode.list) ...[
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDMS(note.latitude!, note.longitude!),
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return card;
  }

  TextStyle _textStyle(ThemeData theme, FontSize size) {
    final base = theme.textTheme.bodyLarge!;
    switch (size) {
      case FontSize.small:
        return base.copyWith(fontSize: 14);
      case FontSize.medium:
        return base;
      case FontSize.large:
        return base.copyWith(fontSize: 20);
    }
  }

  Widget _buildTextSection(String text, TextStyle style, ColorScheme colors, ViewMode mode) {
    final maxLines = mode == ViewMode.list ? 3 : 6;
    final isList = mode == ViewMode.list;

    TextSpan buildSpan() {
      if (!isList) return TextSpan(text: text, style: style);
      final firstNewline = text.indexOf('\n');
      if (firstNewline == -1) {
        return TextSpan(children: [
          TextSpan(text: text, style: style.copyWith(fontWeight: FontWeight.w700)),
        ]);
      }
      return TextSpan(children: [
        TextSpan(text: text.substring(0, firstNewline), style: style.copyWith(fontWeight: FontWeight.w700)),
        TextSpan(text: text.substring(firstNewline), style: style),
      ]);
    }

    final span = buildSpan();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        if (!tp.didExceedMaxLines) {
          return Text.rich(span, maxLines: maxLines, overflow: TextOverflow.ellipsis);
        }

        final tpFull = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        final hidden = max(0, tpFull.computeLineMetrics().length - maxLines);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(span, maxLines: maxLines, overflow: TextOverflow.ellipsis),
            if (hidden > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+$hidden',
                  style: style.copyWith(fontSize: 11, color: colors.primary),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTags(List<String> tags, ViewMode mode, ColorScheme colors) {
    final items = mode == ViewMode.grid ? _limitedTags(tags) : tags;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: items.map((item) {
        final isOverflow = item is int;
        return Chip(
          label: Text(
            isOverflow ? '+$item' : '#$item',
            style: const TextStyle(fontSize: 12),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
          backgroundColor: isOverflow ? colors.surfaceContainerHighest : null,
        );
      }).toList(),
    );
  }

  List<Object> _limitedTags(List<String> tags) {
    if (tags.length <= 5) return tags;
    return [...tags.take(5), tags.length - 5];
  }

  List<String> _allFiles(Note note) => [...note.imagePaths, ...note.audioPaths, ...note.filePaths];
}

class _MediaBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _MediaBadge({required this.icon, required this.count, required this.colorScheme, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text('$count', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
