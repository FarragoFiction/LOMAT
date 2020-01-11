import 'dart:async';

import '../../Game.dart';
import '../../GuideBot.dart';
import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class GuideBotButton extends MenuItem {
  GuideBot bot = GuideBot.instance;
  GuideBotButton(MenuHolder holder) : super("!Bot",holder);

  @override
  void onClick() {
    //TODO show popup instead
    if(!bot.running) {
      DivElement modal = new DivElement()..classes.add("flavorText");
      String warning = "Are you SURE you want to turn off LOMAT's Bot mode? Are you prepared for the possibility that once you are no longer in control, you may not be able to get it back?";
      modal.text = warning;
      DivElement buttonHolder = new DivElement();
      //TODO have two buttons, cancel, and abdicate
      ButtonElement yes = new ButtonElement()
        ..classes.add("voidButton")
        ..text = "ABDICATE";
      ButtonElement no = new ButtonElement()
        ..classes.add("voidButton")
        ..text = "ABJURE";
      yes.onClick.listen((Event e) {
        bot.toggle();
        modal.text = "Don't say we didn't warn you, bro...";
        dismissAfterTime(modal,1000);
      });
      buttonHolder.append(yes);
      buttonHolder.append(no);
      modal.append(buttonHolder);
      Game.instance.currentLocation.container.append(modal);

      no.onClick.listen((Event e) {
        modal.remove();
      });
    }else {
      bot.toggle();
    }

  }

  void dismissAfterTime(Element element, int time) async {
  new Timer(new Duration(milliseconds: time), () => {
    element.remove()
  });

  }


  @override
  void init() {
    super.init();
    container.id = "botBotton";
    container.style.boxShadow =  "0px 3px 13px #888888";
  }


}