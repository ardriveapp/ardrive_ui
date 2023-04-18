import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

export 'package:flutter_portal/flutter_portal.dart'
    show Anchor, Aligned, Filled;

class ArDriveDropdown extends StatefulWidget {
  const ArDriveDropdown({
    super.key,
    required this.items,
    required this.child,
    this.contentPadding,
    this.height = 60,
    this.width = 200,
    this.anchor = const Aligned(
      follower: Alignment.topLeft,
      target: Alignment.bottomLeft,
      offset: Offset(0, 4),
    ),
  });

  final double height;
  final double width;
  final List<ArDriveDropdownItem> items;
  final Widget child;
  final EdgeInsets? contentPadding;
  final Anchor anchor;

  @override
  State<ArDriveDropdown> createState() => _ArDriveDropdownState();
}

class _ArDriveDropdownState extends State<ArDriveDropdown> {
  bool visible = false;

  double dropdownHeight = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('dropdownHeight: $dropdownHeight');
    print('widget.items.length: ${widget.items.length}');
    print('visible: $visible');

    dropdownHeight = widget.items.length * widget.height;

    return ArDriveOverlay(
      onVisibleChange: (value) {
        setState(() {
          visible = value;
        });
      },
      visible: visible,
      anchor: widget.anchor,
      content: _ArDriveDropdownContent(
        height: dropdownHeight,
        child: ArDriveCard(
          boxShadow: BoxShadowCard.shadow100,
          elevation: 5,
          contentPadding: widget.contentPadding ?? EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(widget.items.length, (index) {
                return GestureDetector(
                  onTap: () {
                    widget.items[index].onClick?.call();
                    setState(() {
                      visible = false;
                    });
                  },
                  child: SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: widget.items[index],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            visible = !visible;
          });
        },
        child: IgnorePointer(ignoring: visible, child: widget.child),
      ),
    );
  }
}

// GestureDetector(
//           behavior: HitTestBehavior.translucent,
//           onTap: () {
//             setState(() {
//               _visible = true;
//             });
//           },
//           child: IgnorePointer(
//             ignoring: _visible,
//             child: widget.child,
//           ),
//         ),

class _ArDriveDropdownContent extends StatefulWidget {
  @override
  _ArDriveDropdownContentState createState() => _ArDriveDropdownContentState();

  const _ArDriveDropdownContent({
    super.key,
    required this.child,
    this.height = 200,
  });

  final Widget child;
  final double height;
}

class _ArDriveDropdownContentState extends State<_ArDriveDropdownContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: widget.height)
        .animate(_animationController)
      ..addListener(() {
        setState(() {
          _height = _animation.value;
        });
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: widget.child,
    );
  }
}

class ArDriveOverlay extends StatefulWidget {
  const ArDriveOverlay({
    super.key,
    required this.content,
    this.contentPadding = const EdgeInsets.all(16),
    required this.child,
    required this.anchor,
    this.visible,
    this.onVisibleChange,
  });

  final Widget child;
  final Widget content;
  final EdgeInsets contentPadding;
  final Anchor anchor;
  final bool? visible;
  final Function(bool)? onVisibleChange;
  @override
  State<ArDriveOverlay> createState() => _ArDriveOverlayState();
}

class _ArDriveOverlayState extends State<ArDriveOverlay> {
  @override
  void initState() {
    super.initState();
    print('initState');
    _visible = widget.visible ?? false;
    _updateVisibleState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
    if (widget.visible != oldWidget.visible) {
      setState(() {
        _updateVisibleState();
      });
    }
  }

  void _updateVisibleState() {
    if (widget.visible != null) {
      _visible = widget.visible!;
    } else {
      _visible = false;
    }

    // widget.onVisibleChange?.call(_visible);
  }

  late bool _visible;

  @override
  Widget build(BuildContext context) {
    print('_visible: $_visible');
    return Barrier(
      onClose: () {
        setState(() {
          _visible = !_visible;
          widget.onVisibleChange?.call(_visible);
        });
      },
      visible: _visible,
      child: PortalTarget(
        anchor: widget.anchor,
        portalFollower: widget.content,
        visible: _visible,
        child: widget.child,
      ),
    );
  }
}

class Barrier extends StatelessWidget {
  const Barrier({
    Key? key,
    required this.onClose,
    required this.visible,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onClose;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      closeDuration: kThemeAnimationDuration,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onClose,
      ),
      child: child,
    );
  }
}

class ArDriveDropdownItem extends StatefulWidget {
  const ArDriveDropdownItem({
    super.key,
    required this.content,
    this.onClick,
  });

  final Widget content;
  final Function()? onClick;

  @override
  State<ArDriveDropdownItem> createState() => _ArDriveDropdownItemState();
}

class _ArDriveDropdownItemState extends State<ArDriveDropdownItem> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    final theme = ArDriveTheme.of(context).themeData.dropdownTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (event) => setState(() {
        hovering = false;
      }),
      child: Container(
        color: hovering ? theme.hoverColor : theme.backgroundColor,
        alignment: Alignment.center,
        child: widget.content,
      ),
    );
  }
}
