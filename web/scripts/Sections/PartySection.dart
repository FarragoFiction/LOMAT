import '../Game.dart';
import '../NPCs/LOMATNPC.dart';
import 'LOMATSection.dart';
import 'dart:html';

//TODO
class PartySection extends LOMATSection {
  PartySection(Element parent) : super(parent);
  List<SinglePartyMember> partyMembers = new List<SinglePartyMember>();

  @override
  void init() {
    myContainer.classes.add("partyScreen");
    Game.instance.partyMembers.forEach((LOMATNPC npc) {
      Element subContainer = new DivElement();
      myContainer.append(subContainer);
      partyMembers.add(new SinglePartyMember(subContainer, npc));
    });
  }
}

class SinglePartyMember {
  LOMATNPC partyMember;
  Element container;

  SinglePartyMember(Element this.container, LOMATNPC this.partyMember) {

  }
}