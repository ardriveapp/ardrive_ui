import 'package:flutter/material.dart';

class ArDriveClickArea extends StatelessWidget {
  const ArDriveClickArea({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: child,
    );
  }
}
