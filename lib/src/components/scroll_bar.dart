import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:ardrive_ui/src/styles/colors/global_colors.dart';
import 'package:flutter/material.dart';

class ArDriveScrollBar extends StatelessWidget {
  const ArDriveScrollBar({super.key, required this.child, this.controller});

  final Widget child;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ArDriveTheme.of(context).themeData.materialThemeData.copyWith(
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all<Color>(
                  grey.shade400), // set the color of the thumb
              trackColor: MaterialStateProperty.all<Color>(
                  grey.shade400), // set the color of the track
            ),
          ),
      child: Scrollbar(
        controller: controller,
        child: child,
      ),
    );
  }
}
