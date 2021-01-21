import 'package:pim/base_model.dart';

class Contact {
  int id;
  String name;
  String phone;
  String email;
  String birthday; // YYYY, MM, DD

  /// Just for debugging, so we get something useful in the console.
  String toString() {
    return "{ id=$id, name=$name, phone=$phone, email=$email, birthday=$birthday }";
  }
}

/// The model backing this entity type's views.
class ContactsModel extends BaseModel {
  /// "Force" a rebuild of the entry page (when selecting an avatar image).
  void triggerRebuild() {
    print("## ContactsModel.triggerRebuild()");

    notifyListeners();
  }
}

// The one and only instance of this model.
ContactsModel contactsModel = ContactsModel();
