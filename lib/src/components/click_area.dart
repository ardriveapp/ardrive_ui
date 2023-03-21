import 'package:flutter/material.dart';

class ArDriveClickArea extends StatelessWidget {
  const ArDriveClickArea({
    super.key,
    required this.child,
    this.showCursor = true,
  });

  final Widget child;
  final bool showCursor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: showCursor ? SystemMouseCursors.click : MouseCursor.defer,
      child: child,
    );
  }
}
