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
                child: _textFieldLabel(widget.label!),
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
            style: ArDriveTypography.body.inputLargeRegular(
              color: ArDriveTheme.of(context).themeData.colors.themeInputText,
            ),
            autovalidateMode: widget.autovalidateMode,
            onChanged: (text) {
              validate(text: text);
              widget.onChanged?.call(text);
              _currentText = text;
            },
            autofillHints: widget.autofillHints,
            enabled: widget.isEnabled,
            decoration: InputDecoration(
              suffix: widget.suffixIcon ??
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscureText = !_isObscureText;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: widget.showObfuscationToggle
                          ? _isObscureText
                              ? ArDriveIcons.eyeOff(
                                  color: ArDriveTheme.of(context)
                                      .themeData
                                      .colors
                                      .themeBgCanvas,
                                )
                              : ArDriveIcons.eye(
                                  color: ArDriveTheme.of(context)
                                      .themeData
                                      .colors
                                      .themeBgCanvas,
                                )
                          : null,
                    ),
                  ),
              errorStyle: const TextStyle(height: 0),
              hintText: widget.hintText,
              hintStyle: ArDriveTypography.body
                  .inputLargeRegular(color: _hintTextColor()),
              enabledBorder: _getEnabledBorder(),
              focusedBorder: _getFocusedBoder(),
              disabledBorder: _getDisabledBorder(),
              filled: true,
              fillColor: ArDriveTheme.of(context)
                  .themeData
                  .colors
                  .themeInputBackground,
            ),
          ),
          if (widget.validator != null)
            FutureBuilder(
              future: validate(text: _currentText) as Future,
              builder: (context, snapshot) {
                return _errorMessageLabel();
              },
            ),
          if (widget.successMessage != null)
            _successMessage(widget.successMessage!),
        ],
      ),
    );
  }

  Widget _errorMessageLabel() {
    return AnimatedTextFieldLabel(
      text: _errorMessage,
      showing: _errorMessage != null,
      color: ArDriveTheme.of(context).themeData.colors.themeErrorDefault,
    );
  }

  Widget _textFieldLabel(String message) {
    return Row(
      children: [
        TextFieldLabel(
          text: message,
          bold: true,
          color: widget.isFieldRequired
              ? ArDriveTheme.of(context).themeData.colors.themeFgDefault
              : ArDriveTheme.of(context).themeData.colors.themeAccentDefault,
        ),
        if (widget.isFieldRequired)
          Text(
            '*',
            style: ArDriveTypography.body.bodyRegular(
              color:
                  ArDriveTheme.of(context).themeData.colors.themeAccentDefault,
            ),
          )
      ],
    );
  }

  Widget _successMessage(String message) {
    return AnimatedTextFieldLabel(
      text: message,
      showing: textFieldState == TextFieldState.success,
      color: ArDriveTheme.of(context).themeData.colors.themeSuccessDefault,
    );
  }

  InputBorder _getBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  InputBorder _getEnabledBorder() {
    if (textFieldState == TextFieldState.success) {
      return _getSuccessBorder();
    } else if (textFieldState == TextFieldState.error) {
      return _getErrorBorder();
    }
    return _getBorder(
      ArDriveTheme.of(context).themeData.colors.themeBorderDefault,
    );
  }

  InputBorder _getFocusedBoder() {
    if (textFieldState == TextFieldState.success) {
      return _getSuccessBorder();
    } else if (textFieldState == TextFieldState.error) {
      return _getErrorBorder();
    }

    return _getBorder(
      ArDriveTheme.of(context).themeData.colors.themeAccentEmphasis,
    );
  }

  InputBorder _getDisabledBorder() {
    return _getBorder(
      ArDriveTheme.of(context).themeData.colors.themeInputBorderDisabled,
    );
  }

  InputBorder _getErrorBorder() {
    return _getBorder(
      ArDriveTheme.of(context).themeData.colors.themeErrorOnEmphasis,
    );
  }

  InputBorder _getSuccessBorder() {
    return _getBorder(
      ArDriveTheme.of(context).themeData.colors.themeSuccessEmphasis,
    );
  }

  Color _hintTextColor() {
    if (widget.isEnabled) {
      return ArDriveTheme.of(context).themeData.colors.themeInputPlaceholder;
    }
    return ArDriveTheme.of(context).themeData.colors.themeFgDisabled;
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
        print(validation);
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
    required this.color,
  });

  final String? text;
  final bool showing;
  final Color color;

  @override
  State<AnimatedTextFieldLabel> createState() => AnimatedTextFieldLabelState();
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
        height: showing ? 35 : 0,
        width: double.infinity,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: !visible ? 100 : 300),
          child: TextFieldLabel(
            color: widget.color,
            text: widget.text ?? '',
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
    required this.color,
    this.bold = false,
  });
  final String text;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: bold
          ? ArDriveTypography.body.bodyBold(
              color: color,
            )
          : ArDriveTypography.body.bodyRegular(
              color: color,
            ),
    );
  }
}
