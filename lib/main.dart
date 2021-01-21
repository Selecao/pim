import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'appointments/appointments_screen.dart';
import 'contacts/contacts_screen.dart';
import 'notes/notes_screen.dart';
import 'tasks/tasks_screen.dart';

import 'utils.dart' as utils;

void main() {
  startMeUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(FlutterBook());
  }

  startMeUp();
}

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## FlutterBook.build()");

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Personal Information Manager"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.date_range), text: "Appointments"),
                Tab(icon: Icon(Icons.contacts), text: "Contacts"),
                Tab(icon: Icon(Icons.note), text: "Notes"),
                Tab(icon: Icon(Icons.assignment_turned_in), text: "Tasks"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AppointmentsScreen(),
              ContactsScreen(),
              NotesScreen(),
              TasksScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
