import '../../GuideBot.dart';
import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class GuideBotButton extends MenuItem {
  GuideBot bot = GuideBot.instance;
  GuideBotButton(MenuHolder holder) : super("!Bot",holder);

  @override
  void onClick() {
    bot.toggle();
  }


  @override
  void init() {
    super.init();
    container.id = "botBotton";
    container.style.boxShadow =  "0px 3px 13px #888888";
  }


}