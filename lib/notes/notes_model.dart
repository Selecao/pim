import '../base_model.dart';

/// A class representing this PIM entity type.
class Note {
  /// The fields this entity type contains.
  int id;
  String title;
  String content;
  String color;

  /// Just for debugging, so we get something useful in the console.
  String toString() {
    return "{ id=$id, title=$title, content=$content, color=$color }";
  }
}

/// The model backing this entity type's views.

class NotesModel extends BaseModel {
  /// Needed to be able to display what the user picks in the Text widget on the entry screen.
  String color;

  /// For display of the color chosen by the user.
  void setColor(String inColor) {
    print("## NotesModel.setColor(): inColor = $inColor");

    color = inColor;
    notifyListeners();
  }
}

// The one and only instance of this model.
NotesModel notesModel = NotesModel();
