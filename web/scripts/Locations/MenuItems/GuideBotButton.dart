import '../../GuideBot.dart';
import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class GuideBotButton extends MenuItem {
  GuideBot bot = GuideBot.instance;
  GuideBotButton(MenuHolder holder) : super("Bot",holder);

  @override
  void onClick() {
    bot.clickTravelButton();
  }


  @override
  void init() {
    super.init();
    container.id = "botBotton";
  }


}