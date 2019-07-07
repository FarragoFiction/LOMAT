import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class VoidTravel extends MenuItem {
  VoidTravel(MenuHolder holder) : super("Void",holder);

  @override
  void onClick() {
    holder.location.doVoidTravel();
  }


  @override
  void init() {
    super.init();
    container.id = "voidButton";
  }


}