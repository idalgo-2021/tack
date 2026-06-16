import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/tag.dart';

class TagTile extends StatelessWidget {
  final Tag tag;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TagTile({
    super.key,
    required this.tag,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          tag.name[0].toUpperCase(),
          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
        ),
      ),
      title: Text('#${tag.name}'),
      subtitle: Text(l10n.notesCount(tag.usageCount)),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
