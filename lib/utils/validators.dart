class Validators {
  static bool emptyCheck(String text) {
    if (text.isEmpty || text.trim() == '' || text.trim() == "") {
      return true;
    } else {
      return false;
    }
  }

  static dynamic isTextEmpty(String text) {
    if (emptyCheck(text)) return "Can't be empty";
  }

  static dynamic isEmailValid(String email) {
    if (emptyCheck(email)) return "Can't be empty";
    final validCharacters = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!validCharacters.hasMatch(email.trim())) return "Email isn't valid";
  }
}
