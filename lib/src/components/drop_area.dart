import 'dart:async';

import 'package:ardrive_io/ardrive_io.dart';
import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:ardrive_ui/src/constants/size_constants.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// `onDragDone` pass a list of `IOFile` dropped on the area under the `child` widget.
///
/// `onError` returns the exception thrown by the `ArdriveIO` in case of any errors
class ArDriveDropZone extends StatefulWidget {
  const ArDriveDropZone({
    super.key,
    required this.child,
    this.onDragDone,
    this.onDragEntered,
    this.onDragExited,
    this.onError,
  });

  final Widget child;
  final Function(List<IOFile> files)? onDragDone;
  final Function()? onDragEntered;
  final Function()? onDragExited;
  final Function(Object e)? onError;

  @override
  State<ArDriveDropZone> createState() => _ArDriveDropZoneState();
}

class _ArDriveDropZoneState extends State<ArDriveDropZone> {
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        try {
          final files = await Future.wait(
              detail.files.map((e) => IOFileAdapter().fromXFile(e)));
          widget.onDragDone?.call(files);
        } catch (e) {
          widget.onError?.call(e);
        }
      },
      onDragEntered: (detail) {
        widget.onDragEntered?.call();
      },
      onDragExited: (detail) {
        widget.onDragExited?.call();
      },
      child: DottedBorder(
        strokeWidth: 1,
        strokeCap: StrokeCap.butt,
        color: ArDriveTheme.of(context).themeData.colors.themeFgMuted,
        child: widget.child,
      ),
    );
  }
}

/// Returns one file using the drop area or the button
///
class ArDriveDropAreaSingleInput extends StatefulWidget {
  const ArDriveDropAreaSingleInput({
    Key? key,
    this.height,
    this.width,
    required this.dragAndDropDescription,
    required this.dragAndDropButtonTitle,
    this.errorDescription,
    this.validateFile,
    this.platformSupportsDragAndDrop = true,
    this.keepButtonVisible = false,
    required this.controller,
  }) : super(key: key);

  final double? height;
  final double? width;
  final String dragAndDropDescription;
  final String dragAndDropButtonTitle;
  final String? errorDescription;
  final FutureOr<bool> Function(IOFile file)? validateFile;
  final bool platformSupportsDragAndDrop;
  final bool keepButtonVisible;
  final ArDriveDropAreaSingleInputController controller;

  @override
  State<ArDriveDropAreaSingleInput> createState() =>
      _ArDriveDropAreaSingleInputState();
}

class _ArDriveDropAreaSingleInputState
    extends State<ArDriveDropAreaSingleInput> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArDriveDropAreaSingleInputController>(
      create: (_) => widget.controller,
      child: Consumer<ArDriveDropAreaSingleInputController>(
        builder: (BuildContext context, controller, Widget? child) {
          return ArDriveDropZone(
            onDragEntered: () {
              controller.onDragEntered.call();
            },
            onDragDone: (files) async {
              if (widget.validateFile != null &&
                  !(await widget.validateFile!(files.first))) {
                controller.onError.call(DropzoneValidationException());
              } else {
                controller.handleDragDone.call(files.first);
              }
            },
            onError: (e) {
              controller.onError.call(e);
            },
            onDragExited: () {
              controller.onDragExited.call();
            },
            child: Consumer<ArDriveDropAreaSingleInputController>(
              builder: (context, controller, state) {
                return Container(
                  color: controller.backgroundColor,
                  height: widget.height,
                  width: widget.width,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: controller.hasError
                        ? _errorView()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              controller.file != null
                                  ? ArDriveIcons.checkSuccess(
                                      size: dropAreaIconSize,
                                      color: ArDriveTheme.of(context)
                                          .themeData
                                          .colors
                                          .themeFgMuted,
                                    )
                                  : ArDriveIcons.uploadCloud(
                                      size: dropAreaIconSize,
                                      color: ArDriveTheme.of(context)
                                          .themeData
                                          .colors
                                          .themeFgMuted,
                                    ),
                              if (controller.file != null)
                                Padding(
                                  padding: dropAreaItemContentPadding,
                                  child: Text(
                                    controller.file!.name,
                                    style: ArDriveTypography.body.smallBold(),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              if (widget.platformSupportsDragAndDrop)
                                Text(
                                  widget.dragAndDropDescription,
                                  style: ArDriveTypography.body.smallBold(),
                                ),
                              const SizedBox(height: 20),
                              if (controller.file == null ||
                                  widget.keepButtonVisible)
                                _button(),
                            ],
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _button() {
    return ArDriveButton(
      text: widget.dragAndDropButtonTitle,
      onPressed: () async {
        widget.controller.handleButtonCallback.call();
      },
      maxHeight: buttonActionHeight,
      fontStyle: ArDriveTypography.body.buttonNormalRegular(
        color: ArDriveTheme.of(context).themeData.colors.themeAccentSubtle,
      ),
      backgroundColor: ArDriveTheme.of(context).themeData.colors.themeFgDefault,
    );
  }

  Widget _errorView() {
    return Column(
      children: [
        ArDriveIcons.warning(),
        const SizedBox(
          height: 8,
        ),
        if (widget.errorDescription != null)
          Text(
            widget.errorDescription!,
            style: ArDriveTypography.body.smallBold(),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: _button(),
        ),
      ],
    );
  }
}

class ArDriveDropAreaSingleInputController with ChangeNotifier {
  IOFile? _file;
  bool _hasError = false;
  Color? _backgroundColor;

  final Function() onDragEntered;
  final Function() onDragExited;
  final Function(IOFile file) onFileAdded;
  final Function(Object e) onError;
  final FutureOr<bool> Function(IOFile file)? validateFile;

  ArDriveDropAreaSingleInputController({
    required this.onDragEntered,
    required this.onDragExited,
    required this.onFileAdded,
    required this.onError,
    this.validateFile,
  });

  void handleDragDone(IOFile file) async {
    if (validateFile != null && !(await validateFile!(file))) {
      _hasError = true;
      onError.call(
        DropzoneValidationException(),
      );
    } else {
      _file = file;
      _hasError = false;
      onFileAdded.call(_file!);
    }

    notifyListeners();
  }

  void handleDragEntered() {
    onDragEntered.call();
  }

  void handleDragExited() {
    onDragExited.call();
  }

  void handleError(Object e, BuildContext context) {
    _hasError = true;
    _backgroundColor =
        ArDriveTheme.of(context).themeData.colors.themeErrorMuted;
    onError.call(e);
    notifyListeners();
  }

  void handleButtonCallback() async {
    try {
      final selectedFile =
          await ArDriveIO().pickFile(fileSource: FileSource.fileSystem);
      // validate file
      if (validateFile != null && !(await validateFile!(selectedFile))) {
        _hasError = true;
        onError.call(
          DropzoneValidationException(),
        );
      } else {
        _file = selectedFile;
        _hasError = false;
        onFileAdded.call(_file!);
      }

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _hasError = true;
      notifyListeners();
    }
  }

  void reset() {
    _file = null;
    _hasError = false;
    notifyListeners();
  }

  bool get hasError => _hasError;

  Color? get backgroundColor => _backgroundColor;

  IOFile? get file => _file;
}

class DropzoneValidationException implements Exception {}
