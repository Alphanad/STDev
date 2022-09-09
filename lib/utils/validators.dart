import 'package:stdev/configs/strings.dart';

class Validators {
  static bool emptyCheck(String text) {
    if (text.isEmpty || text.trim() == '' || text.trim() == "") {
      return true;
    } else {
      return false;
    }
  }

  static dynamic isTextEmpty(String text) {
    if (emptyCheck(text)) return Strings.emptyError;
  }

  static dynamic isEmailValid(String email) {
    if (emptyCheck(email)) return Strings.emptyError;
    final validCharacters = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!validCharacters.hasMatch(email.trim())) return Strings.invalidEmailError;
  }
}
