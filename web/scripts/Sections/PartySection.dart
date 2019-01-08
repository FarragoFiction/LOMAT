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

  void update(){
    List<LOMATNPC> npcs = Game.instance.partyMembers;
    List<SinglePartyMember> toRemove = new List<SinglePartyMember>();

    partyMembers.forEach((SinglePartyMember member) {
      //handles changing values or outright removing self
      member.update(npcs);
      //makes sure they don't get added
      npcs.remove(member.partyMember);
      if(member.noLongerValid) {
        toRemove.add(member);
      }
    });
    //grabs the new ones
    npcs.forEach((LOMATNPC npc) {
      SinglePartyMember member = new SinglePartyMember(myContainer, npc);
      partyMembers.add(member);
      member.display();
      member.update(npcs);
    });

    //you're not in the party any more
    toRemove.forEach((SinglePartyMember member) {
      partyMembers.remove(member);
    });

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
  DivElement hpValue;
  DivElement diseaseValue;
  DivElement name;
  //if true my parent should stop paying attention to me. (god that sounds depressing, but no child is invalid irl i promise)
  bool noLongerValid = false;

  SinglePartyMember(Element parent, LOMATNPC this.partyMember) {
    container = new DivElement();
    parent.append(container);
    container.classes.add("npcBox");

  }

  //if i'm not in the list, remove self.
  void update(List<LOMATNPC> npcs) {
    if(npcs.contains(partyMember)){
      sync();
    }else{
      noLongerValid = true;
      container.remove();
    }
  }

  void display() {
    //not in sync with bullshit
    npcPortrait = partyMember.imageCopy;
    npcPortrait.classes.add("statPortrait");
    container.append(npcPortrait);
    name = new DivElement()..text = "${partyMember.name}"..classes.add("nameLabel");
    container.append(name);
    displayHPLabel();
    displayDiseaseLabel();
    sync();
  }

  void sync() {
    npcPortrait.src = partyMember.imgSrcForEmotion(partyMember.emotionForCurrentHealth);
    hpValue.text = "${partyMember.healthPhrase}";
    name.text = "${partyMember.name}";
  }


  void setDisease() {
    diseaseValue.text = "${partyMember.diseasePhrase}";
  }

  void displayHPLabel() {
    LabelElement hpLabel = new LabelElement()..text = "Health:";
    hpValue = new DivElement()..text = "${partyMember.healthPhrase}"..classes.add("statValue");
    container.append(hpLabel);
    container.append(hpValue);

  }

  void displayDiseaseLabel() {
    LabelElement hpLabel = new LabelElement()..text = "Disease:";
    diseaseValue = new DivElement()..text = "${partyMember.diseasePhrase}"..classes.add("statValue");
    container.append(hpLabel);
    container.append(diseaseValue);

  }
}