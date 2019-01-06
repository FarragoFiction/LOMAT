import '../NPCs/LOMATNPC.dart';
import 'LOMATSection.dart';
import 'dart:html';

class TalkySection extends LOMATSection {
  LOMATNPC npc;
  TalkySection(LOMATNPC this.npc,Element parent) : super(parent);

  @override
  void init() {
    myContainer.classes.add("talkyScreen");
    npc.displayDialogue(myContainer, this);
  }
}