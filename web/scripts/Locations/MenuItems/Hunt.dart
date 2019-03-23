import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class Hunt extends MenuItem {
  Hunt(MenuHolder holder) : super("Hunt", holder);

  @override
  void onClick() {
    holder.location.doHunt();
  }

  @override
  void init() {
    super.init();
    container.id = "huntingButton";
  }
}