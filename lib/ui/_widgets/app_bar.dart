import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gitdone/core/theme/app_color.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/_widgets/app_title.dart";

/// A normal app bar that is used in most of the views.
class NormalAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a normal app bar with an optional back button.
  const NormalAppBar({
    super.key,
    this.backVisible = true,
    this.menuItems = const [],
  });

  /// Whether the back button should be visible.
  final bool backVisible;

  /// The actions to be displayed in the app bar om PopupMenuButton.
  final List<MenuItemButton> menuItems;

  @override
  Widget build(final BuildContext context) => AppBar(
    /// This fixes the issue of the app bar having a different color when
    /// the app is scrolled.
    scrolledUnderElevation: 0,
    centerTitle: true,
    title: const AppTitleWidget(fontSize: 30),
    backgroundColor: AppColor.colorScheme.surfaceContainer,
    leading: (Navigation.hasBack() && backVisible)
        ? const IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: Navigation.navigateBack,
          )
        : const SizedBox(width: 48),
    actions: [
      if (menuItems.isNotEmpty) _buildMenu() else const SizedBox(width: 48),
    ],
  );

  Widget _buildMenu() => MenuAnchor(
    builder: (final context, final controller, final child) => IconButton(
      onPressed: () {
        if (controller.isOpen) {
          controller.close();
        } else {
          controller.open();
        }
      },
      icon: const Icon(Icons.more_vert),
      tooltip: "Show menu",
    ),
    alignmentOffset: const Offset(0, -4), // First item exactly below app bar
    menuChildren: menuItems,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty("backVisible", backVisible));
  }
}
