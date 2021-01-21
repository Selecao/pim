import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'tasks_db_worker.dart';
import 'tasks_model.dart' show Task, TasksModel, tasksModel;

/// The Tasks List sub-screen.
class TasksListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## TasksList.build()");

    return ScopedModelDescendant<TasksModel>(
        builder: (BuildContext inContext, Widget inChild, TasksModel inModel) {
      return Scaffold(
        // Add task.
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            tasksModel.entityBeingEdited = Task();
            tasksModel.setChosenDate(null);
            tasksModel.setStackIndex(1);
          },
        ),
        body: ListView.builder(
            // Get the first Card out of the shadow.
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            itemCount: tasksModel.entityList.length,
            itemBuilder: (BuildContext inBuildContext, int inIndex) {
              Task task = tasksModel.entityList[inIndex];
              // Get the date, if any, in a human-readable format.
              String sDueDate;
              if (task.dueDate != null) {
                List<String> dateParts = task.dueDate.split(",");
                DateTime dueDate = DateTime(int.parse(dateParts[0]),
                    int.parse(dateParts[1]), int.parse(dateParts[2]));
                sDueDate = DateFormat.yMMMMd("en_US").format(dueDate.toLocal());
              }
              // Create th Slidable.
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: .25,
                child: ListTile(
                  leading: Checkbox(
                    value: task.completed == "true" ? true : false,
                    onChanged: (value) async {
                      // Update the completed value for this task and refresh the list.
                      task.completed = value.toString();
                      await TasksDBWorker.db.update(task);
                      tasksModel.loadData("tasks", TasksDBWorker.db);
                    },
                  ),
                  title: Text(
                    "${task.description}",
                    // Dim and strikethrough the text when the task is completed.
                    style: task.completed == "true"
                        ? TextStyle(
                            color: Theme.of(inContext).disabledColor,
                            decoration: TextDecoration.lineThrough,
                          )
                        : TextStyle(
                            color:
                                Theme.of(inContext).textTheme.headline6.color,
                          ),
                  ),
                  subtitle: task.dueDate == null
                      ? null
                      : Text(
                          sDueDate,
                          // Dim and strikethrough the text when the task is completed.
                          style: task.completed == "true"
                              ? TextStyle(
                                  color: Theme.of(inContext).disabledColor,
                                  decoration: TextDecoration.lineThrough,
                                )
                              : TextStyle(
                                  color: Theme.of(inContext)
                                      .textTheme
                                      .headline6
                                      .color,
                                ),
                        ),
                  onTap: () async {
                    // Can't edit a completed task.
                    if (task.completed == "true") return;
                    // Get the data from the database and send to the edit view.
                    tasksModel.entityBeingEdited =
                        await TasksDBWorker.db.get(task.id);
                    // Parse out the due date, if any, and set it in the model for display.
                    if (tasksModel.entityBeingEdited.dueDate == null) {
                      tasksModel.setChosenDate(null);
                    } else {
                      tasksModel.setChosenDate(sDueDate);
                    }
                    tasksModel.setStackIndex(1);
                  },
                ),
                secondaryActions: [
                  IconSlideAction(
                    caption: "Delete",
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => _deleteTask(inContext, task),
                  )
                ],
              );
            }),
      );
    });
  }

  /// Show a dialog requesting delete confirmation.
  Future _deleteTask(BuildContext inContext, Task inTask) async {
    print("## TasksList._deleteTask(): inTask = $inTask");

    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
            title: Text("Delete Task"),
            content:
                Text("Are you sure you want to delete ${inTask.description}?"),
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  // Just hide dialog.
                  Navigator.of(inAlertContext).pop();
                },
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () async {
                  // Delete from database, then hide dialog, show SnackBar, the re-load data for the list.
                  await TasksDBWorker.db.delete(inTask.id);
                  Navigator.of(inAlertContext).pop();
                  Scaffold.of(inContext).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                    content: Text("Task deleted"),
                  ));
                  // Reload data from database to update list.
                  tasksModel.loadData("tasks", TasksDBWorker.db);
                },
              ),
            ],
          );
        });
  }
}
