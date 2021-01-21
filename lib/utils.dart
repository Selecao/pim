import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'base_model.dart';

/// The application's document directory for contact avatar image files and DB files.
Directory docsDir;

Future selectDate(
    BuildContext inContext, BaseModel inModel, String inDateString) async {
  print("## globals.selectedDate()");

  DateTime initialDate = DateTime.now();

  // If editing, set the initialDate to the current birthday, if any.
  if (inDateString != null) {
    List dateParts = inDateString.split(",");
    // Create a DateTime using the year, month and day from dateParts.
    initialDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
  }

  // Request the date.
  DateTime picked = await showDatePicker(
    context: inContext,
    initialDate: initialDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  // If they didn't cancel, update it in the model so it shows on the screen and
  // return the string form.
  if (picked != null) {
    inModel.setChosenDate(DateFormat.yMMMMd("en_US").format(picked.toLocal()));
    return "${picked.year},${picked.month},${picked.day}";
  }
}
