import "package:flutter/cupertino.dart";
import "package:gitdone/core/models/todo.dart";
import "package:gitdone/core/utils/logger.dart";

/// A view model for editing a to do item.
class TodoEditViewModel extends ChangeNotifier {
  /// Creates a [TodoEditViewModel] with the given to do item.
  TodoEditViewModel(this._originalTodo) : newTodo = _originalTodo.copy();

  static const _classId =
      "com.GitDone.gitdone.ui.todo_edit.todo_edit_view_model";

  final Todo _originalTodo;

  /// The updated to do item that is being edited.
  final Todo newTodo;

  /// Flag to indicate if the to do item is being edited.
  late bool isEditing = false;

  /// Starts editing the to do item.
  void edit() {
    Logger.log("Edit todo", _classId, LogLevel.detailed);
    isEditing = true;
    notifyListeners();
  }

  /// Cancels the editing of the to do item.
  void cancel() {
    Logger.log("Cancel editing todo", _classId, LogLevel.detailed);
    isEditing = false;
    notifyListeners();
  }

  /// Saves the changes made to the to do item.
  void save() {
    Logger.log("Saving todo: $newTodo", _classId, LogLevel.detailed);
    newTodo.updateRemote();
    _originalTodo.replace(newTodo);
    isEditing = false;
    notifyListeners();
  }

  /// Update the title of the to do item.
  void updateTitle(final String title) {
    newTodo.title = title;
    Logger.log("Updated title: $title", _classId, LogLevel.detailed);
    notifyListeners();
  }

  /// Update the description of the to do item.
  void updateDescription(final String description) {
    newTodo.description = description;
    Logger.log(
      "Updated description: $description",
      _classId,
      LogLevel.detailed,
    );
    notifyListeners();
  }
}
