import "package:flutter/material.dart";
import "package:gitdone/core/utils/navigation.dart";
import "package:gitdone/ui/settings/widgets/import_export_settings_view_model.dart";

/// A widget that provides buttons to import and export application settings.
class ImportExportSettings extends StatelessWidget {
  /// Creates an instance of [ImportExportSettings].
  const ImportExportSettings({super.key});

  @override
  Widget build(final BuildContext context) {
    final viewModel = ImportExportSettingsViewModel();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImport(context, viewModel),
        const SizedBox(width: 16),
        _buildExport(context, viewModel),
      ],
    );
  }

  Widget _buildImport(
    final BuildContext context,
    final ImportExportSettingsViewModel viewModel,
  ) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
    icon: const Icon(Icons.input),
    label: const Text("Import Settings"),
    onPressed: () async {
      final controller = TextEditingController();
      final String? result = await showDialog<String>(
        context: context,
        builder: (final context) => _buildImportDialog(controller),
      );
      if (!context.mounted) return;
      if (result != null) {
        await viewModel.importSettingsFromJson(context, result);
      }
    },
  );

  Widget _buildImportDialog(final TextEditingController controller) =>
      LayoutBuilder(
        builder: (final context, final constraints) => AlertDialog(
          title: const Text("Import Settings (JSON)"),
          content: TextField(
            controller: controller,
            maxLines: 8,
            minLines: 8,
            decoration: const InputDecoration(
              hintText: "Paste your settings JSON here",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            const TextButton(
              onPressed: Navigation.navigateBack,
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigation.navigateBack(controller.text),
              child: const Text("Import"),
            ),
          ],
        ),
      );

  Widget _buildExport(
    final BuildContext context,
    final ImportExportSettingsViewModel viewModel,
  ) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
    icon: const Icon(Icons.publish),
    label: const Text("Export Settings"),
    onPressed: () async {
      if (!context.mounted) return;
      await viewModel.exportSettingsToClipboard(context);
    },
  );
}
