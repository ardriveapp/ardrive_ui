import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:ardrive_ui/src/constants/size_constants.dart';
import 'package:flutter/material.dart';

enum ArDriveButtonStyle { primary, secondary, tertiary }

class ArDriveButton extends StatefulWidget {
  const ArDriveButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = ArDriveButtonStyle.primary,
    this.backgroundColor,
    this.fontStyle,
    this.maxHeight,
    this.maxWidth,
  });

  final String text;
  final Function() onPressed;
  final ArDriveButtonStyle style;
  final Color? backgroundColor;
  final TextStyle? fontStyle;
  final double? maxHeight;
  final double? maxWidth;

  @override
  State<ArDriveButton> createState() => _ArDriveButtonState();
}

class _ArDriveButtonState extends State<ArDriveButton> {
  @override
  Widget build(BuildContext context) {
    switch (widget.style) {
      case ArDriveButtonStyle.primary:
        return SizedBox(
          height: widget.maxHeight ?? buttonDefaultHeight,
          width: widget.maxWidth,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: _backgroundColor,
              maximumSize: _maxSize,
              shape: _shape,
              alignment: Alignment.center,
            ),
            onPressed: widget.onPressed,
            child: Text(
              widget.text,
              style: widget.fontStyle ??
                  ArDriveTypography.headline.headline5Bold(
                    color: ArDriveTheme.of(context)
                        .themeData
                        .colors
                        .themeFgOnAccent,
                  ),
            ),
          ),
        );
      case ArDriveButtonStyle.secondary:
        return SizedBox(
          height: widget.maxHeight ?? buttonDefaultHeight,
          width: widget.maxWidth,
          child: OutlinedButton(
            onPressed: widget.onPressed,
            style: ButtonStyle(
              maximumSize: _maxSize,
              shape: _shapeOutlined,
              side: _borderSize,
              alignment: Alignment.center,
            ),
            child: Text(
              widget.text,
              style: widget.fontStyle ??
                  ArDriveTypography.headline.headline5Bold(
                    color: ArDriveTheme.of(context)
                        .themeData
                        .colors
                        .themeFgDefault,
                  ),
            ),
          ),
        );
      case ArDriveButtonStyle.tertiary:
        return ArDriveTextButton(
          text: widget.text,
          onPressed: widget.onPressed,
        );
    }
  }

  MaterialStateProperty<OutlinedBorder> get _shape =>
      MaterialStateProperty.resolveWith<OutlinedBorder>(
        (Set<MaterialState> states) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          );
        },
      );
  MaterialStateProperty<OutlinedBorder> get _shapeOutlined =>
      MaterialStateProperty.resolveWith<OutlinedBorder>(
        (Set<MaterialState> states) {
          return RoundedRectangleBorder(
            side: BorderSide(
              style: BorderStyle.solid,
              color: ArDriveTheme.of(context).themeData.colors.themeFgDefault,
            ),
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          );
        },
      );

  MaterialStateProperty<BorderSide?> get _borderSize =>
      MaterialStateProperty.resolveWith<BorderSide?>(
        (Set<MaterialState> states) {
          return BorderSide(
            width: buttonBorderWidth,
            style: BorderStyle.solid,
            color: ArDriveTheme.of(context).themeData.colors.themeFgDefault,
          );
        },
      );

  MaterialStateProperty<Size> get _maxSize =>
      MaterialStateProperty.resolveWith<Size>(
        (Set<MaterialState> states) {
          return const Size(buttonDefaultWidth, buttonDefaultHeight);
        },
      );

  MaterialStateProperty<Color?> get _backgroundColor =>
      MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return widget.backgroundColor;
        },
      );
}

class ArDriveTextButton extends StatelessWidget {
  const ArDriveTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(overlayColor: _hoverColor),
      onPressed: onPressed,
      child: Text(
        text,
        style: ArDriveTypography.body.smallRegular().copyWith(
              decoration: TextDecoration.underline,
              color: ArDriveTheme.of(context).themeData.colors.themeFgDefault,
            ),
      ),
    );
  }

  MaterialStateProperty<Color?> get _hoverColor =>
      MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.transparent;
        },
      );
}
