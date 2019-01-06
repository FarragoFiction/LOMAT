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
      partyMembers.add(new SinglePartyMember(myContainer, npc));
    });
    display();
  }

  void display() {
    partyMembers.forEach((SinglePartyMember s)
    {
      s.display();
    });
  }
}

class SinglePartyMember {
  LOMATNPC partyMember;
  Element container;
  ImageElement npcPortrait;

  SinglePartyMember(Element parent, LOMATNPC this.partyMember) {
    container = new DivElement();
    parent.append(container);
    container.classes.add("npcBox");

  }

  void display() {
    //not in sync with bullshit
    npcPortrait = partyMember.imageCopy;
    npcPortrait.classes.add("statPortrait");
    container.append(npcPortrait);
    DivElement name = new DivElement()..text = "${partyMember.name}"..classes.add("nameLabel");
    container.append(name);
    displayHPLabel();


  }

  void displayHPLabel() {
    LabelElement hpLabel = new LabelElement()..text = "Health:";
    DivElement hpVAlue = new DivElement()..text = "${partyMember.healthPhrase}"..classes.add("statValue");
    container.append(hpLabel);
    container.append(hpVAlue);

  }
}