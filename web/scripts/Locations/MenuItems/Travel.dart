import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class Travel extends MenuItem {
  Travel(MenuHolder holder) : super("Travel",holder);

  @override
  void onClick() {
    holder.location.doTravel();
  }


  @override
  void init() {
    super.init();
    container.id = "travelButton";
  }


}