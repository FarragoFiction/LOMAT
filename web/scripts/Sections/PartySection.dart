import '../Game.dart';
import '../NPCs/LOMATNPC.dart';
import 'LOMATSection.dart';
import 'dart:html';

//TODO assume the party submission position
class PartySection extends LOMATSection {
  PartySection(Element parent) : super(parent);
  List<SinglePartyMember> partyMembers = new List<SinglePartyMember>();

  @override
  void init() {
    List<LOMATNPC> npcs = Game.instance.partyMembers;
    print("Initializing the party section for ${npcs.length} party members.");
    myContainer.classes.add("partyScreen");
    myContainer.id = "PartySection";
    npcs.forEach((LOMATNPC npc) {
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

  void display() {
    container.append(partyMember.displayImage);
  }
}