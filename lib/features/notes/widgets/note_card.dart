import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/file_utils.dart';
import '../../../data/models/note.dart';
import '../../settings/providers/settings_provider.dart';

class NoteCard extends ConsumerWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool showSelectionCheck;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.showSelectionCheck = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final showTs = ref.watch(showTimestampProvider);
    final viewMode = ref.watch(viewModeProvider);
    final hasCoords = note.latitude != null && note.longitude != null;
    final cameraImageCount = note.imagePaths.where(FileUtils.isCameraFile).length;
    final cameraVideoCount = note.videoPaths.where(FileUtils.isCameraFile).length;
    final fileCount = note.imagePaths.length - cameraImageCount
        + note.videoPaths.length - cameraVideoCount
        + note.filePaths.length;

    final noteColor = note.color != null ? Color(note.color!) : null;

    final card = Card(
      margin: viewMode == ViewMode.grid
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isSelected
          ? (noteColor != null
              ? Color.lerp(noteColor, Colors.black, 0.25)!
              : colorScheme.primaryContainer.withAlpha(100))
          : noteColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (note.isPinned)
              Container(height: 4, color: colorScheme.primary),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: showTs ? 6 : 0),
                        child: showTs
                            ? (viewMode == ViewMode.grid
                                ? Text(
                                    DateFormatter.formatAbsoluteWithWeekday(note.updatedAt, Localizations.localeOf(context).languageCode),
                                    style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                  )
                                : Text(
                                    DateFormatter.formatAbsoluteWithWeekday(note.updatedAt, Localizations.localeOf(context).languageCode),
                                    style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                  ))
                            : const SizedBox.shrink(),
                      ),
                      if (note.text != null && note.text!.isNotEmpty)
                        _buildRichTextPreview(note.text!, theme.textTheme.bodyLarge!, colorScheme, viewMode),
                      if (cameraImageCount > 0 || cameraVideoCount > 0 || note.audioPaths.isNotEmpty || fileCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              if (cameraImageCount > 0)
                                _MediaBadge(icon: Icons.photo_camera, count: cameraImageCount, colorScheme: colorScheme, theme: theme),
                              if (cameraVideoCount > 0)
                                _MediaBadge(icon: Icons.videocam, count: cameraVideoCount, colorScheme: colorScheme, theme: theme),
                              if (note.audioPaths.isNotEmpty)
                                _MediaBadge(icon: Icons.mic, count: note.audioPaths.length, colorScheme: colorScheme, theme: theme),
                              if (fileCount > 0)
                                _MediaBadge(icon: Icons.attach_file, count: fileCount, colorScheme: colorScheme, theme: theme),
                            ],
                          ),
                        ),
                      if (note.tagNames.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildTags(note.tagNames, viewMode, colorScheme),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                            Text(
                              DateFormatter.formatRelative(context, note.updatedAt),
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
              if (showSelectionCheck)
                switch (viewMode) {
                  ViewMode.grid => Positioned(
                    right: -7,
                    bottom: -7,
                    child: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                      size: 26,
                    ),
                  ),
                  ViewMode.list => Positioned(
                    right: 6,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        size: 26,
                      ),
                    ),
                  ),
                },
              if (note.isPinned)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(Icons.push_pin, size: 20, color: colorScheme.primary),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return card;
  }

  Widget _buildRichTextPreview(String text, TextStyle style, ColorScheme colors, ViewMode mode) {
    final doc = Note.parseText(text);
    if (doc == null) return const SizedBox.shrink();

    final maxLines = mode == ViewMode.list ? 3 : 6;
    final plainText = doc.toPlainText().trim();
    if (plainText.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final tp = TextPainter(
          text: TextSpan(text: plainText, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        final editor = QuillEditor.basic(
          controller: QuillController(
            document: doc,
            selection: const TextSelection.collapsed(offset: 0),
          ),
          focusNode: FocusNode(),
          configurations: QuillEditorConfigurations(
            scrollable: false,
            expands: false,
            showCursor: false,
            padding: EdgeInsets.zero,
            textCapitalization: TextCapitalization.none,
          ),
        );

        if (!tp.didExceedMaxLines) return IgnorePointer(child: editor);

        final tpFull = TextPainter(
          text: TextSpan(text: plainText, style: style),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        final lines = tpFull.computeLineMetrics();
        final hidden = max(0, lines.length - maxLines);
        final previewHeight = lines.take(maxLines).map((l) => l.height).reduce((a, b) => a + b);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: previewHeight,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  maxHeight: double.infinity,
                  child: IgnorePointer(child: editor),
                ),
              ),
            ),
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
