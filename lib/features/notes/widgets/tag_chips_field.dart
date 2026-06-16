import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class TagChipsField extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final Future<List<String>> Function(String query)? onSearch;

  const TagChipsField({
    super.key,
    required this.tags,
    required this.onChanged,
    this.onSearch,
  });

  @override
  State<TagChipsField> createState() => _TagChipsFieldState();
}

class _TagChipsFieldState extends State<TagChipsField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _suggestions = [];

  void _addTag(String tag) {
    final trimmed = tag.trim().toLowerCase();
    if (trimmed.isEmpty) return;
    if (widget.tags.contains(trimmed)) return;

    widget.onChanged([...widget.tags, trimmed]);
    _controller.clear();
    _suggestions = [];
  }

  void _removeTag(String tag) {
    widget.onChanged(widget.tags.where((t) => t != tag).toList());
  }

  Future<void> _onSearchChanged(String query) async {
    if (widget.onSearch == null || query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    final results = await widget.onSearch!(query);
    setState(() => _suggestions = results.where((t) => !widget.tags.contains(t)).toList());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.tags.map((tag) {
                return Chip(
                  label: Text('#$tag', style: const TextStyle(fontSize: 13)),
                  onDeleted: () => _removeTag(tag),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  labelPadding: const EdgeInsets.only(left: 8),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  deleteIconColor: theme.colorScheme.onSurfaceVariant,
                );
              }).toList(),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: l10n.addTag,
                  prefixText: '# ',
                  isDense: true,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onSubmitted: (value) {
                  _addTag(value);
                  _focusNode.requestFocus();
                },
                onChanged: _onSearchChanged,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _addTag(_controller.text),
            ),
          ],
        ),
        if (_suggestions.isNotEmpty)
          Card(
            margin: const EdgeInsets.only(top: 4),
            child: Column(
              children: _suggestions.map((tag) {
                return ListTile(
                  dense: true,
                  title: Text('#$tag'),
                  onTap: () {
                    _addTag(tag);
                    _focusNode.requestFocus();
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
