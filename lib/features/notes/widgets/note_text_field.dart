import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class NoteTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? textStyle;

  const NoteTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: textStyle,
      maxLines: null,
      minLines: 5,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: hintText ?? l10n.startWriting,
        border: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
