import '../Town.dart';
import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class VoidTravel extends MenuItem {
  VoidTravel(MenuHolder holder) : super("Void",holder);

  @override
  void onClick() {
    //unlike the other buttons, my location doesn't do this for me. the void is the same wherever.
    doVoidTravel();
  }


  @override
  void init() {
    super.init();
    container.id = "voidButton";
  }

  void doVoidTravel() {
    window.alert("Hello? Yes. Well there's ${Town.cachedTowns.length} towns here. We need to consign some of them to the void. ${Town.cachedTowns.join(",")}");
    DivElement me = new DivElement()..classes.add("voidPopup");
    querySelector("body").append(me);
    ImageElement image = new ImageElement(src: "images/yeflask.png")..style.opacity="0.3";
    me.append(image);
    image.onClick.listen((Event e) {
      window.alert("You cannot get ye flask!");
    });
    DivElement instructions = new DivElement()..text = "You find yourself in the void. Obvious exits are none. You realize that you can unhook the tenusous connections between yourself and various locations here."..id='instructions';
    me.append(instructions);
  }


}