import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/note.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/export_helper.dart';
import '../../../core/widgets/centered_app_bar_title.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/note_list_provider.dart';
import '../widgets/note_card.dart';
import '../screens/note_editor_screen.dart';
import '../screens/note_detail_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../tags/providers/tag_provider.dart';

class NoteListScreen extends ConsumerStatefulWidget {
  const NoteListScreen({super.key});

  @override
  ConsumerState<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends ConsumerState<NoteListScreen> {
  String? _tagFilter;
  final Set<int> _selectedIds = {};
  bool _selectionMode = false;

  void _toggleSelection(int noteId) {
    setState(() {
      if (_selectedIds.contains(noteId)) {
        _selectedIds.remove(noteId);
        if (_selectedIds.isEmpty) _selectionMode = false;
      } else {
        _selectedIds.add(noteId);
        _selectionMode = true;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _selectionMode = false;
    });
  }

  Future<void> _deleteSelected() async {
    if (_selectedIds.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteSelected(_selectedIds.length)),
        content: Text(l10n.deleteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirm != true) return;

    final repo = NoteRepository();
    for (final id in _selectedIds) {
      await repo.delete(id);
    }
    ref.invalidate(noteListProvider);
    _clearSelection();
  }

  Future<void> _shareSelected() async {
    if (_selectedIds.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    final repo = NoteRepository();
    final allNotes = await repo.getAll();
    final selected = allNotes
        .where((n) => _selectedIds.contains(n.id))
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final format = ref.read(exportFormatProvider);
    final zip = ref.read(zipExportProvider);
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final allFiles = <XFile>[];

    if (format == ExportFormat.markdown) {
      final content = ExportHelper.notesToMarkdown(selected, l10n);
      final file = File('${Directory.systemTemp.path}/tack_$timestamp.md');
      await file.writeAsString(content);
      allFiles.add(XFile(file.path));
    } else {
      final content = ExportHelper.notesToJson(selected);
      final file = File('${Directory.systemTemp.path}/tack_$timestamp.json');
      await file.writeAsString(content);
      allFiles.add(XFile(file.path));
    }

    if (zip) {
      final attachPaths = <String>[allFiles.first.path];
      for (final note in selected) {
        for (final p in note.imagePaths) { attachPaths.add(p); }
        for (final p in note.audioPaths) { attachPaths.add(p); }
        for (final p in note.filePaths) { attachPaths.add(p); }
      }
      final zipPath = '${Directory.systemTemp.path}/tack_$timestamp.zip';
      await ExportHelper.createZip(zipPath, attachPaths);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(zipPath)]),
      );
    } else {
      for (final note in selected) {
        for (final p in note.imagePaths) { allFiles.add(XFile(p)); }
        for (final p in note.audioPaths) { allFiles.add(XFile(p)); }
        for (final p in note.filePaths) { allFiles.add(XFile(p)); }
      }
      await SharePlus.instance.share(
        ShareParams(files: allFiles),
      );
    }
    _clearSelection();
  }

  void _showTagFilterSheet() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Consumer(builder: (ctx, ref, _) {
          final tagsAsync = ref.watch(tagListProvider);
          return tagsAsync.when(
            data: (tags) {
              return ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(l10n.allNotes),
                    trailing: _tagFilter == null ? const Icon(Icons.check) : null,
                    onTap: () {
                      setState(() => _tagFilter = null);
                      Navigator.pop(ctx);
                    },
                  ),
                  ...tags.map((tag) => ListTile(
                        title: Text('#${tag.name}'),
                        trailing: _tagFilter == tag.name ? const Icon(Icons.check) : null,
                        onTap: () {
                          setState(() => _tagFilter = tag.name);
                          Navigator.pop(ctx);
                        },
                      )),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(child: Text(l10n.error)),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notesAsync = ref.watch(noteListProvider(searchQuery: null, tagFilter: _tagFilter));
    final viewMode = ref.watch(viewModeProvider);
    final groupMode = ref.watch(groupModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
          appBar: AppBar(
        centerTitle: false,
        title: _selectionMode
            ? Text(l10n.selectedCount(_selectedIds.length))
            : CenteredAppBarTitle(
                title: _tagFilter != null
                    ? Text('#$_tagFilter')
                    : Text(l10n.notes),
              ),
        actions: [
          if (_selectionMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _clearSelection,
            ),
          if (!_selectionMode) ...[
            if (_tagFilter != null)
              IconButton(
                icon: const Icon(Icons.clear),
                tooltip: l10n.clearFilter,
                onPressed: () => setState(() => _tagFilter = null),
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showTagFilterSheet,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (_selectionMode && _selectedIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.colorScheme.primaryContainer,
              child: Row(
                children: [
                  Text(l10n.selectedCount(_selectedIds.length)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareSelected,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: _deleteSelected,
                  ),
                ],
              ),
            ),
          Expanded(
            child: notesAsync.when(
              data: (notes) {
                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.note_add, size: 64, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(
                          _tagFilter != null
                              ? l10n.noNotesWithTag(_tagFilter!)
                              : l10n.noNotes,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.tapToCreate,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(noteListProvider),
                  child: groupMode != GroupMode.none
                      ? _buildGroupedView(notes, viewMode, groupMode, theme, context)
                      : viewMode == ViewMode.list
                          ? ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: notes.length,
                              itemBuilder: (context, index) => _buildNoteItem(notes[index]),
                            )
                          : MasonryGridView.count(
                              padding: const EdgeInsets.all(8),
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              itemCount: notes.length,
                              itemBuilder: (context, index) => _buildNoteItem(notes[index]),
                            ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('${l10n.error}: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: _selectionMode
          ? null
          : FloatingActionButton(
              heroTag: 'note_list_fab',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
                );
                ref.invalidate(noteListProvider);
              },
              child: const Icon(Icons.add),
            ),
    );
  }

  Map<String, List<Note>> _groupNotes(List<Note> notes, GroupMode mode, BuildContext context) {
    final map = <String, List<Note>>{};
    for (final note in notes) {
      final key = switch (mode) {
        GroupMode.day => DateFormatter.formatDayGroup(context, note.createdAt),
        GroupMode.week => DateFormatter.formatWeekGroup(context, note.createdAt),
        GroupMode.month => DateFormatter.formatMonthGroup(context, note.createdAt),
        GroupMode.none => '',
      };
      map.putIfAbsent(key, () => []).add(note);
    }
    return map;
  }

  Widget _buildSectionHeader(String label, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGroupedView(List<Note> notes, ViewMode viewMode, GroupMode groupMode, ThemeData theme, BuildContext context) {
    final groups = _groupNotes(notes, groupMode, context);
    final slivers = <Widget>[];

    for (final entry in groups.entries) {
      slivers.add(SliverToBoxAdapter(
        child: _buildSectionHeader(entry.key, theme),
      ));

      if (viewMode == ViewMode.list) {
        slivers.add(SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildNoteItem(entry.value[index]),
            childCount: entry.value.length,
          ),
        ));
      } else {
        slivers.add(SliverMasonryGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
          childCount: entry.value.length,
          itemBuilder: (context, index) => _buildNoteItem(entry.value[index]),
        ));
      }
    }

    return CustomScrollView(
      slivers: slivers,
    );
  }

  Widget _buildNoteItem(Note note) {
    final isSelected = _selectedIds.contains(note.id);
    final viewMode = ref.read(viewModeProvider);

    final card = GestureDetector(
      onLongPress: () {
        if (!_selectionMode) {
          _toggleSelection(note.id!);
        }
      },
      child: NoteCard(
        note: note,
        isSelected: isSelected,
        showSelectionCheck: _selectionMode,
        onTap: _selectionMode
            ? () => _toggleSelection(note.id!)
            : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteDetailScreen(noteId: note.id!)),
              ),
      ),
    );

    if (viewMode == ViewMode.grid) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: card,
      );
    }
    return card;
  }
}
