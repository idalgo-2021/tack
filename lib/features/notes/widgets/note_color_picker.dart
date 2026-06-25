import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class NoteColorPicker {
  static const List<Color> pastelColors = [
    Color(0xFFE8D5F5), // Lavender
    Color(0xFFC8E6C9), // Mint
    Color(0xFFFFD8B1), // Peach
    Color(0xFFB3E5FC), // Sky Blue
    Color(0xFFF8BBD0), // Pink
    Color(0xFFFFF9C4), // Lemon
    Color(0xFFFFCCBC), // Coral
    Color(0xFFE1BEE7), // Lilac
    Color(0xFFDCEDC8), // Light Green
  ];

  const NoteColorPicker._();

  static Future<int?> show(
    BuildContext context, {
    required int? currentColor,
  }) async {
    final l10n = AppLocalizations.of(context);
    int? selected = currentColor;

    return showDialog<int?>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(l10n.shirt),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: pastelColors.map((color) {
                      final isSelected = selected == color.toARGB32();
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selected = isSelected ? null : color.toARGB32();
                          });
                          Navigator.pop(ctx, selected);
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(ctx).colorScheme.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(ctx, null),
                    icon: const Icon(Icons.clear, size: 18),
                    label: Text(l10n.noColor),
                  ),
                ],
              ),

            );
          },
        );
      },
    );

  }
}
