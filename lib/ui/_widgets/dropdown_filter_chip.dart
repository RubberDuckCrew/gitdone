import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

/// A model class representing a filter chip item with a label and value.
class FilterChipItem {
  /// Creates a new instance of [FilterChipItem].
  FilterChipItem({required this.label, required this.value});

  /// The label of the filter chip item.
  final String label;

  /// The value of the filter chip item.
  final String value;
}

/// A custom dropdown filter chip widget that allows users to select a filter
///
/// See https://github.com/flutter/flutter/issues/108683 for more details.
class FilterChipDropdown extends StatefulWidget {
  /// Creates a new instance of [FilterChipDropdown].
  const FilterChipDropdown({
    required this.items,
    required this.initialLabel,
    required this.allowMultipleSelection,
    required this.onUpdate,
    final List<String>? defaultSelectedValues,
    super.key,
    this.leading,
    this.labelPadding = 16,
  }) : _defaultSelectedValues = defaultSelectedValues ?? const [];

  /// The list of filter chip items to display in the dropdown.
  final List<FilterChipItem> items;

  /// The leading widget to display in the filter chip.
  final Widget? leading;

  /// The initial label to display in the filter chip when no items are selected.
  final String initialLabel;

  /// The padding around the label in the filter chip.
  final double labelPadding;

  /// Whether multiple items can be selected in the dropdown.
  final bool allowMultipleSelection;

  /// Callback function to be called when an item is updated.
  final void Function(FilterChipItem, {required bool selected}) onUpdate;

  /// The default selected values for the filter chip dropdown (applied only at init).
  final List<String> _defaultSelectedValues;

  @override
  State<FilterChipDropdown> createState() => _FilterChipDropdownState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<FilterChipItem>("items", items))
      ..add(StringProperty("initialLabel", initialLabel))
      ..add(DoubleProperty("labelPadding", labelPadding))
      ..add(
        DiagnosticsProperty<bool>(
          "allowMultipleSelection",
          allowMultipleSelection,
        ),
      )
      ..add(
        ObjectFlagProperty<
          void Function(FilterChipItem p1, {required bool selected})
        >.has("onUpdate", onUpdate),
      )
      ..add(
        IterableProperty<String>(
          "defaultSelectedValues",
          _defaultSelectedValues,
        ),
      );
  }
}

class _FilterChipDropdownState extends State<FilterChipDropdown> {
  final GlobalKey _chipKey = GlobalKey();
  final OverlayPortalController _portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  late _FilterChipDropdownViewModel _viewModel;

  double _actualDropdownWidth = 0;
  double _offsetX = 0;

  void _handleDropdownToggle() {
    if (_viewModel.isDropdownOpen && !_portalController.isShowing) {
      final RenderBox? renderBox =
          _chipKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final Offset chipPosition = renderBox.localToGlobal(Offset.zero);
        final double screenWidth = MediaQuery.of(context).size.width;
        final double dropdownWidth =
            _viewModel.maxItemWidth + _viewModel.iconWidth;
        final double maxDropdownWidth = screenWidth * 0.9;

        final double actualDropdownWidth = dropdownWidth > maxDropdownWidth
            ? maxDropdownWidth
            : dropdownWidth;

        final double dx = _getChipOffset(
          chipPosition,
          screenWidth,
          actualDropdownWidth,
        );

        _actualDropdownWidth = actualDropdownWidth;
        _offsetX = dx;
      }
      _portalController.show();
    } else if (!_viewModel.isDropdownOpen && _portalController.isShowing) {
      _portalController.hide();
      _actualDropdownWidth = 0;
      _offsetX = 0;
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_handleDropdownToggle);
    super.dispose();
  }

  /// Initializes the state of the widget and sets up the default selected values.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget._defaultSelectedValues.isNotEmpty) {
        _viewModel._selectedLabels = widget._defaultSelectedValues.toSet();
        for (final String value in widget._defaultSelectedValues) {
          final FilterChipItem item = widget.items.firstWhere(
            (final item) => item.label == value,
            orElse: () => widget.items.first,
          );
          widget.onUpdate(item, selected: true);
        }
      }
    });
  }

  /// Calculate the offset to ensure the dropdown does not overflow
  double _getChipOffset(
    final Offset chipPosition,
    final double screenWidth,
    final double actualDropdownWidth,
  ) {
    double dx = 0;

    final double leftEdge = chipPosition.dx;
    final double rightEdge = chipPosition.dx + actualDropdownWidth;
    if (rightEdge > screenWidth) {
      dx = screenWidth - rightEdge;
    }
    if (leftEdge + dx < 0) {
      dx += -(leftEdge + dx);
    }

    return dx;
  }

  @override
  Widget build(
    final BuildContext context,
  ) => ChangeNotifierProvider<_FilterChipDropdownViewModel>(
    create: (_) {
      final _FilterChipDropdownViewModel viewModel =
          _FilterChipDropdownViewModel(
            allowMultipleSelection: widget.allowMultipleSelection,
          );
      _viewModel = viewModel;
      _viewModel.addListener(_handleDropdownToggle);
      return viewModel;
    },
    child: Consumer<_FilterChipDropdownViewModel>(
      builder: (final context, final viewModel, final child) {
        viewModel
          ..calculateMaxItemWidth(
            widget.items.map((final item) => item.label).toList(),
            widget.labelPadding,
            context,
          )
          ..calculateIconWidth(context);

        return CompositedTransformTarget(
          link: _layerLink,
          child: OverlayPortal(
            controller: _portalController,
            overlayChildBuilder: (final context) {
              final RenderObject? renderBox = _chipKey.currentContext
                  ?.findRenderObject();
              if (renderBox is! RenderBox || !renderBox.hasSize) {
                return const SizedBox.shrink();
              }

              final Size chipBox = renderBox.size;

              return Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (viewModel.isDropdownOpen) {
                          viewModel.toggleDropdown();
                        }
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: Offset(_offsetX, chipBox.height),
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 4,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: _actualDropdownWidth,
                          maxWidth: _actualDropdownWidth,
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: widget.items
                              .map(
                                (final item) => Material(
                                  color: viewModel.isItemSelected(item)
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      widget.onUpdate(
                                        item,
                                        selected: !viewModel.isItemSelected(
                                          item,
                                        ),
                                      );

                                      if (viewModel.isItemSelected(item) &&
                                          widget.allowMultipleSelection) {
                                        viewModel.unselectItem(item);
                                      } else {
                                        viewModel.selectItem(item);
                                      }
                                    },
                                    child: SizedBox(
                                      width: _actualDropdownWidth,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: widget.labelPadding,
                                        ),
                                        child: widget.allowMultipleSelection
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (viewModel.isItemSelected(
                                                    item,
                                                  ))
                                                    const Icon(Icons.check_box)
                                                  else
                                                    const Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                    ),
                                                  Expanded(
                                                    child: Text(
                                                      item.label,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                item.label,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            child: TapRegion(
              child: FilterChip.elevated(
                key: _chipKey,
                avatar: widget.leading,
                label: Text(viewModel.getLabel(widget.initialLabel)),
                iconTheme: IconThemeData(
                  color: viewModel.isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                labelStyle: TextStyle(
                  color: viewModel.isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                backgroundColor: viewModel.isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainer,
                deleteIcon: viewModel.isSelected
                    ? Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                onDeleted: viewModel.isSelected
                    ? () {
                        viewModel.clearSelection();
                        widget.onUpdate(
                          FilterChipItem(label: widget.initialLabel, value: ""),
                          selected: false,
                        );
                      }
                    : viewModel.toggleDropdown,
                onSelected: (_) => viewModel.toggleDropdown(),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _FilterChipDropdownViewModel extends ChangeNotifier {
  _FilterChipDropdownViewModel({required this.allowMultipleSelection});

  Set<String> _selectedLabels = {};
  bool _isDropdownOpen = false;
  double _maxItemWidth = 0;
  double _iconWidth = 0;
  final bool allowMultipleSelection;

  Set<String> get selectedLabels => _selectedLabels;

  bool get isDropdownOpen => _isDropdownOpen;

  bool get isSelected => _selectedLabels.isNotEmpty;

  double get maxItemWidth => _maxItemWidth;

  double get iconWidth => _iconWidth;

  int get amountOfSelectedItems => _selectedLabels.length;

  void toggleDropdown() {
    _isDropdownOpen = !_isDropdownOpen;
    notifyListeners();
  }

  void toggleItemSelected() {
    notifyListeners();
  }

  void selectItem(final FilterChipItem item) {
    if (allowMultipleSelection) {
      _selectedLabels.add(item.label);
    } else {
      _selectedLabels = {item.label};
      _isDropdownOpen = false;
    }
    notifyListeners();
  }

  void unselectItem(final FilterChipItem item) {
    _selectedLabels.remove(item.label);
    notifyListeners();
  }

  void clearSelection() {
    _selectedLabels = {};
    _isDropdownOpen = false;
    notifyListeners();
  }

  /// Needs to have parameter `PointerDownEvent` to be compatible with the TapRegion widget
  void handleOutsideTap(final PointerDownEvent evt) {
    if (_isDropdownOpen) {
      _isDropdownOpen = false;
      notifyListeners();
    }
  }

  bool isItemSelected(final FilterChipItem item) =>
      _selectedLabels.contains(item.label);

  void calculateMaxItemWidth(
    final List<String> labels,
    final double labelPadding,
    final BuildContext context,
  ) {
    double maxWidth = 0;
    for (final String label in labels) {
      final textPainter = TextPainter(
        text: TextSpan(text: label, style: DefaultTextStyle.of(context).style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: double.infinity);
      final double localMaxWidth = textPainter.width + 2 * labelPadding + 5;
      maxWidth = maxWidth < localMaxWidth ? localMaxWidth : maxWidth;
    }

    _maxItemWidth = maxWidth;
  }

  void calculateIconWidth(final BuildContext context) {
    final double iconWidth = IconTheme.of(context).size ?? 24.0;
    _iconWidth = iconWidth;
  }

  /// Returns `initialLabel` if no items are selected, otherwise
  ///
  /// returns ```${_selectedLabels.length} initialLabel``` if multiple items are selected and allowMultipleSelection is true,
  /// or ```_selectedLabels.first``` if allowMultipleSelection is false.
  String getLabel(final String initialLabel) {
    if (allowMultipleSelection && _selectedLabels.isNotEmpty) {
      return "${_selectedLabels.length} $initialLabel";
    }
    if (!allowMultipleSelection && _selectedLabels.isNotEmpty) {
      return _selectedLabels.first;
    }
    return initialLabel;
  }
}
