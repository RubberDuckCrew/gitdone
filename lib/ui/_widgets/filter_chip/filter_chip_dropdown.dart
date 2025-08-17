import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/ui/_widgets/filter_chip/filter_chip_dropdown_view_model.dart";
import "package:gitdone/ui/_widgets/filter_chip/filter_chip_item.dart";
import "package:provider/provider.dart";

/// A dropdown widget that displays a list of filter chips for selection.
class FilterChipDropdown<T> extends StatefulWidget {
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

  /// The list of items to display in the dropdown.
  final List<FilterChipItem<T>> items;

  /// The leading widget to display in the chip.
  final Widget? leading;

  /// The initial label to display in the chip.
  final String initialLabel;

  /// The padding around the label in the chip.
  final double labelPadding;

  /// Whether multiple selection is allowed in the dropdown.
  final bool allowMultipleSelection;

  /// Callback function to handle updates when an item is selected or deselected.
  final void Function(FilterChipItem<T>, {required bool selected}) onUpdate;

  @override
  State<FilterChipDropdown<T>> createState() => _FilterChipDropdownState<T>();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<FilterChipItem<T>>("items", items))
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
          void Function(FilterChipItem<T> p1, {required bool selected})
        >.has("onUpdate", onUpdate),
      );
  }
}

class _FilterChipDropdownState<T> extends State<FilterChipDropdown<T>> {
  final GlobalKey _chipKey = GlobalKey();
  final OverlayPortalController _portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  late FilterChipDropdownViewModel<T> _viewModel;
  double _actualDropdownWidth = 0;
  double _offsetX = 0;

  @override
  void didUpdateWidget(covariant final FilterChipDropdown<T> oldWidget) {
    if (oldWidget.items != widget.items) {
      _viewModel.items = widget.items;
    }
    super.didUpdateWidget(oldWidget);
  }

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
  ) => ChangeNotifierProvider<FilterChipDropdownViewModel<T>>(
    create: (_) {
      final FilterChipDropdownViewModel<T> viewModel =
          FilterChipDropdownViewModel<T>(
            allowMultipleSelection: widget.allowMultipleSelection,
            items: widget.items,
          );
      _viewModel = viewModel;
      _viewModel.addListener(_handleDropdownToggle);
      return viewModel;
    },
    child: Consumer<FilterChipDropdownViewModel<T>>(
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
                          FilterChipItem<T>(
                            label: widget.initialLabel,
                            value: "" as T,
                          ),
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
