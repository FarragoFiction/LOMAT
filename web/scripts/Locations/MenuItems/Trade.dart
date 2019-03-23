import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class Trade extends MenuItem {
  Trade(MenuHolder holder) : super("Trade", holder);

  @override
  void onClick() {
    window.alert("TODO");
  }


  @override
  void init() {
    super.init();
    container.id = "tradeButton";
  }
}