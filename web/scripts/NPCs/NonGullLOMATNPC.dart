import 'dart:html';

import 'package:CommonLib/Utility.dart';

import '../AnimationObject.dart';
import '../Sections/LOMATSection.dart';
import 'LOMATNPC.dart';
import 'TalkyEnd.dart';
import 'TalkyLevel.dart';

//WARNING: NEVER RECRUIT THESE
class NonGullLOMATNPC extends LOMATNPC {
  ImageElement avatar;
  NonGullLOMATNPC(String name, TalkyLevel talkyLevel, ImageElement this.avatar) : super(name, talkyLevel, null) {
      if(avatar != null) {
          avatar.classes.add("npcImage");
      }
  }

  @override
  void displayDialogue(Element container, LOMATSection screen) {
      talkyLevel.screen = screen;
      if(talkyEnd == null) talkyEnd = new TalkyEnd(talkyLevel);

      div = new DivElement()..classes.add("dialogueContainer");
      DivElement nameElement = new DivElement()..text = "$name"..classes.add("dialogueName");
      container.append(nameElement);
      container.append(avatar);
      container.append(div);
      talkyLevel.display(div);
  }

  @override
  Map<dynamic, dynamic> toJSON(){
      Map<dynamic, dynamic> ret = super.toJSON();
      ret["type"] = "???";
      ret["imgSrc"] = avatar.src;
      return ret;
  }

  @override
  void loadJSON(JsonHandler json) {
      leavingMessage = json.getValue("leavingMessage");
      causeOfDeath = json.getValue("causeOfDeath");
      hp = json.getValue("hp");
      talkyLevel = TalkyLevel.loadFromJSON(this,new JsonHandler(json.getValue("talkyLevel")));
      avatar = new ImageElement(src: json.getValue("imgSrc"));
      avatar.classes.add("npcImage");
  }



  @override
  void emote(int emotion) {
      //DOES NOTHING but eventually maybe change avatar graphic.
  }


}