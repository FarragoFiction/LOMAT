import '../../Game.dart';
import '../../Sections/TalkySection.dart';
import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class Back extends MenuItem {
  Back(MenuHolder holder) : super("Back",holder);

  @override
  void onClick() {
    holder.location.shitGoBack();
  }


  @override
  void init() {
    super.init();
    container.id = "backButton";
  }
}