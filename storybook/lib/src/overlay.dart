import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:flutter/material.dart';
import 'package:storybook/src/ardrive_app_base.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookCategory overlay() {
  return WidgetbookCategory(name: 'Overlay', widgets: [
    WidgetbookComponent(name: 'Dropdown', useCases: [
      WidgetbookUseCase(
        name: 'Dropdown',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            return Column(
              children: [
                ArDriveDropdown(
                  items: [
                    ArDriveDropdownItem(
                      content: Text(
                        'Create new Drive',
                        style: ArDriveTypography.body.buttonLargeBold(),
                      ),
                    ),
                    ArDriveDropdownItem(
                      content: Text(
                        'Create new Drive',
                        style: ArDriveTypography.body.buttonLargeBold(),
                      ),
                    ),
                    ArDriveDropdownItem(
                      content: Text(
                        'Create new Drive',
                        style: ArDriveTypography.body.buttonLargeBold(),
                      ),
                    )
                  ],
                  child: const Text('some text'),
                )
              ],
            );
          });
        },
      ),
      WidgetbookUseCase(
        name: 'Dropdown with Footer',
        builder: (context) {
          return ArDriveStorybookAppBase(builder: (context) {
            return Column(
              children: [
                ArDriveDropdown(
                  items: [
                    ArDriveDropdownItem(
                      content: Text(
                        'Create new Drive',
                        style: ArDriveTypography.body.buttonLargeBold(),
                      ),
                    ),
                    ArDriveDropdownItem(
                      content: Text(
                        'Create new Drive',
                        style: ArDriveTypography.body.buttonLargeBold(),
                      ),
                    ),
                    ArDriveDropdownItem(
                      content: Text(
                        'Create new Drive',
                        style: ArDriveTypography.body.buttonLargeBold(),
                      ),
                    )
                  ],
                  footerHeight: 128,
                  footer: Container(
                    height: 64,
                    width: double.infinity,
                    color: Colors.red,
                  ),
                  child: const Text('some text'),
                )
              ],
            );
          });
        },
      ),
    ]),
  ]);
}
