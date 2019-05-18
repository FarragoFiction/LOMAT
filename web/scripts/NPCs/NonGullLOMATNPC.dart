import 'dart:html';

import '../AnimationObject.dart';
import '../Sections/LOMATSection.dart';
import 'LOMATNPC.dart';
import 'TalkyEnd.dart';
import 'TalkyLevel.dart';

//WARNING: NEVER RECRUIT THESE
class NonGullLOMATNPC extends LOMATNPC {
  ImageElement avatar;
  NonGullLOMATNPC(String name, TalkyLevel talkyLevel, ImageElement this.avatar) : super(name, talkyLevel, null) {
      avatar.classes.add("npcImage");
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
  void emote(int emotion) {
      //DOES NOTHING but eventually maybe change avatar graphic.
  }


}