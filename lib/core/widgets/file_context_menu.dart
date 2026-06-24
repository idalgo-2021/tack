import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../../../l10n/app_localizations.dart';

class FileContextMenu {
  static List<PopupMenuEntry<String>> buildMenuItems(
    BuildContext context,
    String filePath,
  ) {
    final l10n = AppLocalizations.of(context);

    return [
      PopupMenuItem<String>(
        value: 'open',
        child: Row(
          children: [
            const Icon(Icons.open_in_new, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.openIn,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onTap: () => _openFile(filePath),
      ),
      PopupMenuItem<String>(
        value: 'share',
        child: Row(
          children: [
            const Icon(Icons.share, size: 20),
            const SizedBox(width: 12),
            Text(l10n.shareFile),
          ],
        ),
        onTap: () => _shareFile(filePath),
      ),
    ];
  }

  static void _openFile(String filePath) {
    OpenFilex.open(filePath);
  }

  static void _shareFile(String filePath) {
    SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
  }
}