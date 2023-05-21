import 'package:flutter/cupertino.dart';

import '../model/teacher.dart';

class UserLogin with ChangeNotifier {
  Teacher user = Teacher();
  changeUser(Teacher newUser) {
    user = newUser;
    notifyListeners();
  }
}
