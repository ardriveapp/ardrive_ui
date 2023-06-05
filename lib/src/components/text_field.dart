import 'dart:async';

import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArDriveForm extends StatefulWidget {
  final Widget child;
  const ArDriveForm({
    super.key,
    required this.child,
  });

  @override
  State<ArDriveForm> createState() => ArDriveFormState();
}

class ArDriveFormState extends State<ArDriveForm> {
  bool _isValid = true;

  bool validate() {
    _isValid = true;

    context.visitChildElements((element) {
      if (element is! ArDriveTextField) {
        return _findAndValidateTextField(element);
      }
    });

    return _isValid;
  }

  void _findAndValidateTextField(Element e) {
    e.visitChildElements((element) {
      if (element.widget is! ArDriveTextField) {
        return _findAndValidateTextField(element);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _isValid = _isValid &&
            await ((element as StatefulElement).state as ArDriveTextFieldState)
                .validate();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class ArDriveTextField extends StatefulWidget {
  const ArDriveTextField({
    super.key,
    this.isEnabled = true,
    this.validator,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.autofillHints,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.successMessage,
    this.autocorrect = true,
    this.autofocus = false,
    this.controller,
    this.initialValue,
    this.inputFormatters,
    this.keyboardType,
    this.onTap,
    this.onFieldSubmitted,
    this.focusNode,
    this.maxLength,
    this.label,
    this.isFieldRequired = false,
    this.showObfuscationToggle = false,
    this.textInputAction = TextInputAction.done,
    this.suffixIcon,
    this.textStyle,
    this.useErrorMessageOffset = false,
    this.preffix,
    this.showErrorMessage = true,
  });

  final bool isEnabled;
  final FutureOr<String?>? Function(String?)? validator;
  final Function(String)? onChanged;
  final String? hintText;
  final bool obscureText;
  final List<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final String? successMessage;
  final bool autocorrect;
  final bool autofocus;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final Function(String)? onFieldSubmitted;
  final int? maxLength;
  final FocusNode? focusNode;
  final String? label;
  final bool isFieldRequired;
  final bool showObfuscationToggle;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final bool useErrorMessageOffset;
  final Widget? preffix;
  final bool showErrorMessage;
  @override
  State<ArDriveTextField> createState() => ArDriveTextFieldState();
}

enum TextFieldState { unfocused, focused, disabled, error, success }

@visibleForTesting
class ArDriveTextFieldState extends State<ArDriveTextField> {
  @visibleForTesting
  late TextFieldState textFieldState;

  @override
  void initState() {
    textFieldState = TextFieldState.unfocused;
    _isObscureText = widget.obscureText;
    super.initState();
  }

  late bool _isObscureText;

  String? _errorMessage;
  String? _currentText;

  @override
  Widget build(BuildContext context) {
    final theme = ArDriveTheme.of(context).themeData.textFieldTheme;

    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _textFieldLabel(widget.label!, theme),
              ),
            ),
          TextFormField(
            controller: widget.controller,
            autocorrect: widget.autocorrect,
            autofocus: widget.autofocus,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            onTap: widget.onTap,
            onFieldSubmitted: widget.onFieldSubmitted,
            maxLength: widget.maxLength,
            focusNode: widget.focusNode,
            key: widget.key,
            textInputAction: widget.textInputAction,
            obscureText: _isObscureText,
            style: theme.inputTextStyle,
            autovalidateMode: widget.autovalidateMode,
            onChanged: (text) {
              validate(text: text);
              widget.onChanged?.call(text);
              _currentText = text;
            },
            autofillHints: widget.autofillHints,
            enabled: widget.isEnabled,
            decoration: InputDecoration(
              prefix: widget.preffix,
              suffix: widget.suffixIcon ??
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscureText = !_isObscureText;
                      });
                    },
                    child: ArDriveClickArea(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: widget.showObfuscationToggle
                            ? ArDriveIcon(
                                icon: _isObscureText
                                    ? ArDriveIconsData.eye_closed
                                    : ArDriveIconsData.eye_open,
                                color: theme.inputTextColor,
                              )
                            : null,
                      ),
                    ),
                  ),
              errorStyle: const TextStyle(height: 0),
              hintText: widget.hintText,
              hintStyle: ArDriveTypography.body
                  .inputLargeRegular(color: _hintTextColor(theme)),
              enabledBorder: _getEnabledBorder(theme),
              focusedBorder: _getFocusedBoder(theme),
              disabledBorder: _getDisabledBorder(theme),
              filled: true,
              fillColor: theme.inputBackgroundColor,
              contentPadding: theme.contentPadding,
            ),
          ),
          if (widget.showErrorMessage &&
              widget.validator != null &&
              widget.validator is Future<String?>)
            FutureBuilder(
              future: widget.validator?.call(_currentText) as Future,
              builder: (context, snapshot) {
                return _errorMessageLabel(theme);
              },
            ),
          if (widget.showErrorMessage &&
              widget.validator != null &&
              widget.validator is FutureOr<String?>? Function(String?))
            _errorMessageLabel(theme),
          if (widget.successMessage != null)
            _successMessage(widget.successMessage!, theme),
        ],
      ),
    );
  }

  Widget _errorMessageLabel(ArDriveTextFieldTheme theme) {
    return AnimatedTextFieldLabel(
      text: _errorMessage,
      showing: _errorMessage != null,
      style: ArDriveTypography.body.bodyBold(
        color: theme.errorColor,
      ),
      useLabelOffset: widget.useErrorMessageOffset,
    );
  }

  Widget _textFieldLabel(String message, ArDriveTextFieldTheme theme) {
    return Row(
      children: [
        TextFieldLabel(
          text: message,
          style: ArDriveTypography.body.buttonNormalBold(
            color: widget.isFieldRequired
                ? theme.requiredLabelColor
                : theme.labelColor,
          ),
        ),
        if (widget.isFieldRequired)
          Text(
            ' *',
            style: ArDriveTypography.body.buttonNormalRegular(
              color: theme.labelColor,
            ),
          )
      ],
    );
  }

  Widget _successMessage(String message, ArDriveTextFieldTheme theme) {
    return AnimatedTextFieldLabel(
      text: message,
      showing: textFieldState == TextFieldState.success,
      style: ArDriveTypography.body.bodyRegular(
        color: theme.successColor,
      ),
    );
  }

  InputBorder _getBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  InputBorder _getEnabledBorder(ArDriveTextFieldTheme theme) {
    if (textFieldState == TextFieldState.success) {
      return _getSuccessBorder(theme);
    } else if (textFieldState == TextFieldState.error) {
      return _getErrorBorder(theme);
    }
    return _getBorder(theme.defaultBorderColor);
  }

  InputBorder _getFocusedBoder(ArDriveTextFieldTheme theme) {
    if (textFieldState == TextFieldState.success) {
      return _getSuccessBorder(theme);
    } else if (textFieldState == TextFieldState.error) {
      return _getErrorBorder(theme);
    }

    return _getBorder(
      ArDriveTheme.of(context).themeData.colors.themeFgDefault,
    );
  }

  InputBorder _getDisabledBorder(ArDriveTextFieldTheme theme) {
    return _getBorder(theme.inputDisabledBorderColor);
  }

  InputBorder _getErrorBorder(ArDriveTextFieldTheme theme) {
    return _getBorder(theme.errorBorderColor);
  }

  InputBorder _getSuccessBorder(ArDriveTextFieldTheme theme) {
    return _getBorder(theme.successBorderColor);
  }

  Color _hintTextColor(ArDriveTextFieldTheme theme) {
    if (widget.isEnabled) {
      return theme.inputPlaceholderColor;
    }
    return theme.disabledTextColor;
  }

  FutureOr<bool> validate({String? text}) async {
    String? textToValidate = text;

    if (textToValidate == null && widget.controller != null) {
      textToValidate = widget.controller?.text;
    }

    final validation = await widget.validator?.call(textToValidate);

    setState(() {
      if (textToValidate?.isEmpty ?? true) {
        textFieldState = TextFieldState.focused;
      } else if (validation != null) {
        textFieldState = TextFieldState.error;
      } else if (validation == null) {
        textFieldState = TextFieldState.success;
      }
    });

    _errorMessage = validation;

    return validation == null;
  }
}

@visibleForTesting
class AnimatedTextFieldLabel extends StatefulWidget {
  const AnimatedTextFieldLabel({
    super.key,
    required this.text,
    required this.showing,
    required this.style,
    this.useLabelOffset = false,
  });

  final String? text;
  final bool showing;
  final TextStyle style;
  final bool useLabelOffset;

  @override
  State<AnimatedTextFieldLabel> createState() => AnimatedTextFieldLabelState2();
}

class AnimatedTextFieldLabelState extends State<AnimatedTextFieldLabel> {
  @visibleForTesting
  bool visible = false;

  @visibleForTesting
  bool showing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showing = widget.showing;
    if (!showing) {
      visible = false;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        onEnd: () => setState(() {
          visible = !visible;
        }),
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: !visible ? 100 : 300),
          child: TextFieldLabel(
            style: widget.style,
            text: widget.text ?? '',
          ),
        ),
      ),
    );
  }
}

class AnimatedTextFieldLabelState2 extends State<AnimatedTextFieldLabel> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final inAnimation = Tween<Offset>(
                    begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0))
                .animate(animation);
            final outAnimation = Tween<Offset>(
                    begin: const Offset(0.0, 0.0), end: const Offset(0.0, 1.0))
                .animate(animation);

            return ClipRect(
              child: SlideTransition(
                position: child.key == const ValueKey(true)
                    ? inAnimation
                    : outAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: child,
                  ),
                ),
              ),
            );
          },
          child: widget.showing
              ? SizedBox(
                  height: 22,
                  key: const ValueKey(true),
                  child: TextFieldLabel(
                    style: widget.style,
                    text: widget.text ?? '',
                  ),
                )
              : Container(
                  key: const ValueKey(false),
                  height: widget.useLabelOffset ? 22 : 0,
                ),
        ),
      ),
    );
  }
}

class TextFieldLabel extends StatelessWidget {
  const TextFieldLabel({
    super.key,
    required this.text,
    required this.style,
  });
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = ArDriveTheme.of(context).themeData.textFieldTheme;

    return AutoSizeText(text, style: style);
  }
}

class ArDriveTextFieldTheme {
  final Color inputTextColor;
  final Color inputBackgroundColor;
  final Color inputDisabledBorderColor;
  final Color errorColor;
  final Color requiredLabelColor;
  final Color labelColor;
  final Color successColor;
  final Color defaultBorderColor;
  final Color errorBorderColor;
  final Color successBorderColor;
  final Color inputPlaceholderColor;
  final Color disabledTextColor;
  final TextStyle inputTextStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorLabelStyle;
  final EdgeInsets? contentPadding;

  const ArDriveTextFieldTheme({
    required this.inputTextColor,
    required this.inputBackgroundColor,
    required this.inputDisabledBorderColor,
    required this.errorColor,
    required this.requiredLabelColor,
    required this.labelColor,
    required this.successColor,
    required this.defaultBorderColor,
    required this.errorBorderColor,
    required this.successBorderColor,
    required this.inputPlaceholderColor,
    required this.disabledTextColor,
    required this.inputTextStyle,
    this.labelStyle,
    this.contentPadding,
    this.errorLabelStyle,
  });

  // copy with
  ArDriveTextFieldTheme copyWith({
    Color? inputTextColor,
    Color? inputBackgroundColor,
    Color? inputDisabledBorderColor,
    Color? errorColor,
    Color? requiredLabelColor,
    Color? labelColor,
    Color? successColor,
    Color? defaultBorderColor,
    Color? errorBorderColor,
    Color? successBorderColor,
    Color? inputPlaceholderColor,
    Color? disabledTextColor,
    TextStyle? inputTextStyle,
    TextStyle? labelStyle,
    EdgeInsets? contentPadding,
  }) {
    return ArDriveTextFieldTheme(
      inputTextColor: inputTextColor ?? this.inputTextColor,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      inputDisabledBorderColor:
          inputDisabledBorderColor ?? this.inputDisabledBorderColor,
      errorColor: errorColor ?? this.errorColor,
      requiredLabelColor: requiredLabelColor ?? this.requiredLabelColor,
      labelColor: labelColor ?? this.labelColor,
      successColor: successColor ?? this.successColor,
      defaultBorderColor: defaultBorderColor ?? this.defaultBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      successBorderColor: successBorderColor ?? this.successBorderColor,
      inputPlaceholderColor:
          inputPlaceholderColor ?? this.inputPlaceholderColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }
}
