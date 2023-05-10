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
    this.height = 48,
    this.width = 200,
    this.anchor = const Aligned(
      follower: Alignment.topLeft,
      target: Alignment.bottomLeft,
      offset: Offset(0, 4),
    ),
    this.footer,
    this.footerHeight = 60,
    this.calculateVerticalAlignment,
  });

  final double height;
  final double width;
  final List<ArDriveDropdownItem> items;

  final Widget? footer;
  final double footerHeight;

  final Widget child;
  final EdgeInsets? contentPadding;
  final Anchor anchor;

  // retruns the alignment based if the current widget y coordinate is greater than half the screen height
  final Alignment Function(bool)? calculateVerticalAlignment;

  @override
  State<ArDriveDropdown> createState() => _ArDriveDropdownState();
}

class _ArDriveDropdownState extends State<ArDriveDropdown> {
  bool visible = false;
  late Anchor _anchor;

  double dropdownHeight = 0;

  @override
  void initState() {
    _anchor = widget.anchor;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final renderBox = context.findRenderObject() as RenderBox?;

        final position = renderBox?.localToGlobal(Offset.zero);

        if (position != null && widget.calculateVerticalAlignment != null) {
          final y = position.dy;

          final screenHeight = MediaQuery.of(context).size.height;

          Alignment alignment;

          alignment =
              widget.calculateVerticalAlignment!.call(y > screenHeight / 2);

          _anchor = Aligned(
            follower: alignment,
            target: Alignment.bottomLeft,
          );
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double dropdownHeight = (widget.items.length * widget.height) +
        (widget.footer != null ? widget.footerHeight : 0);

    return ArDriveOverlay(
      onVisibleChange: (value) {
        setState(() {
          visible = value;
        });
      },
      visible: visible,
      anchor: _anchor,
      content: _ArDriveDropdownContent(
        height: dropdownHeight,
        child: ArDriveScrollBar(
          isVisible: false,
          child: ArDriveCard(
            border: Border.all(
              color: ArDriveTheme.of(context)
                  .themeData
                  .dropdownTheme
                  .backgroundColor,
              width: 1,
            ),
            boxShadow: BoxShadowCard.shadow80,
            elevation: 5,
            contentPadding: widget.contentPadding ?? EdgeInsets.zero,
            content: SizedBox(
              width: widget.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: List.generate(widget.items.length, (index) {
                          return FutureBuilder<bool>(
                              future: Future.delayed(
                                Duration(milliseconds: (index + 1) * 50),
                                () => true,
                              ),
                              builder: (context, snapshot) {
                                return AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 100),
                                  firstChild: SizedBox(
                                    width: widget.width,
                                    height: widget.height,
                                    child: GestureDetector(
                                      onTap: () {
                                        widget.items[index].onClick?.call();
                                        setState(() {
                                          visible = false;
                                        });
                                      },
                                      child: widget.items[index],
                                    ),
                                  ),
                                  secondChild: SizedBox(
                                    height: 0,
                                    width: widget.width,
                                  ),
                                  crossFadeState:
                                      snapshot.hasData && snapshot.data!
                                          ? CrossFadeState.showFirst
                                          : CrossFadeState.showSecond,
                                );
                              });
                        }),
                      ),
                    ),
                    if (widget.footer != null)
                      FutureBuilder<bool>(
                        future: Future.delayed(
                          Duration(
                              milliseconds: (widget.items.length + 1) * 50),
                          () => true,
                        ),
                        builder: (context, snapshot) {
                          return AnimatedCrossFade(
                            duration: const Duration(milliseconds: 100),
                            firstChild: SizedBox(
                              width: widget.width,
                              child: widget.footer,
                            ),
                            secondChild: SizedBox(
                              height: 0,
                              width: widget.width,
                            ),
                            crossFadeState: snapshot.hasData && snapshot.data!
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                          );
                        },
                      ),
                  ],
                ),
              ),
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
      duration: const Duration(milliseconds: 200),
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
    return SizedBox(
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
    _visible = widget.visible ?? false;
    _updateVisibleState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
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
        // alignment: Alignment.center,
        child: widget.content,
      ),
    );
  }
}
