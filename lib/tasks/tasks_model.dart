import 'package:pim/base_model.dart';

class Task {
  int id;
  String description;
  String dueDate;
  String completed = "false";

  /// Just for debugging, so we get something useful in the console.
  String toString() {
    return "{ id=$id, description=$description, dueDate=$dueDate, completed=$completed";
  }
}

/// The model backing this entity type's views.

class TasksModel extends BaseModel {}

// The one and only instance of this model.
TasksModel tasksModel = TasksModel();
