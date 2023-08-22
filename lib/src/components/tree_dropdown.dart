part of './overlay.dart';

class ArDriveTreeDropdown extends StatefulWidget {
  const ArDriveTreeDropdown({
    super.key,
    required this.rootNode,
    required this.child,
    this.contentPadding,
    this.height = 48,
    this.width = 200,
    this.anchor = const Aligned(
      follower: Alignment.topLeft,
      target: Alignment.bottomLeft,
      offset: Offset(0, 4),
    ),
    this.dividerThickness,
    this.calculateVerticalAlignment,
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

  // retruns the alignment based if the current widget y coordinate is greater than half the screen height
  final Alignment Function(bool isAboveHalfScreen)? calculateVerticalAlignment;

  @override
  State<ArDriveTreeDropdown> createState() => _ArDriveTreeDropdownState();
}

class _ArDriveTreeDropdownState extends State<ArDriveTreeDropdown> {
  late Anchor _anchor;
  ScrollController? _scrollController;

  TreeDropdownNode? visibleNode;

  double dropdownHeight = 0;

  @override
  void initState() {
    _anchor = widget.anchor;

    if (widget.showScrollbars) {
      _scrollController = ScrollController();
    }

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

          final isAboveHalfScreen = y > screenHeight / 2;
          alignment =
              widget.calculateVerticalAlignment!.call(isAboveHalfScreen);

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
    final isVisible = visibleNode != null;

    return Barrier(
      onClose: () {
        print('Barrier closed!');
        setVisible(null);
      },
      visible: isVisible,
      child: Column(
        children: [
          GestureDetector(
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
          if (isVisible)
            SizedBox(
              height: 0,
              child: Stack(
                fit: StackFit.passthrough,
                clipBehavior: Clip.none,
                children: _buildNodesTree(widget.rootNode),
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
    final dropDownItems = <ArDriveDropdownItem>[];
    final dropdownSubOptions = <Widget>[];

    for (var i = 0; i < children.length; i++) {
      final node = children[i];
      final nodeHasChildren = node.children.isNotEmpty;

      final optionKey = GlobalKey();
      final dropdDownOption = ArDriveDropdownItem(
        key: optionKey,
        onClick: () {
          print('Clicked on $node');
          final isClickable =
              !node.isDisabled && (node.onClick != null || nodeHasChildren);
          if (isClickable) {
            print('It\'s not disabled');
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
      if (nodeHasChildren) {
        dropdownSubOptions.addAll(_buildNodesTree(node, parentKey: optionKey));
      }
    }

    final isVisible = visibleNode == root ||
        (visibleNode != null && root.findChildById(visibleNode!.id) != null);

    if (isVisible) {
      dropdownHeight = dropDownItems.length * widget.height;
      print('Hello! I\'m visible - $root');
    }

    final PositionedPortalTarget positionedPortalTarget =
        PositionedPortalTarget(
      visible: isVisible,
      anchor: _anchor,
      portalFollower: _contentForNode(dropDownItems),
      calculateVerticalAlignment: widget.calculateVerticalAlignment,
    );

    return [
      positionedPortalTarget,
      ...dropdownSubOptions,
    ];
  }

  _ArDriveDropdownContent _contentForNode(
      List<ArDriveDropdownItem> dropdownItems) {
    return _ArDriveDropdownContent(
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
    print('Now visible: $node');
    setState(() {
      visibleNode = node;
    });
  }
}

class PositionedPortalTarget extends StatefulWidget {
  final bool visible;
  final Anchor anchor;
  final Widget portalFollower;
  final Alignment Function(bool isAboveHalfScreen)? calculateVerticalAlignment;
  final GlobalKey? parentKey;

  const PositionedPortalTarget({
    super.key,
    required this.visible,
    required this.anchor,
    required this.portalFollower,
    this.calculateVerticalAlignment,
    this.parentKey,
  });

  @override
  State<PositionedPortalTarget> createState() => _PositionedPortalTargetState();
}

class _PositionedPortalTargetState extends State<PositionedPortalTarget> {
  late Anchor _anchor;
  // late Offset _offset;
  late Rect _rect;
  late Size _size;

  @override
  void initState() {
    _anchor = widget.anchor;
    // _offset = Offset.zero;
    _rect = Rect.zero;
    _size = Size.zero;
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

          final isAboveHalfScreen = y > screenHeight / 2;
          alignment =
              widget.calculateVerticalAlignment!.call(isAboveHalfScreen);

          _anchor = Aligned(
            follower: alignment,
            target: Alignment.bottomLeft,
          );
        }

        // TODO: make use of the parentKey to determine size and position
        final parentRenderBox =
            widget.parentKey?.currentContext?.findRenderObject() as RenderBox?;

        _rect = parentRenderBox?.paintBounds ?? Rect.zero;
        _size = parentRenderBox?.size ?? Size.zero;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final Widget child;

    // Use size and position of parent option

    return Positioned.fromRect(
      rect: _rect,
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
  final TreeDropdownNode? parent;
  final List<TreeDropdownNode> children;
  final String id;
  final Widget content;
  final VoidCallback? onClick;
  final bool isDisabled;

  String get path => '${parent?.path ?? ''}/$id';

  const TreeDropdownNode({
    required this.id,
    required this.parent,
    this.children = const [],
    required this.content,
    this.onClick,
    this.isDisabled = false,
  });

  TreeDropdownNode? findNode(String path) {
    if (path == this.path) {
      return this;
    }

    for (final child in children) {
      final node = child.findNode(path);
      if (node != null) {
        return node;
      }
    }

    return null;
  }

  TreeDropdownNode? findParent(String path) {
    if (path == this.path) {
      return parent;
    }

    for (final child in children) {
      final node = child.findParent(path);
      if (node != null) {
        return node;
      }
    }

    return null;
  }

  TreeDropdownNode? findChild(String path) {
    if (path == this.path) {
      return this;
    }

    for (final child in children) {
      final node = child.findChild(path);
      if (node != null) {
        return node;
      }
    }

    return null;
  }

  TreeDropdownNode? findChildById(String id) {
    for (final child in children) {
      if (child.id == id) {
        return child;
      }
    }

    return null;
  }

  TreeDropdownNode? findParentById(String id) {
    if (this.id == id) {
      return parent;
    }

    for (final child in children) {
      final node = child.findParentById(id);
      if (node != null) {
        return node;
      }
    }

    return null;
  }

  @override
  List<Object?> get props => [id, parent, children, content];

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'TreeDropdownNode(id: $id, parent: $parent,'
        ' childrens: ${children.length}, content: $content)';
  }
}
