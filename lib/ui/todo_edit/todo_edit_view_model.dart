import "package:gitdone/core/models/todo/todo.dart";
import "package:gitdone/core/utils/logger.dart";
import "package:gitdone/core/utils/navigation.dart";

/// A view model for editing a to do item.
class TodoEditViewModel {
  /// Creates a [TodoEditViewModel] with the given to do item.
  TodoEditViewModel(this._originalTodo) : newTodo = _originalTodo.copy();

  static const _classId =
      "com.GitDone.gitdone.ui.todo_edit.todo_edit_view_model";

  final Todo _originalTodo;

  /// The updated to do item that is being edited.
  final Todo newTodo;

  /// Cancels the editing of the to do item.
  void cancel() {
    Logger.log("Cancel editing todo", _classId, LogLevel.detailed);
    Navigation.navigateBack();
  }

  /// Saves the changes made to the to do item.
  Future<void> save() async {
    Logger.log("Saving todo: $newTodo", _classId, LogLevel.detailed);
    _originalTodo.replace(await newTodo.saveRemote());
    Navigation.navigateBack(newTodo);
  }

  /// Update the title of the to do item.
  void updateTitle(final String title) {
    newTodo.title = title;
    Logger.log("Updated title: $title", _classId, LogLevel.detailed);
  }

  /// Update the description of the to do item.
  void updateDescription(final String description) {
    newTodo.description = description;
    Logger.log(
      "Updated description: $description",
      _classId,
      LogLevel.detailed,
    );
  }
}
