import '../../Sections/TalkySection.dart';
import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class Talk extends MenuItem {
  Talk(MenuHolder holder) : super("Talk",holder);

  @override
  void onClick() {
    holder.location.doTalky();
  }


  @override
  void init() {
    super.init();
    container.id = "talkButton";
  }
}