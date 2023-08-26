import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:flutter/material.dart';

class ArDriveSubmenuItem {
  final Widget widget;
  final List<ArDriveSubmenuItem>? children;
  final Function? onClick;
  final MenuController menuController = MenuController();
  final bool isDisabled;

  ArDriveSubmenuItem({
    required this.widget,
    this.children,
    this.onClick,
    this.isDisabled = false,
  });
}

class ArDriveSubmenu extends StatefulWidget {
  const ArDriveSubmenu({
    super.key,
    required this.child,
    required this.menuChildren,
    this.alignmentOffset = Offset.zero,
  });

  final Widget child;
  final List<ArDriveSubmenuItem> menuChildren;
  final Offset alignmentOffset;

  @override
  State<ArDriveSubmenu> createState() => _ArDriveSubmenuState();
}

class _ArDriveSubmenuState extends State<ArDriveSubmenu> {
  final topMenuController = MenuController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ArDriveMenuWidget(
      menuController: topMenuController,
      menuChildren: _buildMenu(widget.menuChildren),
      alignmentOffset: widget.alignmentOffset,
      child: widget.child,
    );
  }

  List<Widget> _buildMenu(List<ArDriveSubmenuItem> menuChildren) {
    List<Widget> children = [];

    for (final element in menuChildren) {
      if (element.children == null) {
        children.add(ArDriveMenuWidget(
          isDisabled: element.isDisabled,
          onClick: () {
            if (!element.isDisabled) {
              element.onClick?.call();
              topMenuController.close();
            }
          },
          parentMenuController: topMenuController,
          menuController: element.menuController,
          menuChildren: const [],
          child: element.widget,
        ));
        continue;
      }
      children.add(_buildMenuItem(element, element.menuController));
    }
    return children;
  }

  Widget _buildMenuItem(
      ArDriveSubmenuItem item, MenuController menuController) {
    return ArDriveMenuWidget(
      isDisabled: item.isDisabled,
      onClick: () {
        if (!item.isDisabled) {
          item.onClick?.call();
          menuController.close();
        }
      },
      parentMenuController: menuController,
      menuController: item.menuController,
      menuChildren: item.children!.map((e) {
        if (e.children == null) {
          return ArDriveMenuWidget(
            isDisabled: e.isDisabled,
            onClick: () {
              if (!e.isDisabled) {
                e.onClick?.call();
                topMenuController.close();
              }
            },
            parentMenuController: item.menuController,
            menuController: e.menuController,
            menuChildren: const [],
            child: e.widget,
          );
        }
        return _buildMenuItem(e, e.menuController);
      }).toList(),
      child: ArDriveClickArea(child: item.widget),
    );
  }
}

class ArDriveMenuWidget extends StatefulWidget {
  const ArDriveMenuWidget({
    super.key,
    required this.child,
    required this.menuChildren,
    this.parentMenuController,
    required this.menuController,
    this.onClick,
    this.alignmentOffset = Offset.zero,
    this.isDisabled = false,
  });

  final Widget child;
  final List<Widget> menuChildren;
  final MenuController? parentMenuController;
  final MenuController menuController;
  final Function? onClick;
  final Offset alignmentOffset;
  final bool isDisabled;

  @override
  State<ArDriveMenuWidget> createState() => _ArDriveMenuWidgetState();
}

class _ArDriveMenuWidgetState extends State<ArDriveMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: widget.alignmentOffset,
      controller: widget.menuController,
      menuChildren: widget.menuChildren,
      child: GestureDetector(
        onTap: () {
          if (!widget.isDisabled) {
            widget.onClick?.call();
            if (widget.menuChildren.isEmpty &&
                widget.parentMenuController != null) {
              widget.parentMenuController!.close();
              return;
            }

            if (widget.menuController.isOpen) {
              widget.menuController.close();
              return;
            }

            widget.menuController.open();
          }
        },
        child: ArDriveClickArea(child: widget.child),
      ),
    );
  }
}
