import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/filter_chip_item.dart";

/// A ViewModel for managing the state of a filter chip dropdown widget.
class FilterChipDropdownViewModel<T> extends ChangeNotifier {
  /// Creates a new instance of [FilterChipDropdownViewModel].
  FilterChipDropdownViewModel({
    required this.allowMultipleSelection,
    required final List<FilterChipItem<T>> items,
  }) : _items = items;

  final List<FilterChipItem<T>> _items;

  /// The list of items in the filter chip dropdown.
  List<FilterChipItem<T>> get items => _items;

  /// Sets the list of items in the filter chip dropdown.
  set items(final List<FilterChipItem<T>> items) {
    _items
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  bool _isDropdownOpen = false;
  double _maxItemWidth = 0;
  double _iconWidth = 0;

  /// Whether multiple selection is allowed in the filter chip dropdown.
  final bool allowMultipleSelection;

  /// The set of selected labels in the filter chip dropdown.
  Set<T> get selectedLabels => _items
      .where((final item) => item.selected)
      .map((final item) => item.value)
      .toSet();

  /// Whether the dropdown is currently open.
  bool get isDropdownOpen => _isDropdownOpen;

  /// Whether any item in the filter chip dropdown is selected.
  bool get isSelected => _items.any((final item) => item.selected);

  /// The maximum width of the items in the filter chip dropdown.
  double get maxItemWidth => _maxItemWidth;

  /// The width of the icon in the filter chip dropdown.
  double get iconWidth => _iconWidth;

  /// The number of selected items in the filter chip dropdown.
  int get amountOfSelectedItems =>
      _items.where((final item) => item.selected).length;

  /// Toggles the dropdown state of the filter chip dropdown.
  void toggleDropdown() {
    _isDropdownOpen = !_isDropdownOpen;
    notifyListeners();
  }

  /// Selects an item in the filter chip dropdown.
  void selectItem(final FilterChipItem<T> item) {
    if (allowMultipleSelection) {
      item.selected = true;
    } else {
      for (final FilterChipItem<T> i in _items) {
        i.selected = false;
      }
      item.selected = true;
      _isDropdownOpen = false;
    }
    notifyListeners();
  }

  /// Unselects an item in the filter chip dropdown.
  void unselectItem(final FilterChipItem<T> item) {
    item.selected = false;
    notifyListeners();
  }

  /// Clears all selections in the filter chip dropdown.
  void clearSelection() {
    for (final FilterChipItem<T> item in _items) {
      item.selected = false;
    }
    _isDropdownOpen = false;
    notifyListeners();
  }

  /// Returns true if the given item is selected.
  bool isItemSelected(final FilterChipItem<T> item) => item.selected;

  /// Calculates the maximum width of the dropdown items.
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

  /// Calculates the width of the icon in the dropdown.
  void calculateIconWidth(final BuildContext context) {
    _iconWidth = IconTheme.of(context).size ?? 24.0;
  }

  /// Returns the label to display on the chip.
  String getLabel(final String initialLabel) {
    if (amountOfSelectedItems > 0) {
      if (allowMultipleSelection) {
        return "$amountOfSelectedItems $initialLabel";
      } else {
        return _items.firstWhere((final item) => item.selected).label;
      }
    }
    return initialLabel;
  }
}
