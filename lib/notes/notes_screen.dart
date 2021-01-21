import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'notes_db_worker.dart';
import 'notes_list_widget.dart';
import 'notes_entry_widget.dart';
import 'notes_model.dart' show NotesModel, notesModel;

class NotesScreen extends StatelessWidget {
  /// Constructor.
  NotesScreen() {
    print("## Notes.constructor");

    // Initial load of data.
    notesModel.loadData("notes", NotesDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    print("## Notes.build()");

    return ScopedModel<NotesModel>(
      model: notesModel,
      child: ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context, Widget child, NotesModel model) {
          return IndexedStack(
            index: model.stackIndex,
            children: [
              NotesListWidget(),
              NotesEntryWidget(),
            ],
          );
        },
      ),
    );
  }
}
