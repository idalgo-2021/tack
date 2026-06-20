import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/tag.dart';
import '../providers/search_provider.dart';
import '../../notes/widgets/note_card.dart';
import '../../notes/screens/note_detail_screen.dart';
import '../../tags/providers/tag_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _applyTag(String tag) {
    ref.read(searchFiltersProvider.notifier).setQuery('#$tag');
    _controller.text = '#$tag';
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (range == null) return;
    ref.read(searchFiltersProvider.notifier).setDateFrom(range.start);
    ref.read(searchFiltersProvider.notifier).setDateTo(range.end);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = ref.watch(searchFiltersProvider);
    final resultsAsync = ref.watch(searchResultsProvider(filters));
    final allTagsAsync = ref.watch(tagListProvider);
    final theme = Theme.of(context);

    final hasActiveFilters = filters.dateFrom != null || filters.dateTo != null ||
        filters.hasImages != null || filters.hasAudio != null || filters.hasFiles != null;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.searchNotesHint,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(searchFiltersProvider.notifier).setQuery(value);
          },
        ),
        actions: [
          if (filters.query.isNotEmpty || hasActiveFilters)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(searchFiltersProvider.notifier).clearAll();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.dates,
                  icon: Icons.date_range,
                  active: filters.dateFrom != null || filters.dateTo != null,
                  onTap: _pickDateRange,
                  onClear: () => ref.read(searchFiltersProvider.notifier).clearDates(),
                ),
                const SizedBox(width: 6),
                _FilterChip(
                  label: l10n.photo,
                  icon: Icons.image,
                  active: filters.hasImages == true,
                  onTap: () => ref.read(searchFiltersProvider.notifier).toggleHasImages(),
                ),
                const SizedBox(width: 6),
                _FilterChip(
                  label: l10n.audio,
                  icon: Icons.mic,
                  active: filters.hasAudio == true,
                  onTap: () => ref.read(searchFiltersProvider.notifier).toggleHasAudio(),
                ),
                const SizedBox(width: 6),
                _FilterChip(
                  label: l10n.files,
                  icon: Icons.attach_file,
                  active: filters.hasFiles == true,
                  onTap: () => ref.read(searchFiltersProvider.notifier).toggleHasFiles(),
                ),
              ],
            ),
          ),
          if (filters.dateFrom != null || filters.dateTo != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Chip(
                label: Text(_dateRangeLabel(filters.dateFrom, filters.dateTo)),
                onDeleted: () => ref.read(searchFiltersProvider.notifier).clearDates(),
              ),
            ),
          Expanded(
            child: resultsAsync.when(
              data: (notes) {
                if (filters.query.isEmpty && !hasActiveFilters) {
                  return _buildTagSuggestions(allTagsAsync, theme, l10n);
                }
                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 64, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(l10n.noResults, style: theme.textTheme.titleMedium),
                        TextButton(
                          onPressed: () {
                            _controller.clear();
                            ref.read(searchFiltersProvider.notifier).clearAll();
                          },
                          child: Text(l10n.clearFilters),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NoteDetailScreen(noteId: note.id!)),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('${l10n.error}: $error')),
            ),
          ),
        ],
      ),
    );
  }

  String _dateRangeLabel(DateTime? from, DateTime? to) {
    final l10n = AppLocalizations.of(context);
    final fmt = DateFormat.yMd();
    if (from != null && to != null) {
      return '${fmt.format(from)} - ${fmt.format(to)}';
    }
    if (from != null) return l10n.fromDate(fmt.format(from));
    if (to != null) return l10n.toDate(fmt.format(to));
    return '';
  }

  Widget _buildTagSuggestions(AsyncValue<List<Tag>> allTagsAsync, ThemeData theme, AppLocalizations l10n) {
    return allTagsAsync.when(
      data: (tags) {
        if (tags.isEmpty) {
          return Center(
            child: Text(
              l10n.typeToSearch,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.quickFilter, style: theme.textTheme.titleSmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) {
                  return ActionChip(
                    label: Text('#${tag.name}'),
                    onPressed: () => _applyTag(tag.name),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      selected: active,
      onSelected: (_) => onTap(),
    );
  }
}
