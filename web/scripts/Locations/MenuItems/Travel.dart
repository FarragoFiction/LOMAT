import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class Travel extends MenuItem {
  Travel(MenuHolder holder) : super("Travel",holder);

  @override
  void onClick() {
    window.alert("TODO");
  }
}