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

  void scrambleVoid(DivElement me, int cost) async {
    me.text = "As you wish, Guide. The towns at the edge of your current locations light will be altered.";
    SoundControl.instance.playSoundEffect("121990__tomf__coinbag");
    Game.instance.removeFunds(cost);
    await ( holder.location as Town).scrambleRoads(); //if i do this EVERY time i end up with more towns than i have
    await Future.delayed(Duration(seconds: 2));
    me.remove();
    doVoidTravel(); //pop back up
  }

  void voidSelf(me) async {
    me.text = "As you wish, Guide. You will be starting over from now, at a random location.";
    SoundControl.instance.playSoundEffect("Dead_Jingle_light");
    await Future.delayed(Duration(seconds: 1));
    me.remove();
    await Game.instance.startOver(holder.location); //if i do this EVERY time i end up with more towns than i have
  }


  void voidTown(DivElement me, Town town, int cost) async {
    me.text = "As you wish, Guide. ${town.name} will be in the spotlight no more.";
    SoundControl.instance.playSoundEffect("121990__tomf__coinbag");
    Game.instance.removeFunds(cost);
    Town.cachedTowns.remove(town);
    await Future.delayed(Duration(seconds: 2));
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
    DivElement instructions = new DivElement()..text = "You find yourself in the Void. Obvious exits are none. You realize that you can unhook the tenuous connections between yourself and the ${Town.cachedTowns.length} locations that exist in the spotlight. Besides your current location, of course. Wouldn't want to lose yourself, now would you?"..id='instructions';

    DivElement money = new DivElement()..text = "You have ${Game.instance.funds} funds to spend here.";
    instructions.append(money);
    UListElement list = new UListElement()..classes.add("voidList");
    instructions.append(list);
    voidSelfItem(list,me);
    scrambleItem(list,me);
    for(Town town in Town.cachedTowns) {
      townItem(town, list, me);
    }



    me.append(instructions);
    return instructions;
  }

  void scrambleItem(UListElement list, DivElement me) {
      LIElement li = new LIElement();
      list.append(li);

      Element button = new DivElement();
      li.append(button);
      //print("I appended it to the menu holder with children ${holder.container.children.length}");
      button.classes.add("goDark");
      int cost = 13;
      if(cost < Game.instance.funds) {
        button.text = "Scromble Neighbors (13 funds)";
        button.onClick.listen((Event e){
          scrambleVoid(me,cost);
        });
      }else {
        button.text = "Insufficent Funds to Scromble";
        button.classes.add("disabledVoid");
      }

  }

  void voidSelfItem(UListElement list, DivElement me) {
    LIElement li = new LIElement();
    list.append(li);

    Element button = new DivElement();
    li.append(button);
    //print("I appended it to the menu holder with children ${holder.container.children.length}");
    button.classes.add("goDark");
      button.text = "Void Self (${Game.instance.funds-113} funds)";
      button.onClick.listen((Event e){
        voidSelf(me);
      });

  }

  void townItem(Town town, UListElement list, DivElement me) {
    if(town != holder.location) {
      String neighbor = "";
      if ((holder.location as Town).neighbors.contains(town)) {
        neighbor = " (nearby)";
      }
      LIElement li = new LIElement();
      list.append(li);

      Element button = new DivElement();
      li.append(button);
      //print("I appended it to the menu holder with children ${holder.container.children.length}");
      button.classes.add("goDark");
      int cost = 13*town.rand.nextIntRange(1,3);
      if(cost < Game.instance.funds) {
        button.text = "Go Dark ($cost funds)";
        button.onClick.listen((Event e) {
          voidTown(me, town, cost);
        });
      }else {
        button.text = "Insufficent Funds";
        button.classes.add("disabledVoid");
      }

      SpanElement span = new SpanElement()..text = "${town.name}${neighbor}";
      li.append(span);

    }
  }


}