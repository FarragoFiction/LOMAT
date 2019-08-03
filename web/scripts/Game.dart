import 'package:CommonLib/Collection.dart';

import 'AnimationObject.dart';
import 'Locations/Events/Effects/DelayEffect.dart';
import 'Locations/Events/Effects/DiseaseEffect.dart';
import 'Locations/Events/Effects/InstaKillEffect.dart';
import 'Locations/Events/RoadEvent.dart';
import 'Locations/PhysicalLocation.dart';
import 'Locations/Road.dart';
import 'Locations/Town.dart';
import 'Locations/TownGenome.dart';
import 'NPCs/LOMATNPC.dart';
import 'NPCs/TalkyItem.dart';
import 'NPCs/TalkyLevel.dart';
import 'NPCs/TalkyQuestion.dart';
import 'NPCs/TalkyResponse.dart';
import 'NPCs/Tombstone.dart';
import 'Sections/PartySection.dart';
import 'Sections/TalkySection.dart';
import 'SoundControl.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';
/*
TODO: have a screen to view current party members and talk to them.
TODO: npcs bring events with them
 */

class Game
{
    static Game _instance;
    bool partySectionDisplayed = false;
    PhysicalLocation currentLocation;
    PartySection partySection;
    TalkySection talkySection;
    //TODO when spawning a new road need to see if it has an assocaited tombstone.
    List<Tombstone> graves = new List<Tombstone>();
    int maxPartySize = 5;
    //TODO probably deprecating this, void travel makes it unneeded
    int travelAmount = 1000; //default, if you go slower or faster it changes.
    int diseaseAmount = 1000; //default, if you go slower or faster it changes.
    int eventAmount = 5000; //default, if you go slower or faster it changes.

    int get costPerTravelTick => ((partyMembers.length + 1) * (eventAmount/1000).ceil());

    static Game get instance {
        if(_instance == null) {
            _instance = new Game();
        }
        return _instance;
    }
    int _funds = 113;
    int get funds => _funds;
    List<LOMATNPC> partyMembers = new List<LOMATNPC>();
    //these can be tapped to shove into a specific town
    List<LOMATNPC> wanderingNPCs = new List<LOMATNPC>();

    Element container;
    Element moneyContainer;

    Game() {
    }

    void testTombstones() {
        for(int i = 0; i<3; i++) {
            //just a tombstone spawning adds it to the list
            new Tombstone.withoutNPC("GameTest$i", "???", "???");
        }
    }

    List<Tombstone> tombstonesForRoad(Road road){
        //go through all tombstones known
        //if either road name matches yours (or is null) return true
        List<Tombstone> ret = new List<Tombstone>();
        for(Tombstone tombstone in graves) {
            if(tombstone.townNames.isEmpty || tombstone.townNames.contains(road.destinationTown.name) ||  tombstone.townNames.contains(road.sourceTown.name)) {
                ret.add(tombstone);
            }
        }
        return ret;
    }

    Future startOver(PhysicalLocation doop) async {
        Game.instance.removeFunds(Game.instance.funds);
        Game.instance.ejectAll();
        Town.cachedTowns.clear();
        Game.instance.addFunds(113); //start over.
        await Game.instance.setStartingTown();
        await Game.instance.initializeTowns();
        doop.teardown();
        Town town = new Random().pickFrom(Town.cachedTowns);
        town.displayOnScreen(container);
    }

    void dismissTalkySection() {
        talkySection.teardown();
        talkySection = null;
    }

    void popupTalkySection(LOMATNPC npc, Element parent) {
        talkySection = new TalkySection(npc, parent);
    }

    void popup(String text) {
        DivElement me = new DivElement()..classes.add("event");
        me.text = "$text";
        //animation or displaying a grave stone or whatever.
        //don't append to the road cuz things like deaths will hide it and then you wont see this
        container.append(me);


        //SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");

        me.onClick.listen((Event e)
        {
            me.remove();
        });

    }

    void travelTick() {
        removeFunds(costPerTravelTick);
    }

    //creates the initial npcs
    void initializeTowns() async {
        //as a test, make 1 set npcs and 4 random ones.
        for(int i = 0; i<4; i++) {
            await Town.cachedTowns.first.spawnNewBaby();
        }
    }

    //creates the initial npcs
    void initializeNPCS() async {
        //as a test, make 1 set npcs and 4 random ones.
        //await makeAmagalmates();
        wanderingNPCs.add(NPCFactory.jrTest());
        wanderingNPCs.add(NPCFactory.lilscumbag());
        wanderingNPCs.add(NPCFactory.ebony());
        wanderingNPCs.add(NPCFactory.rogerKoon());
        wanderingNPCs.add(NPCFactory.skol());
        wanderingNPCs.add(NPCFactory.halja());
        wanderingNPCs.add(NPCFactory.the_kid());
        wanderingNPCs.add(NPCFactory.loki());
        wanderingNPCs.add(NPCFactory.grim());
        //yn will be spawned at town time
        print('after initialization, npcs are $wanderingNPCs');
    }

    void makeAmagalmates() async {
        Random rand = new Random();
        for(int i = 0; i< 7; i++) {
            wanderingNPCs.add(await LOMATNPC.generateRandomNPC(rand.nextInt()));
        }
    }

    List<LOMATNPC> findWanderingNPCS() {
        if(wanderingNPCs.isEmpty) return [];
        Random rand = new Random();
        List<LOMATNPC> ret = <LOMATNPC>[];
        int npcs = rand.nextIntRange(1,3);
        for(int i = 0; i< npcs; i++) {
            LOMATNPC choice = rand.pickFrom(wanderingNPCs);
            if(choice != null) {
                ret.add(choice);
                wanderingNPCs.remove(choice);
            }

        }
        return ret;
    }

    bool recruit(LOMATNPC npc) {
        print("before recruiting $npc, party members length is ${partyMembers.length} and is $partyMembers");
        if(partyMembers.length >= maxPartySize) {
            return false;
        }
        SoundControl.instance.playSoundEffect("Dead_Jingle");
        partyMembers.add(npc);
        print("after adding, party members length is ${partyMembers.length} and is ${partyMembers}");

        partySection.update();
        print("after updating, party members length is ${partyMembers.length} and is ${partyMembers}");

        npc.currentTown.npcLeaves(npc,true);
        print("after leaving old town, party members length is ${partyMembers.length} and is ${partyMembers}");

        addFunds(13);
        print("after recruiting, party members length is ${partyMembers.length} and is ${partyMembers}");
        return true;
    }

    //i imagine they get shot out physics style tbh
    void eject(LOMATNPC npc) {
        print("removing npc $npc");
        partyMembers.remove(npc);
        partySection.update();
    }

    void ejectAll() {
        for(LOMATNPC npc in partyMembers) {
            partyMembers.remove(npc);
        }
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
        currentLocation.displayOnScreen(container);
        //ONLY NEEDED FOR TEST NPCS or otherwise loading npcs
        if(!partySectionDisplayed) {
            displayPartySection();
        }

    }

    void displayPartySection() {
        partySectionDisplayed = true;
      //always display npcs at bottom.
      Element partyContainer = querySelector("body");
      partySection = new PartySection(partyContainer);
    }

    //check all party members and see if this is their stop
    List<LOMATNPC> processArrivingParty(Town town) {
        List<LOMATNPC> ret = new List<LOMATNPC>();
        partyMembers.forEach((LOMATNPC npc)
        {
            if(town.name == npc.goalTownName) {
                ret.add(npc);
            }
        });

        ret.forEach((LOMATNPC npc) {
            npc.goalTownName = null;
            addFunds(85);
            eject(npc);
        });

        return ret;
    }

    void syncMoney() {
        moneyContainer.text = "Funds: $funds ($costPerTravelTick cost per tick to travel)";
    }

    Future setStartingTown() async {
        Town town = new Town.dontevercallthisblindly("city2",findWanderingNPCS(),null,startingGenome());
        //don't overwrite genome
       //await  town.initGenome();
        currentLocation = town;
    }


//eventually load from JSON
    TownGenome  startingGenome() {
        TownGenome ret = new TownGenome(new Random(13),new Map<String, String>());
        ret.startText = "You arrive in beautiful INSERTNAMEHERE, the jewel of LOMAT.";
        ret.middleText = "Or at least that's what you'd think if it were in its finished state.  Sadly, it appears to have been shittly drawn by a WASTE or something, and everything in it is in test mode and half finished.";
        ret.endText = " well, beats looking at a blank white screen, you suppose.";
        ret.playList = <String>["Trails_Slice1","Trails_Slice2","Trails_Slice3","Trails_Slice4","Trails_Slice5","Trails_Slice6"];
        ret.foreground = "${TownGenome.foregroundBase}/2.png";
        ret.midGround = "${TownGenome.midgroundBase}/6.png";
        ret.ground = "${TownGenome.groundBase}/4.png";
        ret.background = "${TownGenome.backgroundBase}/3.png";
        DelayEffect smallDelay = new DelayEffect(1);
        DelayEffect mediumEffect = new DelayEffect(2);
        DelayEffect largeEffect = new DelayEffect(3);
        ret.events.clear();
        ret.events = new WeightedList<RoadEvent>();
        ret.events.add(new RoadEvent("Lightning Strike","A lightning bolt comes out of nowhere, striking ${RoadEvent.PARTYMEMBER}.", new InstaKillEffect("lightning to the face"), 0.01));
        ret.events.add(new RoadEvent("Diss the Sentry","A sentry blocks the way, and ${RoadEvent.PARTYMEMBER} is really rude to them.", new InstaKillEffect("dissing a sentry"), 0.1));
        ret.events.add(new RoadEvent("Disease!!!","${RoadEvent.PARTYMEMBER} spends the night shivering in wet boots.", new DiseaseEffect(), 0.05));
        ret.events.add(new RoadEvent("Disease!!!","${RoadEvent.PARTYMEMBER} mentions finding interesting new friends back in the last town.", new DiseaseEffect(), 0.00005));

        ret.events.add(new RoadEvent("Road Work Being Done","You encounter a group of sqwawking 'ghosts' in the middle of the road. They refuse to move.", smallDelay, 0.5));
        ret.events.add(new RoadEvent("Get Homaged","${RoadEvent.PARTYMEMBER} gets dysentery or something.", new DiseaseEffect(), 0.25));
        ret.events.add(new RoadEvent("Absolutely Get Wrecked","BY ODINS LEFT VESTIGAL VENOM SACK, your wago...I mean SWEET VIKING LAND BOAT breaks down.", largeEffect, 0.3));

        return ret;
    }


}