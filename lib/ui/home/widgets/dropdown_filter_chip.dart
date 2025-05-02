import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterChipItem {
  final String label;
  final String value;

  FilterChipItem({
    required this.label,
    required this.value,
  });
}

/// A custom dropdown filter chip widget that allows users to select a filter
///
/// See https://github.com/flutter/flutter/issues/108683 for more details.
class FilterChipDropdown extends StatefulWidget {
  final List<FilterChipItem> items;
  final Widget? leading;
  final String initialLabel;
  final double labelPadding;
  final bool allowMultipleSelection;

  const FilterChipDropdown({
    super.key,
    required this.items,
    this.leading,
    required this.initialLabel,
    required this.allowMultipleSelection,
    this.labelPadding = 16,
  });

  @override
  State<FilterChipDropdown> createState() => _FilterChipDropdownState();
}

class _FilterChipDropdownState extends State<FilterChipDropdown> {
  final GlobalKey _chipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_FilterChipDropdownViewModel>(
        create: (_) => _FilterChipDropdownViewModel(
            allowMultipleSelection: widget.allowMultipleSelection),
        child: Consumer<_FilterChipDropdownViewModel>(
            builder: (context, viewModel, child) {
          viewModel.calculateMaxItemWidth(
            widget.items.map((item) => item.label).toList(),
            widget.labelPadding,
            context,
          );
          viewModel.calculateIconWidth(context);
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
                      color: viewModel.isSelected
                          ? Theme.of(context).colorScheme.primary
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
                        ? Icon(Icons.close,
                            color: Theme.of(context).colorScheme.onPrimary)
                        : Icon(Icons.arrow_drop_down,
                            color: Theme.of(context).colorScheme.onSurface),
                    onDeleted: viewModel.isSelected
                        ? viewModel.clearSelection
                        : () => viewModel.toggleDropdown(false),
                    onSelected: viewModel.toggleDropdown),
                if (viewModel.isDropdownOpen)
                  Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(4),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth:
                                viewModel.maxItemWidth + viewModel.iconWidth,
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.items.map((item) {
                              return Material(
                                color: viewModel.isItemSelected(item)
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                child: InkWell(
                                  onTap: () => viewModel.isItemSelected(item) &&
                                          widget.allowMultipleSelection
                                      ? viewModel.unselectItem(item)
                                      : viewModel.selectItem(item),
                                  child: SizedBox(
                                    child: Container(
                                        width: widget.allowMultipleSelection
                                            ? viewModel.maxItemWidth +
                                                viewModel.iconWidth
                                            : viewModel.maxItemWidth,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: widget.labelPadding),
                                        child: widget.allowMultipleSelection
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  viewModel.isItemSelected(item)
                                                      ? Icon(Icons.check_box)
                                                      : Icon(
                                                          Icons
                                                              .check_box_outline_blank,
                                                        ),
                                                  Text(item.label),
                                                ],
                                              )
                                            : Text(item.label)),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        }));
  }
}

class _FilterChipDropdownViewModel extends ChangeNotifier {
  Set<String> _selectedLabels = {};
  bool _isDropdownOpen = false;
  double _maxItemWidth = 0;
  double _iconWidth = 0;
  final bool allowMultipleSelection;

  _FilterChipDropdownViewModel({required this.allowMultipleSelection});

  Set<String> get selectedLabels => _selectedLabels;
  bool get isDropdownOpen => _isDropdownOpen;
  bool get isSelected => _selectedLabels.isNotEmpty;
  double get maxItemWidth => _maxItemWidth;
  double get iconWidth => _iconWidth;
  int get amountOfSelectedItems => _selectedLabels.length;

  /// Needs to have parameter `bool?` to be compatible with the FilterChip widget
  void toggleDropdown(bool? value) {
    _isDropdownOpen = !_isDropdownOpen;
    notifyListeners();
  }

  void toggleItemSelected(bool? value) {
    notifyListeners();
  }

  void selectItem(FilterChipItem item) {
    if (allowMultipleSelection) {
      _selectedLabels.add(item.label);
    } else {
      _selectedLabels = {item.label};
      _isDropdownOpen = false;
    }
    notifyListeners();
  }

  void unselectItem(FilterChipItem item) {
    _selectedLabels.remove(item.label);
    notifyListeners();
  }

  void clearSelection() {
    _selectedLabels = {};
    _isDropdownOpen = false;
    notifyListeners();
  }

  /// Needs to have parameter `PointerDownEvent` to be compatible with the TapRegion widget
  void handleOutsideTap(PointerDownEvent evt) {
    if (_isDropdownOpen) {
      _isDropdownOpen = false;
      notifyListeners();
    }
  }

  bool isItemSelected(FilterChipItem item) {
    return _selectedLabels.contains(item.label);
  }

  void calculateMaxItemWidth(
      List<String> labels, double labelPadding, BuildContext context) {
    double maxWidth = 0.0;
    for (var label in labels) {
      final textPainter = TextPainter(
        text: TextSpan(text: label, style: DefaultTextStyle.of(context).style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: double.infinity);
      maxWidth = maxWidth < textPainter.width
          ? textPainter.width +
              2 * labelPadding +
              5 // TODO: Magic number because TextPainter is not accurate. See https://github.com/flutter/flutter/issues/142028
          : maxWidth;
    }

    _maxItemWidth = maxWidth;
  }

  void calculateIconWidth(BuildContext context) {
    final double iconWidth = IconTheme.of(context).size ?? 24.0;
    _iconWidth = iconWidth;
  }

  String getLabel(String initialLabel) {
    if (allowMultipleSelection && _selectedLabels.isNotEmpty) {
      return "${_selectedLabels.length} $initialLabel";
    }
    if (!allowMultipleSelection && _selectedLabels.isNotEmpty) {
      return _selectedLabels.first;
    }
    return initialLabel;
  }
}
