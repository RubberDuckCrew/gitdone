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
  final Color unselectedColor;
  final Color unselectedLabelColor;
  final Color selectedColor;
  final Color selectedLabelColor;
  final Function(String?) onSelectionChanged;
  final double labelPadding;

  const FilterChipDropdown({
    super.key,
    required this.items,
    this.leading,
    required this.initialLabel,
    required this.unselectedColor,
    required this.unselectedLabelColor,
    required this.selectedColor,
    required this.selectedLabelColor,
    required this.onSelectionChanged,
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
        create: (_) => _FilterChipDropdownViewModel(),
        child: Consumer<_FilterChipDropdownViewModel>(
            builder: (context, viewModel, child) {
          viewModel.calculateMaxItemWidth(
            widget.items.map((item) => item.label).toList(),
            widget.labelPadding,
            context,
          );
          return TapRegion(
            onTapOutside: viewModel.handleOutsideTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterChip.elevated(
                    key: _chipKey,
                    avatar: widget.leading,
                    label: Text(
                      viewModel.selectedLabel.isNotEmpty
                          ? viewModel.selectedLabel
                          : widget.initialLabel,
                    ),
                    iconTheme: IconThemeData(
                      color: viewModel.isSelected
                          ? widget.selectedLabelColor
                          : widget.unselectedLabelColor,
                    ),
                    labelStyle: TextStyle(
                      color: viewModel.isSelected
                          ? widget.selectedLabelColor
                          : widget.unselectedLabelColor,
                    ),
                    backgroundColor: viewModel.isSelected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                    deleteIcon: viewModel.isSelected
                        ? Icon(Icons.close, color: widget.selectedLabelColor)
                        : Icon(Icons.arrow_drop_down,
                            color: widget.unselectedLabelColor),
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
                            minWidth: viewModel.maxItemWidth,
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.items.map((item) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => viewModel.selectItem(item),
                                  child: Container(
                                    width: viewModel.maxItemWidth,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: widget.labelPadding),
                                    child: Text(item.label),
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
  String _selectedLabel = "";
  bool _isDropdownOpen = false;
  bool _isSelected = false;
  double _maxItemWidth = 0;

  String get selectedLabel => _selectedLabel;
  bool get isDropdownOpen => _isDropdownOpen;
  bool get isSelected => _isSelected;
  double get maxItemWidth => _maxItemWidth;

  /// Needs to have parameter `bool?` to be compatible with the FilterChip widget
  void toggleDropdown(bool? value) {
    _isDropdownOpen = !_isDropdownOpen;
    notifyListeners();
  }

  void selectItem(FilterChipItem item) {
    _selectedLabel = item.label;
    _isSelected = true;
    _isDropdownOpen = false;
    notifyListeners();
  }

  void clearSelection() {
    _selectedLabel = "";
    _isSelected = false;
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
}
