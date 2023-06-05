import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:flutter/material.dart';
import 'package:storybook/src/ardrive_app_base.dart';
import 'package:widgetbook/widgetbook.dart';

class ColorOption {
  final String name;
  final Color value;

  const ColorOption({required this.name, required this.value});
}

WidgetbookCategory getColors() {
  return WidgetbookCategory(name: 'Colors', children: [
    WidgetbookComponent(name: 'Colors', useCases: [
      WidgetbookUseCase(
          name: 'Foreground',
          builder: (context) {
            return ArDriveStorybookAppBase(builder: (context) {
              final colors = ArDriveTheme.of(context).themeData.colors;

              List<ColorOption> foreground = [
                ColorOption(
                  name: 'themeFgDefault',
                  value: colors.themeFgDefault,
                ),
                ColorOption(
                  name: 'themeFgMuted',
                  value: colors.themeFgMuted,
                ),
                ColorOption(
                  name: 'themeFgSubtle',
                  value: colors.themeFgSubtle,
                ),
                ColorOption(
                  name: 'themeFgOnDisabled',
                  value: colors.themeFgOnDisabled,
                ),
                ColorOption(
                  name: 'themeFgOnAccent',
                  value: colors.themeFgOnAccent,
                ),
                ColorOption(
                  name: 'themeFgDisabled',
                  value: colors.themeFgDisabled,
                ),
              ];
              return Center(
                child: Container(
                  height: 120,
                  width: 120,
                  color: context.knobs
                      .options<ColorOption>(
                        label: 'Colors',
                        labelBuilder: (c) => c.name,
                        options: foreground,
                      )
                      .value,
                ),
              );
            });
          }),
      WidgetbookUseCase(
        name: 'Background',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            final colors = ArDriveTheme.of(context).themeData.colors;

            List<ColorOption> background = [
              ColorOption(
                name: 'themeBgSurface',
                value: colors.themeBgSurface,
              ),
              ColorOption(
                name: 'themeGbMuted',
                value: colors.themeGbMuted,
              ),
              ColorOption(
                name: 'themeBgSubtle',
                value: colors.themeBgSubtle,
              ),
              ColorOption(
                name: 'themeBgCanvas',
                value: colors.themeBgCanvas,
              ),
            ];

            return Center(
              child: Container(
                  height: 120,
                  width: 120,
                  color: context.knobs
                      .options<ColorOption>(
                        label: 'Colors',
                        labelBuilder: (c) => c.name,
                        options: background,
                      )
                      .value),
            );
          });
        },
      ),
      WidgetbookUseCase(
        name: 'Accent',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            final colors = ArDriveTheme.of(context).themeData.colors;

            List<ColorOption> accent = [
              ColorOption(
                name: 'themeAccentBrand',
                value: colors.themeAccentBrand,
              ),
              ColorOption(
                name: 'themeAccentDisabled',
                value: colors.themeAccentDisabled,
              ),
              ColorOption(
                name: 'themeAccentEmphasis',
                value: colors.themeAccentEmphasis,
              ),
              ColorOption(
                name: 'themeAccentMuted',
                value: colors.themeAccentMuted,
              ),
              ColorOption(
                name: 'themeAccentSubtle',
                value: colors.themeAccentSubtle,
              ),
            ];

            return Center(
              child: Container(
                  height: 120,
                  width: 120,
                  color: context.knobs
                      .options<ColorOption>(
                        label: 'Colors',
                        labelBuilder: (c) => c.name,
                        options: accent,
                      )
                      .value),
            );
          });
        },
      ),
      WidgetbookUseCase(
        name: 'Warning',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            final colors = ArDriveTheme.of(context).themeData.colors;

            List<ColorOption> warning = [
              ColorOption(
                name: 'themeWarningFg',
                value: colors.themeWarningFg,
              ),
              ColorOption(
                name: 'themeWarningEmphasis',
                value: colors.themeWarningEmphasis,
              ),
              ColorOption(
                name: 'themeWarningMuted',
                value: colors.themeWarningMuted,
              ),
              ColorOption(
                name: 'themeWarningSubtle',
                value: colors.themeWarningSubtle,
              ),
              ColorOption(
                name: 'themeWarningOnWarning',
                value: colors.themeWarningOnWarning,
              ),
            ];

            return Center(
              child: Container(
                  height: 120,
                  width: 120,
                  color: context.knobs
                      .options<ColorOption>(
                        label: 'Colors',
                        labelBuilder: (c) => c.name,
                        options: warning,
                      )
                      .value),
            );
          });
        },
      ),
      WidgetbookUseCase(
        name: 'Error',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            final colors = ArDriveTheme.of(context).themeData.colors;

            List<ColorOption> error = [
              ColorOption(
                name: 'themeErrorFg',
                value: colors.themeErrorFg,
              ),
              ColorOption(
                name: 'themeErrorMuted',
                value: colors.themeErrorMuted,
              ),
              ColorOption(
                name: 'themeErrorSubtle',
                value: colors.themeErrorSubtle,
              ),
              ColorOption(
                name: 'themeErrorOnError',
                value: colors.themeErrorOnError,
              ),
            ];

            return Center(
              child: Container(
                height: 120,
                width: 120,
                color: context.knobs
                    .options<ColorOption>(
                      label: 'Colors',
                      labelBuilder: (c) => c.name,
                      options: error,
                    )
                    .value,
              ),
            );
          });
        },
      ),
      WidgetbookUseCase(
        name: 'Info',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            final colors = ArDriveTheme.of(context).themeData.colors;

            List<ColorOption> info = [
              ColorOption(
                name: 'themeInfoFb',
                value: colors.themeInfoFb,
              ),
              ColorOption(
                name: 'themeInfoEmphasis',
                value: colors.themeInfoEmphasis,
              ),
              ColorOption(
                name: 'themeInfoMuted',
                value: colors.themeInfoMuted,
              ),
              ColorOption(
                name: 'themeInfoSubtle',
                value: colors.themeInfoSubtle,
              ),
              ColorOption(
                name: 'themeInfoOnInfo',
                value: colors.themeInfoOnInfo,
              ),
            ];

            return Center(
              child: Container(
                  height: 120,
                  width: 120,
                  color: context.knobs
                      .options<ColorOption>(
                        label: 'Colors',
                        labelBuilder: (c) => c.name,
                        options: info,
                      )
                      .value),
            );
          });
        },
      ),
      WidgetbookUseCase(
        name: 'Success',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            final colors = ArDriveTheme.of(context).themeData.colors;

            List<ColorOption> success = [
              ColorOption(
                name: 'themeSuccessFb',
                value: colors.themeSuccessFb,
              ),
              ColorOption(
                name: 'themeSuccessEmphasis',
                value: colors.themeSuccessEmphasis,
              ),
              ColorOption(
                name: 'themeSuccessMuted',
                value: colors.themeSuccessMuted,
              ),
              ColorOption(
                name: 'themeSuccessSubtle',
                value: colors.themeSuccessSubtle,
              ),
              ColorOption(
                name: 'themeSuccessOnSuccess',
                value: colors.themeSuccessOnSuccess,
              ),
            ];

            return Center(
              child: Container(
                  height: 120,
                  width: 120,
                  color: context.knobs
                      .options<ColorOption>(
                        label: 'Colors',
                        labelBuilder: (c) => c.name,
                        options: success,
                      )
                      .value),
            );
          });
        },
      ),
      WidgetbookUseCase(
        name: 'Overlay',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            final colors = ArDriveTheme.of(context).themeData.colors;

            List<ColorOption> overlay = [
              ColorOption(
                name: 'themeOverlayBackground',
                value: colors.themeOverlayBackground,
              ),
            ];

            return Center(
              child: Container(
                  height: 120,
                  width: 120,
                  color: context.knobs
                      .options<ColorOption>(
                        label: 'Colors',
                        labelBuilder: (c) => c.name,
                        options: overlay,
                      )
                      .value),
            );
          });
        },
      ),
    ]),
  ]);
}
