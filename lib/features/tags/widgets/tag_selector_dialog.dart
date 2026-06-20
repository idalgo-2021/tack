import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/tag.dart';
import '../providers/tag_provider.dart';

class TagSelectorDialog extends StatefulWidget {
  final List<Tag> allTags;
  final List<String> initialSelected;
  final AppLocalizations l10n;
  final ValueChanged<List<String>> onApply;

  const TagSelectorDialog({
    super.key,
    required this.allTags,
    required this.initialSelected,
    required this.l10n,
    required this.onApply,
  });

  @override
  State<TagSelectorDialog> createState() => _TagSelectorDialogState();
}

class _TagSelectorDialogState extends State<TagSelectorDialog> {
  late List<Tag> _allTags;
  late Set<String> _selected;
  final _searchController = TextEditingController();
  final _createController = TextEditingController();
  final _createFocusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _allTags = List.from(widget.allTags);
    _selected = Set<String>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _createController.dispose();
    _createFocusNode.dispose();
    super.dispose();
  }

  Future<void> _createTag() async {
    final name = _createController.text.trim().toLowerCase();
    if (name.isEmpty || _selected.contains(name)) return;

    if (_allTags.any((t) => t.name == name)) {
      setState(() {
        _selected.add(name);
        _searchQuery = '';
        _searchController.clear();
      });
    } else {
      await ProviderScope.containerOf(context).read(tagListProvider.notifier).add(name);
      if (!mounted) return;
      setState(() {
        _allTags.add(Tag(name: name, usageCount: 0));
        _selected.add(name);
        _searchQuery = '';
        _searchController.clear();
      });
    }

    _createController.clear();
    _createFocusNode.unfocus();
    FocusScope.of(context).unfocus();
  }

  List<Tag> get _filteredTags {
    if (_searchQuery.isEmpty) return _allTags;
    return _allTags.where((t) =>
      t.name.toLowerCase().contains(_searchQuery.toLowerCase()),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = widget.l10n;
    final filtered = _filteredTags;

    return AlertDialog(
      title: Text(l10n.selectTags),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchTags,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 12),
            if (_selected.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _selected.map((name) => Chip(
                  label: Text('#$name', style: const TextStyle(fontSize: 12)),
                  onDeleted: () => setState(() => _selected.remove(name)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _selected.clear()),
                child: Text(l10n.clearAll),
              ),
              const Divider(),
            ],
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _createController,
                    focusNode: _createFocusNode,
                    decoration: InputDecoration(
                      hintText: l10n.addTag,
                      prefixText: '# ',
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _createTag(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _createTag,
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: filtered.isEmpty
                ? Center(child: Text(
                    _searchQuery.isNotEmpty ? l10n.noTagsForQuery : l10n.noTags,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ))
                : ListView(
                    children: filtered.map((tag) {
                      final isSelected = _selected.contains(tag.name);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => setState(() {
                            if (isSelected) {
                              _selected.remove(tag.name);
                            } else {
                              _selected.add(tag.name);
                            }
                          }),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                ? theme.colorScheme.primaryContainer
                                : null,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                  size: 20,
                                  color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '#${tag.name}',
                                  style: TextStyle(
                                    fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${tag.usageCount}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            widget.onApply(_selected.toList());
            Navigator.pop(context);
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}
