import 'package:ardrive_ui/ardrive_ui.dart';
import 'package:ardrive_ui/src/constants/size_constants.dart';
import 'package:ardrive_ui/src/styles/colors/global_colors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TableColumn {
  TableColumn(this.title, this.size);

  final String title;
  final int size;
}

class TableRowWidget {
  TableRowWidget(this.row);

  final List<Widget> row;
}

class ArDriveDataTable<T extends IndexedItem> extends StatefulWidget {
  const ArDriveDataTable({
    super.key,
    required this.columns,
    required this.buildRow,
    required this.rows,
    this.leading,
    this.trailing,
    this.sort,
    this.pageItemsDivisorFactor = 25,
    this.onChangePage,
    this.maxItemsPerPage = 100,
    required this.rowsPerPageText,
    this.sortRows,
    this.onSelectedRows,
    this.onRowTap,
    this.onChangeMultiSelecting,
  });

  final List<TableColumn> columns;
  final List<T> rows;
  final TableRowWidget Function(T row) buildRow;
  final Widget Function(T row)? leading;
  final Widget Function(T row)? trailing;
  final int Function(T a, T b) Function(int columnIndex)? sort;
  final List<T> Function(List<T> rows, int columnIndex, TableSort sortOrder)?
      sortRows;
  final Function(int page)? onChangePage;
  final int pageItemsDivisorFactor;
  final int maxItemsPerPage;
  final String rowsPerPageText;
  final Function(List<T> selectedRows)? onSelectedRows;
  final Function(T row)? onRowTap;
  final Function(bool onChangeMultiSelecting)? onChangeMultiSelecting;

  @override
  State<ArDriveDataTable> createState() => _ArDriveDataTableState<T>();
}

enum TableSort { asc, desc }

abstract class IndexedItem with EquatableMixin {
  IndexedItem(this.index);

  final int index;
}

class _ArDriveDataTableState<T extends IndexedItem>
    extends State<ArDriveDataTable<T>> {
  late List<T> _rows;
  late List<T> _currentPage;
  final List<T> _selectedRows = [];

  final ScrollController _scrollController = ScrollController();

  late int _numberOfPages;
  late int _selectedPage;
  late int _pageItemsDivisorFactor;
  late int _numberOfItemsPerPage;
  int? _sortedColumn;
  bool _isMultiSelectingWithLongPress = false;
  bool _isAllSelected = false;

  TableSort? _tableSort;

  bool _isCtrlPressed = false;
  int? _shiftSelectionStartIndex;
  int? lastSelectedIndex;

  bool get _isMultiSelecting {
    final isMultiSelecting = _isMultiSelectingWithLongPress ||
        _selectedRows.isNotEmpty ||
        _isCtrlPressed;

    return isMultiSelecting;
  }

  @override
  void initState() {
    super.initState();
    _rows = widget.rows;
    _pageItemsDivisorFactor = widget.pageItemsDivisorFactor;
    _numberOfItemsPerPage = _pageItemsDivisorFactor;
    _numberOfPages = _rows.length ~/ _pageItemsDivisorFactor;
    if (_rows.length % _pageItemsDivisorFactor != 0) {
      _numberOfPages++;
    }
    selectPage(0);
    RawKeyboard.instance.addListener(_handleKeyDownEvent);
    RawKeyboard.instance.addListener(_handleEscapeKey);
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      if (_selectedRows.isEmpty) {
        widget.onChangeMultiSelecting!(false);
      }
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    _rows = widget.rows;

    selectPage(_selectedPage);
  }

  void _handleEscapeKey(RawKeyEvent event) {
    if (mounted) {
      if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
        setState(() {
          _isMultiSelectingWithLongPress = false;
          _selectedRows.clear();
          _isCtrlPressed = false;
          _shiftSelectionStartIndex = null;
        });

        if (widget.onChangeMultiSelecting != null) {
          widget.onChangeMultiSelecting!(false);
        }
      }
    }
  }

  void _handleKeyDownEvent(RawKeyEvent event) {
    if (mounted) {
      setState(() {
        if (event.isKeyPressed(LogicalKeyboardKey.metaLeft) ||
            event.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
          _isCtrlPressed = true;
        } else {
          _isCtrlPressed = false;
        }

        if (widget.onChangeMultiSelecting != null) {
          widget.onChangeMultiSelecting!(_isMultiSelecting);
        }
      });
    }
  }

  void _selectItem(T item, int index, bool select) {
    setState(() {
      if (_isCtrlPressed) {
        if (_selectedRows.contains(item)) {
          _selectedRows.remove(item);
        } else {
          _selectedRows.add(item);
        }
      } else if (RawKeyboard.instance.keysPressed
          .contains(LogicalKeyboardKey.shiftLeft)) {
        if (_shiftSelectionStartIndex != null) {
          final startIndex = _shiftSelectionStartIndex!;
          final endIndex = index;
          final start = startIndex < endIndex ? startIndex : endIndex;
          final end = startIndex > endIndex ? startIndex : endIndex;
          _selectedRows.clear();

          for (int i = start; i <= end; i++) {
            _selectedRows.add(_currentPage[i]);
          }
        } else {
          _shiftSelectionStartIndex = index;
          _selectedRows.clear();
          _selectedRows.add(item);
        }
      } else {
        _shiftSelectionStartIndex = null;
        _selectedRows.clear();
        if (select) {
          _selectedRows.add(item);
        } else {
          debugPrint(
              'removing item: $item from _selectedRows ${_selectedRows.length}}');
          _selectedRows.remove(item);
        }
      }
    });

    widget.onSelectedRows?.call(_selectedRows);
  }

  int _getNumberOfPages() {
    _numberOfPages = _rows.length ~/ _numberOfItemsPerPage;
    if (_rows.length % _numberOfItemsPerPage != 0) {
      _numberOfPages = _numberOfPages + 1;
    }
    return _numberOfPages;
  }

  @override
  Widget build(BuildContext context) {
    final columns = List.generate(
      widget.columns.length,
      (index) {
        return Flexible(
          flex: widget.columns[index].size,
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                final stopwatch = Stopwatch()..start();

                setState(() {
                  if (_sortedColumn == index) {
                    _tableSort = _tableSort == TableSort.asc
                        ? TableSort.desc
                        : TableSort.asc;
                  } else {
                    _sortedColumn = index;
                    _tableSort = TableSort.asc;
                  }
                });

                if (widget.sortRows != null) {
                  _rows = widget.sortRows!(_rows, index, _tableSort!);
                } else if (widget.sort != null) {
                  int sort(a, b) {
                    if (_tableSort == TableSort.asc) {
                      return widget.sort!.call(index)(a, b);
                    } else {
                      return widget.sort!.call(index)(b, a);
                    }
                  }

                  _rows.sort(sort);
                }

                selectPage(_selectedPage);

                stopwatch.stop();

                debugPrint(
                  'TABLE SORT - Elapsed time: ${stopwatch.elapsedMilliseconds}ms',
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      widget.columns[index].title,
                      style: ArDriveTypography.body.buttonNormalBold(),
                    ),
                  ),
                  if (_sortedColumn == index)
                    _tableSort == TableSort.asc
                        ? ArDriveIcons.chevronUp(
                            size: 8,
                            color: ArDriveTheme.of(context)
                                .themeData
                                .colors
                                .themeFgDefault)
                        : ArDriveIcons.chevronDown(
                            size: 8,
                            color: ArDriveTheme.of(context)
                                .themeData
                                .colors
                                .themeFgDefault,
                          ),
                ],
              ),
            ),
          ),
        );
      },
      growable: false,
    );
    EdgeInsets getPadding() {
      double rightPadding = 0;
      double leftPadding = 0;

      if (widget.leading != null) {
        leftPadding = 80;
      } else {
        leftPadding = 20;
      }
      if (widget.trailing != null) {
        rightPadding = 80;
      } else {
        rightPadding = 20;
      }

      return EdgeInsets.only(left: leftPadding, right: rightPadding);
    }

    return ArDriveCard(
      backgroundColor:
          ArDriveTheme.of(context).themeData.tableTheme.backgroundColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      key: widget.key,
      content: Column(
        children: [
          const SizedBox(
            height: 28,
          ),
          Row(
            children: [
              _multiSelectColumn(true),
              Flexible(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: getPadding(),
                  child: Row(
                    children: columns,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _currentPage.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      key: ValueKey(_currentPage[index]),
                      padding: const EdgeInsets.only(top: 5),
                      child: _buildRowSpacing(
                        widget.columns,
                        widget.buildRow(_currentPage[index]).row,
                        _currentPage[index],
                        index,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          _pageIndicator(),
        ],
      ),
    );
  }

  Widget _multiSelectColumn(bool selectAll, {T? row, int? index}) {
    final isSelected =
        _selectedRows.any((element) => element.index == row?.index);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isMultiSelecting ? checkboxSize + 8 : 0,
      child: ArDriveCheckBox(
        key: ValueKey(isSelected),
        checked: _isAllSelected || isSelected,
        onChange: (value) {
          _onChangeItemCheck(
            selectAll: selectAll,
            row: row,
            index: index,
            value: value,
          );
        },
      ),
    );
  }

  void _onChangeItemCheck({
    required bool selectAll,
    T? row,
    int? index,
    required bool value,
  }) {
    setState(() {
      if (selectAll) {
        _isAllSelected = value;
        if (value) {
          _selectedRows.clear();
          _selectedRows.addAll(_rows);
        } else {
          _selectedRows.clear();
        }

        widget.onSelectedRows?.call(_selectedRows);

        if (widget.onChangeMultiSelecting != null) {
          widget.onChangeMultiSelecting!(_isMultiSelecting);
        }

        return;
      }

      if (row != null && index != null) {
        _selectItem(row, index, value);
        lastSelectedIndex = index;
      }

      if (_isMultiSelectingWithLongPress && !value && _selectedRows.isEmpty) {
        _isMultiSelectingWithLongPress = false;

        if (widget.onChangeMultiSelecting != null) {
          widget.onChangeMultiSelecting!(_isMultiSelecting);
        }

        return;
      }
    });
  }

  Widget _pageIndicator() {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.rowsPerPageText,
                  style: ArDriveTypography.body.buttonNormalBold(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 42),
                  child: PaginationSelect(
                    currentNumber: _numberOfItemsPerPage,
                    divisorFactor: _pageItemsDivisorFactor,
                    maxOption: widget.maxItemsPerPage,
                    maxNumber: widget.rows.length,
                    onSelect: (n) {
                      setState(() {
                        int newPage =
                            ((_selectedPage) * _numberOfItemsPerPage) ~/ n;

                        _numberOfItemsPerPage = n;

                        selectPage(newPage);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ArDriveClickArea(
                  showCursor: _selectedPage > 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_selectedPage > 0) {
                        goToPreviousPage();
                      }
                    },
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: Center(
                        child: ArDriveIcons.chevronLeft(
                          size: 18,
                          color: _selectedPage > 0
                              ? ArDriveTheme.of(context)
                                  .themeData
                                  .colors
                                  .themeFgDefault
                              : grey,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_getPagesToShow().first > 1) ...[
                  _pageNumber(0),
                  if (_getPagesToShow().first > 2)
                    Row(
                      children: [
                        ArDriveIcons.dots(
                          size: 24,
                          color: ArDriveTheme.of(context)
                              .themeData
                              .colors
                              .themeFgDefault,
                        ),
                      ],
                    ),
                ],
                ..._getPagesIndicators(),
                if (_getPagesToShow().last < _getNumberOfPages() &&
                    _getPagesToShow().last < _getNumberOfPages() - 1)
                  GestureDetector(
                    onTap: () {
                      goToLastPage();
                    },
                    child: Row(
                      children: [
                        ArDriveIcons.dots(
                          size: 24,
                          color: ArDriveTheme.of(context)
                              .themeData
                              .colors
                              .themeFgDefault,
                        ),
                        _pageNumber(_getNumberOfPages() - 1),
                      ],
                    ),
                  ),
                ArDriveClickArea(
                  showCursor: _selectedPage + 1 < _getNumberOfPages(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_selectedPage + 1 < _getNumberOfPages()) {
                        goToNextPage();
                      }
                    },
                    child: SizedBox(
                      height: 32,
                      width: 32,
                      child: Center(
                        child: ArDriveIcons.chevronRight(
                          color: _selectedPage + 1 < _getNumberOfPages()
                              ? ArDriveTheme.of(context)
                                  .themeData
                                  .colors
                                  .themeFgDefault
                              : grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<int> _getPagesToShow() {
    late int visiblePages;
    final int numberOfPages = _getNumberOfPages();

    if (numberOfPages < 5) {
      visiblePages = numberOfPages;
    } else {
      visiblePages = 5;
    }

    final int half = visiblePages ~/ 2;
    final int start = _selectedPage + 1 - half;
    final int end = _selectedPage + 1 + half;

    if (start <= 0) {
      return List.generate(
        visiblePages,
        (index) => index + 1,
        growable: false,
      );
    }

    if (end >= numberOfPages) {
      return List.generate(
        visiblePages,
        (index) => numberOfPages - visiblePages + index + 1,
        growable: false,
      );
    }

    return List.generate(
      visiblePages,
      (index) => start + index,
      growable: false,
    );
  }

  /// The pages are counted starting from 0, so, to show correctly add + 1
  ///
  List<Widget> _getPagesIndicators() {
    return _getPagesToShow().map((page) {
      return _pageNumber(page - 1);
    }).toList();
  }

  Widget _pageNumber(int page) {
    return _PageNumber(
      page: page,
      isSelected: _selectedPage == page,
      onPressed: () {
        selectPage(page);
      },
    );
  }

  Widget _buildRowSpacing(
    List<TableColumn> columns,
    List<Widget> buildRow,
    T row,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        if (_isMultiSelecting) {
          _onChangeItemCheck(
            selectAll: false,
            value: !_selectedRows.any((r) => r.index == row.index),
            row: row,
            index: row.index,
          );
        } else {
          widget.onRowTap?.call(row);
        }
      },
      onLongPress: () {
        setState(() {
          _isMultiSelectingWithLongPress = !_isMultiSelectingWithLongPress;
        });

        if (widget.onChangeMultiSelecting != null) {
          widget.onChangeMultiSelecting!(_isMultiSelecting);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          _multiSelectColumn(false, index: index, row: row),
          Flexible(
            child: ArDriveCard(
              backgroundColor: _selectedRows.contains(row)
                  ? ArDriveTheme.of(context)
                      .themeData
                      .tableTheme
                      .selectedItemColor
                  : ArDriveTheme.of(context)
                      .themeData
                      .colors
                      .themeBorderDefault
                      .withOpacity(0.25),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              content: Row(
                children: [
                  if (widget.leading != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 40,
                          maxHeight: 40,
                        ),
                        child: widget.leading!.call(row),
                      ),
                    ),
                  ...List.generate(
                    columns.length,
                    (index) {
                      return Flexible(
                        flex: columns[index].size,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: buildRow[index],
                        ),
                      );
                    },
                    growable: false,
                  ),
                  if (widget.trailing != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 40,
                        child: widget.trailing!.call(row),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selectPage(int page) {
    setState(() {
      _selectedPage = page;
      int maxIndex = _rows.length < (page + 1) * _numberOfItemsPerPage
          ? _rows.length
          : (page + 1) * _numberOfItemsPerPage;

      int minIndex = (_selectedPage * _numberOfItemsPerPage);

      _currentPage = _rows.sublist(minIndex, maxIndex);
    });
  }

  void goToNextPage() {
    selectPage(_selectedPage + 1);
  }

  void goToLastPage() {
    selectPage(_numberOfPages - 1);
  }

  void goToFirstPage() {
    selectPage(0);
  }

  void goToPreviousPage() {
    selectPage(_selectedPage - 1);
  }
}

class PaginationSelect extends StatefulWidget {
  const PaginationSelect({
    super.key,
    required this.maxOption,
    required this.divisorFactor,
    required this.onSelect,
    required this.maxNumber,
    this.currentNumber,
  });

  final int maxOption;
  final int maxNumber;
  final int divisorFactor;
  final Function(int) onSelect;
  final int? currentNumber;

  @override
  State<PaginationSelect> createState() => _PaginationSelectState();
}

class _PaginationSelectState extends State<PaginationSelect> {
  late int currentNumber;

  @override
  void initState() {
    super.initState();
    if (widget.currentNumber != null) {
      currentNumber = widget.currentNumber!;
    } else {
      if (widget.maxNumber < widget.divisorFactor) {
        currentNumber = widget.maxNumber;
      } else {
        currentNumber = widget.divisorFactor;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ArDriveDropdown(
      width: 100,
      anchor: const Aligned(
        follower: Alignment.bottomLeft,
        target: Alignment.bottomRight,
      ),
      items: [
        for (int i = widget.divisorFactor;
            i <= widget.maxOption && i <= widget.maxNumber;
            i += widget.divisorFactor)
          ArDriveDropdownItem(
            onClick: () {
              setState(() {
                currentNumber = i;
              });
              widget.onSelect(currentNumber);
            },
            content: Text(
              i.toString(),
              style: ArDriveTypography.body.buttonLargeBold(),
            ),
          ),
      ],
      child: ArDriveClickArea(
        child: _PageNumber(
          page: currentNumber - 1,
          isSelected: false,
        ),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({
    this.onPressed,
    required this.page,
    required this.isSelected,
  });

  final int page;
  final bool isSelected;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ArDriveClickArea(
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: isSelected
                        ? ArDriveTheme.of(context)
                            .themeData
                            .colors
                            .themeFgDefault
                        : ArDriveTheme.of(context)
                            .themeData
                            .colors
                            .themeGbMuted,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected
                      ? ArDriveTheme.of(context).themeData.colors.themeFgDefault
                      : null,
                ),
                child: Text(
                  _showSemanticPageNumber(page),
                  style: ArDriveTypography.body.buttonNormalBold(
                    color: isSelected
                        ? ArDriveTheme.of(context)
                            .themeData
                            .tableTheme
                            .backgroundColor
                        : ArDriveTheme.of(context)
                            .themeData
                            .colors
                            .themeFgDefault,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _showSemanticPageNumber(int page) {
  return (page + 1).toString();
}
