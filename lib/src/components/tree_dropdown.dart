import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

export 'package:flutter_portal/flutter_portal.dart'
    show Anchor, Aligned, Filled;

class ArDriveTreeDropdown extends StatefulWidget {
  const ArDriveTreeDropdown({
    super.key,
    required this.rootNode,
    required this.child,
    this.contentPadding,
    this.height = 48,
    this.width = 200,
    required this.anchor,
    this.dividerThickness,
    this.maxHeight,
    this.showScrollbars = false,
    this.onClick,
    this.isNested = false,
  });

  final double height;
  final double width;
  final TreeDropdownNode rootNode;
  final Widget child;
  final EdgeInsets? contentPadding;
  final double? dividerThickness;
  final Anchor anchor;
  final double? maxHeight;
  final bool showScrollbars;
  final Function? onClick;
  final bool isNested;

  @override
  State<ArDriveTreeDropdown> createState() => _ArDriveTreeDropdownState();
}

class _ArDriveTreeDropdownState extends State<ArDriveTreeDropdown> {
  late Anchor _anchor;
  ScrollController? _scrollController;
  TreeDropdownNode? visibleNode;

  @override
  void initState() {
    _anchor = widget.anchor;

    if (widget.showScrollbars) {
      _scrollController = ScrollController();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = visibleNode != null;

    final parentKey = GlobalKey();

    return Barrier(
      onClose: () {
        setVisible(null);
      },
      visible: isVisible,
      child: Column(
        children: [
          GestureDetector(
            key: parentKey,
            behavior: HitTestBehavior.translucent,
            onTap: () {
              widget.onClick?.call();
              setVisible(widget.rootNode);
            },
            child: IgnorePointer(
              ignoring: visibleNode == widget.rootNode,
              child: widget.child,
            ),
          ),
          SizedBox(
            height: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ..._buildNodesTree(
                  widget.rootNode,
                  parentKey: parentKey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNodesTree(
    TreeDropdownNode root, {
    GlobalKey? parentKey,
  }) {
    final children = root.children;
    final dropDownItems = <ArDriveTreeDropdownItem>[];
    final dropdownSubOptions = <Widget>[];

    final isVisible = visibleNode == root ||
        (visibleNode != null && root.findChildById(visibleNode!.id) != null);

    for (var i = 0; i < children.length; i++) {
      final node = children[i];
      final nodeHasChildren = node.children.isNotEmpty;
      final isClickable =
          !node.isDisabled && (node.onClick != null || nodeHasChildren);

      final optionKey = GlobalKey();
      final dropdDownOption = ArDriveTreeDropdownItem(
        key: optionKey,
        isDisabled: node.isDisabled,
        onClick: () {
          if (isClickable) {
            node.onClick?.call();
            if (nodeHasChildren) {
              setVisible(node);
            } else {
              setVisible(null);
            }
          }
        },
        content: node.content,
      );
      dropDownItems.add(dropdDownOption);

      // Recursively build the tree children
      if (nodeHasChildren && isVisible) {
        dropdownSubOptions.addAll(_buildNodesTree(node, parentKey: optionKey));
      }
    }

    final PositionedPortalTarget positionedPortalTarget =
        PositionedPortalTarget(
      visible: isVisible,
      anchor: _anchor,
      portalFollower: _contentForNode(dropDownItems),
      parentKey: parentKey,
    );

    return [
      positionedPortalTarget,
      ...dropdownSubOptions,
    ];
  }

  _ArDriveTreeDropdownContent _contentForNode(
      List<ArDriveTreeDropdownItem> dropdownItems) {
    final dropdownHeight =
        widget.maxHeight ?? dropdownItems.length * widget.height;
    return _ArDriveTreeDropdownContent(
      height: dropdownHeight,
      child: ArDriveScrollBar(
        controller: _scrollController,
        isVisible: true,
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
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 200,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: List.generate(
                  dropdownItems.length,
                  (index) => dropdownItems[index], // TODO: add divider
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setVisible(TreeDropdownNode? node) {
    setState(() {
      visibleNode = node;
    });
  }
}

class PositionedPortalTarget extends StatefulWidget {
  final bool visible;
  final Anchor anchor;
  final Widget portalFollower;
  final GlobalKey? parentKey;

  const PositionedPortalTarget({
    super.key,
    required this.visible,
    required this.anchor,
    required this.portalFollower,
    this.parentKey,
  });

  @override
  State<PositionedPortalTarget> createState() => _PositionedPortalTargetState();
}

class _PositionedPortalTargetState extends State<PositionedPortalTarget> {
  late Anchor _anchor;
  late Offset _parentPosition;
  late Size _size;

  @override
  void initState() {
    _anchor = widget.anchor;
    _parentPosition = Offset.zero;
    _size = Size.zero;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final parentRenderBox =
            widget.parentKey?.currentContext?.findRenderObject() as RenderBox?;
        final contextRenderBox = context.findRenderObject() as RenderBox?;

        final globalParentPosition =
            parentRenderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
        _parentPosition =
            contextRenderBox?.globalToLocal(globalParentPosition) ??
                Offset.zero;

        _size = parentRenderBox?.size ?? Size.zero;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _parentPosition.dx,
      top: _parentPosition.dy,
      child: PortalTarget(
        visible: widget.visible,
        anchor: _anchor,
        portalFollower: widget.portalFollower,
        child: SizedBox.fromSize(
          size: _size,
        ),
      ),
    );
  }
}

class TreeDropdownNode extends Equatable {
  final List<TreeDropdownNode> children;
  final String id;
  final Widget content;
  final VoidCallback? onClick;
  final bool isDisabled;

  const TreeDropdownNode({
    required this.id,
    this.children = const [],
    required this.content,
    this.onClick,
    this.isDisabled = false,
  });

  TreeDropdownNode? findChildById(String id) {
    for (final child in children) {
      if (child.id == id) {
        return child;
      }
    }

    return null;
  }

  @override
  List<Object?> get props => [id, children, content];

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'TreeDropdownNode(id: $id, childrens: ${children.length},'
        ' content: $content)';
  }
}

class ArDriveTreeDropdownItem extends StatefulWidget {
  const ArDriveTreeDropdownItem({
    super.key,
    required this.content,
    this.onClick,
    this.children = const [],
    required this.isDisabled,
  });

  final Widget content;
  final Function()? onClick;
  final List<ArDriveTreeDropdownItem> children;
  final bool isDisabled;

  @override
  State<ArDriveTreeDropdownItem> createState() =>
      _ArDriveTreeDropdownItemState();
}

class _ArDriveTreeDropdownItemState extends State<ArDriveTreeDropdownItem> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    final theme = ArDriveTheme.of(context).themeData.dropdownTheme;
    final isClickable = !widget.isDisabled &&
        (widget.onClick != null || widget.children.isNotEmpty);

    return GestureDetector(
      onTap: () {
        widget.onClick?.call();
      },
      child: MouseRegion(
        cursor:
            isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onHover: (event) {
          if (isClickable) {
            setState(() {
              hovering = true;
            });
          }
        },
        onExit: (event) {
          if (isClickable) {
            setState(() {
              hovering = false;
            });
          }
        },
        child: Container(
          color: hovering ? theme.hoverColor : theme.backgroundColor,
          child: widget.content,
        ),
      ),
    );
  }
}

class _ArDriveTreeDropdownContent extends StatefulWidget {
  @override
  _ArDriveTreeDropdownContentState createState() =>
      _ArDriveTreeDropdownContentState();

  const _ArDriveTreeDropdownContent({
    required this.child,
    this.height = 200,
  });

  final Widget child;
  final double height;
}

class _ArDriveTreeDropdownContentState
    extends State<_ArDriveTreeDropdownContent> with TickerProviderStateMixin {
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
