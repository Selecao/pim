import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'appointments_db_worker.dart';
import 'appointments_list_widget.dart';
import 'appointments_entry_widget.dart';
import 'appointments_model.dart' show AppointmentsModel, appointmentsModel;

class AppointmentsScreen extends StatelessWidget {
  /// Constructor.
  AppointmentsScreen() {
    print("## Appointments.constructor");

    // Initial load of data.
    appointmentsModel.loadData("appointments", AppointmentsDBWorker.db);
  }

  @override
  Widget build(BuildContext inContext) {
    print("## Appointments.build()");

    return ScopedModel<AppointmentsModel>(
      model: appointmentsModel,
      child: ScopedModelDescendant<AppointmentsModel>(
        builder: (BuildContext inContext, Widget inChild,
            AppointmentsModel inModel) {
          return IndexedStack(
            index: inModel.stackIndex,
            children: [
              AppointmentsListWidget(),
              AppointmentsEntryWidget(),
            ],
          );
        },
      ),
    );
  }
}
