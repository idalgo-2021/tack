import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteFormattingToolbar extends StatelessWidget {
  final QuillController controller;
  final VoidCallback onExit;

  const NoteFormattingToolbar({super.key, required this.controller, required this.onExit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toolButtons = _buildToolButtons(theme);
    final doneButton = _buildDoneButton(theme);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double toolsWidth = 11 * 36.0 + 3 * 1.0;
            const double gapDoneWidth = 8.0 + 40.0;
            const double totalNeeded = toolsWidth + gapDoneWidth;

            if (constraints.maxWidth >= totalNeeded) {
              return Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: toolButtons,
                    ),
                  ),
                  const SizedBox(width: 8),
                  doneButton,
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      runSpacing: 4,
                      children: toolButtons,
                    ),
                  ),
                  const SizedBox(width: 8),
                  doneButton,
                ],
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildToolButtons(ThemeData theme) {
    return [
      _ToolbarButton(
        icon: Icons.format_bold,
        onPressed: () => _toggleAttribute(controller, Attribute.bold),
      ),
      _ToolbarButton(
        icon: Icons.format_italic,
        onPressed: () => _toggleAttribute(controller, Attribute.italic),
      ),
      _ToolbarButton(
        icon: Icons.format_underline,
        onPressed: () => _toggleAttribute(controller, Attribute.underline),
      ),
      _ToolbarDivider(theme: theme),
      _ToolbarButton(
        icon: Icons.format_list_bulleted,
        onPressed: () => _toggleAttribute(controller, Attribute.ul),
      ),
      _ToolbarButton(
        icon: Icons.format_list_numbered,
        onPressed: () => _toggleAttribute(controller, Attribute.ol),
      ),
      _ToolbarButton(
        icon: Icons.format_align_left,
        onPressed: () => _applyFormat(controller, Attribute.leftAlignment),
      ),
      _ToolbarButton(
        icon: Icons.format_align_center,
        onPressed: () => _applyFormat(controller, Attribute.centerAlignment),
      ),
      _ToolbarButton(
        icon: Icons.format_align_right,
        onPressed: () => _applyFormat(controller, Attribute.rightAlignment),
      ),
      _ToolbarDivider(theme: theme),
      _ToolbarButton(
        icon: Icons.text_decrease,
        onPressed: () => _changeFontSize(controller, -2),
      ),
      _ToolbarButton(
        icon: Icons.text_increase,
        onPressed: () => _changeFontSize(controller, 2),
      ),
      _ToolbarDivider(theme: theme),
      _ToolbarButton(
        icon: Icons.format_clear,
        onPressed: () => _clearFormat(controller),
      ),
    ];
  }

  Widget _buildDoneButton(ThemeData theme) {
    return IconButton(
      icon: const Icon(Icons.check, size: 24),
      onPressed: onExit,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(8),
        minimumSize: const Size(40, 40),
      ),
    );
  }

  static void _toggleAttribute(QuillController controller, Attribute attribute) {
    final style = controller.getSelectionStyle();
    final current = style.attributes.containsKey(attribute.key);
    controller.formatSelection(current ? Attribute.clone(attribute, null) : attribute);
    SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
  }

  static void _applyFormat(QuillController controller, Attribute attribute) {
    controller.formatSelection(attribute);
    SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
  }

  static void _changeFontSize(QuillController controller, int step) {
    const defaultSize = 14;
    final style = controller.getSelectionStyle();
    final sizeAttr = style.attributes[Attribute.size.key];
    final currentValue = sizeAttr?.value;
    int currentSize;
    if (currentValue == null) {
      currentSize = defaultSize;
    } else {
      currentSize = int.tryParse(currentValue.toString()) ?? defaultSize;
    }
    final newSize = (currentSize + step).clamp(8, 72);
    controller.formatSelection(Attribute.fromKeyValue(Attribute.size.key, newSize.toString()));
    SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
  }

  static void _clearFormat(QuillController controller) {
    final attributes = <Attribute>{};
    for (final style in controller.getAllSelectionStyles()) {
      for (final attr in style.attributes.values) {
        attributes.add(attr);
      }
    }
    for (final attribute in attributes) {
      controller.formatSelection(Attribute.clone(attribute, null));
    }
    SystemChannels.textInput.invokeMethod<dynamic>('TextInput.hide');
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ToolbarButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(8),
        minimumSize: const Size(36, 36),
      ),
    );
  }
}

class _ToolbarDivider extends StatelessWidget {
  final ThemeData theme;

  const _ToolbarDivider({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: theme.colorScheme.outlineVariant,
    );
  }
}
