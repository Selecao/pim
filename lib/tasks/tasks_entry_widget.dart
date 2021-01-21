import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:pim/utils.dart' as utils;
import 'tasks_db_worker.dart';
import 'tasks_model.dart' show TasksModel, tasksModel;

/// The Tasks Entry sub-screen.
class TasksEntryWidget extends StatelessWidget {
  /// Controllers for TextFields.
  final TextEditingController _descriptionEditingController =
      TextEditingController();

  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  TasksEntryWidget() {
    print("## TasksList.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _descriptionEditingController.addListener(() {
      tasksModel.entityBeingEdited.description =
          _descriptionEditingController.text;
    });
  }
  @override
  Widget build(BuildContext context) {
    print("## TasksEntry.build()");

    // Set value of controllers.
    if (tasksModel.entityBeingEdited != null) {
      _descriptionEditingController.text =
          tasksModel.entityBeingEdited.description;
    }

    return ScopedModel(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(
        builder: (BuildContext inContext, Widget inChild, TasksModel inModel) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      // Hide soft keyboard.
                      FocusScope.of(inContext).requestFocus(FocusNode());
                      // Go back to the list view.
                      inModel.setStackIndex(0);
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text("Save"),
                    onPressed: () {
                      _save(inContext, tasksModel);
                    },
                  ),
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Description.
                  ListTile(
                    leading: Icon(Icons.description),
                    title: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(hintText: "Description"),
                      controller: _descriptionEditingController,
                      validator: (String value) {
                        if (value.length == 0)
                          return "Please enter a description";
                        return null;
                      },
                    ),
                  ),
                  // Due date.
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text("Due Date"),
                    subtitle: Text(tasksModel.chosenDate == null
                        ? ""
                        : tasksModel.chosenDate),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blue,
                      onPressed: () async {
                        // Request a date from the user. If one is returned, store it.
                        String chosenDate = await utils.selectDate(inContext,
                            tasksModel, tasksModel.entityBeingEdited.dueDate);
                        if (chosenDate != null) {
                          tasksModel.entityBeingEdited.dueDate = chosenDate;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Save this contact to the database.
  void _save(BuildContext inContext, TasksModel inModel) async {
    print("## TasksEntry._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) return;

    // Creating a new task.
    if (inModel.entityBeingEdited.id == null) {
      print("## TasksEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await TasksDBWorker.db.create(tasksModel.entityBeingEdited);

      // Updating an existing task.
    } else {
      print("## TasksEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await TasksDBWorker.db.update(tasksModel.entityBeingEdited);
    }

    // Reload data from database to update list.
    tasksModel.loadData("tasks", TasksDBWorker.db);

    // Go back to the list view.
    inModel.setStackIndex(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
      content: Text("Tasks saved"),
    ));
  }
}
