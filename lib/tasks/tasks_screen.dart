import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'tasks_db_worker.dart';
import 'tasks_list_widget.dart';
import 'tasks_entry_widget.dart';
import 'tasks_model.dart' show TasksModel, tasksModel;

/// The Tasks screen.
class TasksScreen extends StatelessWidget {
  /// Constructor.
  TasksScreen() {
    print("## Tasks.constructor");

    // Initial load of data.
    tasksModel.loadData("tasks", TasksDBWorker.db);
  }

  @override
  Widget build(BuildContext inContext) {
    print("## Tasks.build()");

    return ScopedModel<TasksModel>(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(builder:
          (BuildContext inContext, Widget inChild, TasksModel inModel) {
        return IndexedStack(
          index: inModel.stackIndex,
          children: [
            TasksListWidget(),
            TasksEntryWidget(),
          ],
        );
      }),
    );
  }
}
