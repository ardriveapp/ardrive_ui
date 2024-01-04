// ignore_for_file: avoid_print

import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:flutter/material.dart';
import 'package:storybook/src/ardrive_app_base.dart';
import 'package:widgetbook/widgetbook.dart';

Widget buildModalWidget(Widget modal, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      modal,
      const SizedBox(height: 16),
      ArDriveButton(
        text: 'Open modal',
        onPressed: () => showAnimatedDialog(
          context,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: ArDriveStorybookAppBase(
              builder: (context) => modal,
            ),
          ),
        ),
      ),
    ],
  );
}

WidgetbookUseCase buildUseCase(
  String name,
  Widget Function(BuildContext) modalBuilder,
) {
  return WidgetbookUseCase(
    name: name,
    builder: (context) {
      final modal = modalBuilder(context);
      return ArDriveStorybookAppBase(
        builder: (context) => Scaffold(
          body: Center(
            child: buildModalWidget(
              modal,
              context,
            ),
          ),
        ),
      );
    },
  );
}

WidgetbookCategory modals() {
  return WidgetbookCategory(
    name: 'Modals',
    children: [
      WidgetbookComponent(
        name: 'Modals',
        useCases: [
          buildUseCase(
            'Standard',
            (context) {
              return ArDriveStandardModal(
                title: context.knobs.text(
                  label: 'Title',
                  initialValue: 'Warning',
                ),
                description: context.knobs.text(
                  label: 'Content',
                  initialValue:
                      'The file you have selected is too large to download from the mobile app.',
                ),
                actions: context.knobs.options(
                  label: 'Actions',
                  labelBuilder: getActionLabel,
                  options: createActionOptions(3),
                ),
              );
            },
          ),
          buildUseCase(
            'Mini',
            (context) {
              return ArDriveMiniModal(
                title: context.knobs.text(
                  label: 'Title',
                  initialValue: 'Warning',
                ),
                content: context.knobs.text(
                  label: 'content',
                  initialValue: 'You created a new drive.',
                ),
                leading: context.knobs.options(
                  label: 'leading',
                  labelBuilder: (value) => value == null ? 'null' : 'Icon',
                  // ArDriveMiniModal accepts custom widgets as options
                  options: [
                    null,
                    const ArDriveIcon(
                      icon: ArDriveIconsData.triangle,
                      color: Colors.red,
                    ),
                  ],
                ),
              );
            },
          ),
          buildUseCase(
            'Long',
            (context) {
              return ArDriveLongModal(
                title: context.knobs.text(
                  label: 'Title',
                  initialValue: 'Warning',
                ),
                content: context.knobs.text(
                  label: 'content',
                  initialValue: 'You created a new drive.',
                ),
                action: context.knobs.options(
                  label: 'Action',
                  labelBuilder: (value) => value == null ? 'None' : 'Action',
                  options: [
                    null,
                    ModalAction(
                      action: () {},
                      title: 'Action',
                    )
                  ],
                ),
              );
            },
          ),
          buildUseCase(
            'Modal Icon',
            (context) {
              return ArDriveIconModal(
                title: context.knobs
                    .text(label: 'Title', initialValue: 'Settings saved!'),
                content: context.knobs.text(
                    label: 'Content',
                    initialValue:
                        'Your profile settings have been updated. Now you can go ahead and jump on into the ArDrive app, have some fun, enjoy yourself, and upload some really awesome stuff.'),
                icon: ArDriveIcon(
                  icon: ArDriveIconsData.check_cirle,
                  size: 88,
                  color: ArDriveTheme.of(context)
                      .themeData
                      .colors
                      .themeSuccessDefault,
                ),
                actions: context.knobs.options(
                  labelBuilder: getActionLabel,
                  label: 'Actions',
                  options: createActionOptions(1),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}

String getActionLabel(List<ModalAction>? option) {
  if (option == null || option.isEmpty) return 'None';
  switch (option.length) {
    case 1:
      return 'One';
    case 2:
      return 'Two';
    default:
      return 'Three';
  }
}

List<List<ModalAction>?> createActionOptions(int numberOfOptions) {
  return List.generate(
    numberOfOptions,
    (index) => List.generate(
      index + 1,
      (actionNumber) => createModalAction(actionNumber),
    ),
  )..insert(0, null);
}

ModalAction createModalAction(int actionNumber) {
  return ModalAction(
    action: () => print('action $actionNumber'),
    title: 'Action $actionNumber',
  );
}
