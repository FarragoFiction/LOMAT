import '../../Game.dart';
import '../../SoundControl.dart';
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
    print("TODO: when i integrate with pl's audio lib, instead of NO music, have it go super slow instead to be creepy");
    SoundControl.instance.stopMusic();
    DivElement me = new DivElement()..classes.add("voidPopup");
    querySelector("body").append(me);
    ImageElement image = new ImageElement(src: "images/yeflask.png")..style.opacity="0.3";
    me.append(image);
    image.onClick.listen((Event e) {
      window.alert("You cannot get ye flask!");
    });
    DivElement instructions = townList(me);


    goDennis(instructions, me);
  }

  void goDennis(DivElement instructions, DivElement me) {
    Element button = new DivElement();
    instructions.append(button);
    //print("I appended it to the menu holder with children ${holder.container.children.length}");
    button.classes.add("voidButton");
    button.text = "Shit, Go Back";
    button.onClick.listen((Event e){
      SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
      me.remove();
    });
  }

  void voidTown(DivElement me, Town town) async {
    Town.cachedTowns.remove(town);
    await ( holder.location as Town).scrambleRoads();
    me.remove();
    doVoidTravel(); //pop back up
  }

  /*
  TODO:
  display current funds on screen. Display cost to void a town.  (seed from name)
  any town you can afford to void has a button. click button to remove it from cache. (re-rolls neighbors)
  rerenders town list when you do it.
  */
  DivElement townList(DivElement me) {
    DivElement instructions = new DivElement()..text = "You find yourself in the Void. Obvious exits are none. You realize that you can unhook the tenuous connections between yourself and various locations here."..id='instructions';

    DivElement money = new DivElement()..text = "You have ${Game.instance.funds} funds to spend here.";
    instructions.append(money);
    UListElement list = new UListElement()..classes.add("voidList");
    instructions.append(list);
    for(Town town in Town.cachedTowns) {
      if(town != holder.location) {
        String neighbor = "";
        if ((holder.location as Town).neighbors.contains(town)) {
          neighbor = " (nearby)";
        }
        LIElement li = new LIElement()
          ..text = "${town.name}${neighbor}";
        list.append(li);
        
        Element button = new DivElement();
        li.append(button);
        //print("I appended it to the menu holder with children ${holder.container.children.length}");
        button.classes.add("goDark");
        button.text = "Go Dark";
        button.onClick.listen((Event e){
          SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
          voidTown(me,town);
        });
      }
    }
    me.append(instructions);
    return instructions;
  }


}