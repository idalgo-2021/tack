import 'package:flutter/material.dart';
import 'tack_logo.dart';

class CenteredAppBarTitle extends StatelessWidget {
  final Widget title;

  const CenteredAppBarTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const TackLogo(),
        const SizedBox(width: 12),
        title,
      ],
    );
  }
}
