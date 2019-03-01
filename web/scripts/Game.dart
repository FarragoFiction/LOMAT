import 'Locations/Events/Effects/DelayEffect.dart';
import 'Locations/Events/Effects/InstaKillEffect.dart';
import 'Locations/Events/RoadEvent.dart';
import 'Locations/PhysicalLocation.dart';
import 'Locations/Town.dart';
import 'Locations/TownGenome.dart';
import 'NPCs/LOMATNPC.dart';
import 'Sections/PartySection.dart';
import 'Sections/TalkySection.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';
/*
TODO: have a screen to view current party members and talk to them.
TODO: have new talky item that is "recruit" (only if not currently in party)
TODO: have pool of npcs
TODO: if party member is currently in target town, get funds, they leave party and rejoin pool
TODO: npcs bring events with them
TODO: npc builder
 */

class Game
{
    static Game _instance;
    bool partySectionDisplayed = false;
    PhysicalLocation currentLocation;
    PartySection partySection;
    TalkySection talkySection;
    int maxPartySize = 5;
    static Game get instance {
        if(_instance == null) {
            _instance = new Game();
        }
        return _instance;
    }
    int _funds = 0;
    int get funds => _funds;
    List<LOMATNPC> partyMembers = new List<LOMATNPC>();


    Element container;
    Element moneyContainer;

    Game() {
        testNPCs();
    }

    void dismissTalkySection() {
        talkySection.teardown();
        talkySection = null;
    }

    void popupTalkySection(LOMATNPC npc, Element parent) {
        talkySection = new TalkySection(npc, parent);
    }

    bool recruit(LOMATNPC npc) {
        if(partyMembers.length >= maxPartySize) {
            return false;
        }
        partyMembers.add(npc);
        partySection.update();
        return true;
    }

    //i imagine they get shot out physics style tbh
    void eject(LOMATNPC npc) {
        partyMembers.remove(npc);
        partySection.update();
    }

    void addFunds(int amount) {
        _funds += amount;
        syncMoney();
        //TODO save here.
    }

    void removeFunds(int amount) {
        _funds += -1*amount;
        syncMoney();
        //TODO save here.
    }

    Future testNPCs() async {
        partyMembers.add(await LOMATNPC.generateRandomNPC(1)..hp =50..name = "Firsty");
        partyMembers.add(await LOMATNPC.generateRandomNPC(2)..hp =15..name = "Secondy");
        partyMembers.add(await LOMATNPC.generateRandomNPC(3)..hp = 0..name = "Thirdy");
        partyMembers.add(await LOMATNPC.generateRandomNPC(4)..hp =88..name="Fourthy");
        if(!partySectionDisplayed) {
            displayPartySection();
        }
    }

    Future<Null> display(Element parent) async {
        container = new DivElement();
        parent.append(container);
        moneyContainer = new DivElement()..classes.add("money");
        container.append(moneyContainer);
        syncMoney();
        displayStartingTown(container);
        //ONLY NEEDED FOR TEST NPCS or otherwise loading npcs
        if(partyMembers.length > 0) {
            displayPartySection();
        }

    }

    void displayPartySection() {
        partySectionDisplayed = true;
      //always display npcs at bottom.
      Element partyContainer = querySelector("body");
      partySection = new PartySection(partyContainer);
    }

    void syncMoney() {
        moneyContainer.text = "Funds: $funds";
    }

    Future displayStartingTown(Element div) async {
        List<LOMATNPC> npcs = new List<LOMATNPC>();
        for(int i=0; i<3; i++) {
            LOMATNPC npc1 = await LOMATNPC.generateRandomNPC(i);
            npcs.add(npc1);
        }
        Town town = new Town("city2",npcs,null,startingGenome());
        town.displayOnScreen(div);
    }


//eventually load from JSON
    TownGenome  startingGenome() {
        TownGenome ret = new TownGenome(new Random(13),null);
        ret.startText = "You arrive in beautiful INSERTNAMEHERE, the jewel of LOMAT.";
        ret.middleText = "Or at least that's what you'd think if it were in its finished state.  Sadly, it appears to have been shittly drawn by a WASTE or something, and everything in it is in test mode and half finished.";
        ret.endText = " well, beats looking at a blank white screen, you suppose.";
        ret.playList = <String>["Trails_Slice1","Trails_Slice2","Trails_Slice3","Trails_Slice4","Trails_Slice5","Trails_Slice6"];
        ret.foreground = "${TownGenome.foregroundBase}/2.png";
        ret.midGround = "${TownGenome.midgroundBase}/4.png";
        ret.ground = "${TownGenome.groundBase}/4.png";
        ret.background = "${TownGenome.backgroundBase}/3.png";
        DelayEffect smallDelay = new DelayEffect(1);
        DelayEffect mediumEffect = new DelayEffect(2);
        DelayEffect largeEffect = new DelayEffect(3);
        ret.events = new List<RoadEvent>();
        ret.events.add(new RoadEvent("Lightning Strike","A lightning bolt comes out of nowhere, striking a party member.", new InstaKillEffect("lightning to the face"), 0.5));

        ret.events.add(new RoadEvent("Road Work Being Done","You encounter a group of sqwawking 'ghosts' in the middle of the road. They refuse to move.", smallDelay, 0.5));
        ret.events.add(new RoadEvent("Get Homaged","One of your currently nonexistant party members gets dysentery or something.", mediumEffect, 0.25));
        ret.events.add(new RoadEvent("Absolutely Get Wrecked","BY ODINS LEFT VESTIGAL VENOM SACK, your wago...I mean SWEET VIKING LAND BOAT breaks down.", largeEffect, 0.05));

        return ret;
    }


}