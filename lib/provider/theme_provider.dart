import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier{
  bool isDark = false;

  void changTheme(){
    isDark = !isDark;
    notifyListeners();
  }

}