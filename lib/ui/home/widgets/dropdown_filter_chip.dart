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
    super.key,
    this.leading,
    this.labelPadding = 16,
  });

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
  final void Function(FilterChipItem) onUpdate;

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
        ObjectFlagProperty<void Function(FilterChipItem p1)>.has(
          "onUpdate",
          onUpdate,
        ),
      );
  }
}

class _FilterChipDropdownState extends State<FilterChipDropdown> {
  final GlobalKey _chipKey = GlobalKey();

  @override
  Widget build(
    final BuildContext context,
  ) => ChangeNotifierProvider<_FilterChipDropdownViewModel>(
    create:
        (_) => _FilterChipDropdownViewModel(
          allowMultipleSelection: widget.allowMultipleSelection,
        ),
    child: Consumer<_FilterChipDropdownViewModel>(
      builder: (final context, final viewModel, final child) {
        viewModel
          ..calculateMaxItemWidth(
            widget.items.map((final item) => item.label).toList(),
            widget.labelPadding,
            context,
          )
          ..calculateIconWidth(context);
        return TapRegion(
          onTapOutside: viewModel.handleOutsideTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterChip.elevated(
                key: _chipKey,
                avatar: widget.leading,
                label: Text(viewModel.getLabel(widget.initialLabel)),
                iconTheme: IconThemeData(
                  color:
                      viewModel.isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                ),
                labelStyle: TextStyle(
                  color:
                      viewModel.isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                ),
                backgroundColor:
                    viewModel.isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainer,
                deleteIcon:
                    viewModel.isSelected
                        ? Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                        : Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                onDeleted:
                    viewModel.isSelected
                        ? viewModel.clearSelection
                        : viewModel.toggleDropdown,
                onSelected: (_) => viewModel.toggleDropdown(),
              ),
              if (viewModel.isDropdownOpen)
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  child: LayoutBuilder(
                    builder:
                        (final context, final constraints) => ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth:
                                viewModel.maxItemWidth + viewModel.iconWidth,
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                widget.items
                                    .map(
                                      (final item) => Material(
                                        color:
                                            viewModel.isItemSelected(item)
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                                : Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            widget.onUpdate(item);

                                            if (viewModel.isItemSelected(
                                                  item,
                                                ) &&
                                                widget.allowMultipleSelection) {
                                              viewModel.unselectItem(item);
                                            } else {
                                              viewModel.selectItem(item);
                                            }
                                          },
                                          child: SizedBox(
                                            child: Container(
                                              width:
                                                  widget.allowMultipleSelection
                                                      ? viewModel.maxItemWidth +
                                                          viewModel.iconWidth
                                                      : viewModel.maxItemWidth,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: widget.labelPadding,
                                              ),
                                              child:
                                                  widget.allowMultipleSelection
                                                      ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          if (viewModel
                                                              .isItemSelected(
                                                                item,
                                                              ))
                                                            const Icon(
                                                              Icons.check_box,
                                                            )
                                                          else
                                                            const Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                            ),
                                                          Text(item.label),
                                                        ],
                                                      )
                                                      : Text(item.label),
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

  /// Needs to have parameter `bool?` to be compatible with the FilterChip widget
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
      maxWidth =
          maxWidth < textPainter.width
              ? textPainter.width +
                  2 * labelPadding +
                  5 // TODO(everyone): Magic number because TextPainter is not accurate. See https://github.com/flutter/flutter/issues/142028
              : maxWidth;
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
