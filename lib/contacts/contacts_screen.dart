import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'contacts_db_worker.dart';
import 'contacts_list_widget.dart';
import 'contacts_entry_widget.dart';
import 'contacts_model.dart' show ContactsModel, contactsModel;

class ContactsScreen extends StatelessWidget {
  Contacts() {
    print("## Contacts.constructor");

    // Initial load of data.
    contactsModel.loadData("contacts", ContactsDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    print("## Contacts.build()");

    return ScopedModel<ContactsModel>(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
        builder:
            (BuildContext inContext, Widget inChild, ContactsModel inModel) {
          return IndexedStack(
            index: inModel.stackIndex,
            children: [
              ContactsListWidget(),
              ContactsEntryWidget(),
            ],
          );
        },
      ),
    );
  }
}
