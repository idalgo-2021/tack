import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/tag.dart';
import '../../../core/widgets/centered_app_bar_title.dart';
import '../providers/tag_provider.dart';
import '../widgets/tag_tile.dart';

class TagManagerScreen extends ConsumerStatefulWidget {
  const TagManagerScreen({super.key});

  @override
  ConsumerState<TagManagerScreen> createState() => _TagManagerScreenState();
}

enum _SortField { name, count }

class _TagManagerScreenState extends ConsumerState<TagManagerScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  _SortField _sortField = _SortField.name;
  bool _sortAsc = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.newTag),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.tagName,
            prefixText: '# ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim().toLowerCase();
              if (name.isNotEmpty) {
                ref.read(tagListProvider.notifier).add(name);
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.createTag),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(int id, String currentName) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.renameTag),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.renameTagHint,
            prefixText: '# ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim().toLowerCase();
              if (name.isNotEmpty) {
                ref.read(tagListProvider.notifier).rename(id, name);
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  List<Tag> _applyFilterAndSort(List<Tag> tags) {
    final query = _searchQuery.trim().toLowerCase();
    var result = tags;
    if (query.isNotEmpty) {
      result = result.where((t) => t.name.toLowerCase().contains(query)).toList();
    }
    if (_sortField == _SortField.name) {
      result.sort((a, b) => _sortAsc ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    } else {
      result.sort((a, b) => _sortAsc ? a.usageCount.compareTo(b.usageCount) : b.usageCount.compareTo(a.usageCount));
    }
    return result;
  }

  void _toggleSort(_SortField field) {
    setState(() {
      if (_sortField == field) {
        _sortAsc = !_sortAsc;
      } else {
        _sortField = field;
        _sortAsc = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tagsAsync = ref.watch(tagListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: CenteredAppBarTitle(title: Text(l10n.tags)),
      ),
      body: tagsAsync.when(
        data: (tags) {
          final displayTags = _applyFilterAndSort(tags);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchTags,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _SortButton(
                      label: l10n.byName,
                      active: _sortField == _SortField.name,
                      ascending: _sortAsc,
                      onTap: () => _toggleSort(_SortField.name),
                    ),
                    const SizedBox(width: 8),
                    _SortButton(
                      label: l10n.byCount,
                      active: _sortField == _SortField.count,
                      ascending: _sortAsc,
                      onTap: () => _toggleSort(_SortField.count),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: displayTags.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isNotEmpty ? l10n.noMatches : l10n.noTags,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async => ref.invalidate(tagListProvider),
                        child: ListView.builder(
                          itemCount: displayTags.length,
                          itemBuilder: (context, index) {
                            final tag = displayTags[index];
                            return TagTile(
                              tag: tag,
                              onTap: () => _showRenameDialog(tag.id!, tag.name),
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(l10n.deleteTag),
                                    content: Text(l10n.tagDeleteWarning),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: Text(l10n.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        child: Text(l10n.delete),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  ref.read(tagListProvider.notifier).delete(tag.id!);
                                }
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('${l10n.error}: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'tag_manager_fab',
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final bool active;
  final bool ascending;
  final VoidCallback onTap;

  const _SortButton({
    required this.label,
    required this.active,
    required this.ascending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(
        ascending ? Icons.arrow_upward : Icons.arrow_downward,
        size: 18,
        color: color,
      ),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: active ? FontWeight.w600 : FontWeight.normal),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: active ? theme.colorScheme.primaryContainer.withAlpha(80) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
