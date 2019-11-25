import 'dart:convert';

import 'package:CommonLib/Collection.dart';
import 'package:CommonLib/NavBar.dart';
import 'package:CommonLib/Utility.dart';

import 'AnimationObject.dart';
import 'GameStats.dart';
import 'Locations/Events/Effects/DelayEffect.dart';
import 'Locations/Events/Effects/DiseaseEffect.dart';
import 'Locations/Events/Effects/InstaKillEffect.dart';
import 'Locations/Events/Effects/MoneyEffect.dart';
import 'Locations/Events/RoadEvent.dart';
import 'Locations/PhysicalLocation.dart';
import 'Locations/Road.dart';
import 'Locations/Town.dart';
import 'Locations/TownGenome.dart';
import 'NPCs/Disease.dart';
import 'NPCs/LOMATNPC.dart';
import 'NPCs/NonGullLOMATNPC.dart';
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
    NonGullLOMATNPC lilScumbag;
    GameStats gameStats = GameStats.load();
    bool partySectionDisplayed = false;
    LOMATNPC ebony; //needed for grim to keep track of.
    LOMATNPC skol; //needed to bark at lil scumbag
    LOMATNPC roger_koon;
    LOMATNPC the_kid;
    bool dangerousMode = false;
    LOMATNPC halja;
    bool amagalmatesMode = false;
    PhysicalLocation currentLocation;
    PartySection partySection;
    TalkySection talkySection;
    //TODO when spawning a new road need to see if it has an assocaited tombstone.
    List<Tombstone> graves = new List<Tombstone>();
    int maxPartySize = 5;
    //TODO probably deprecating this, void travel makes it unneeded
    int get travelAmount => dangerousMode?500:2000;
    int get diseaseAmount => dangerousMode?1000:2000;
    int get eventAmount => dangerousMode?1000:2000;

    int get costPerTravelTick => ((partyMembers.length + 1) * (eventAmount/1000).ceil());

    static Game get instance {
        if(_instance == null) {
            _instance = new Game();
            _instance.init(); //if init were part of new game weird things happen if other things wanna grab the instance
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

    void init() {
        // TODO and load certain save data facts from local storage
        //async, but don't care when it loads
        dynamic ss;
        ss = window.onClick.listen((Event e) {
            SoundControl().playTheWind();
            ss.cancel;
        });
        handleVoid();
        Tombstone.loadFromTIMEHOLE();
    }


    List<Tombstone> tombstonesForRoad(Road road){
        //go through all tombstones known
        //if either road name matches yours (or is null) return true
        List<Tombstone> ret = new List<Tombstone>();
        Random rand = new Random();
        graves.shuffle();
        for(Tombstone tombstone in graves) {
            if(canUseTIMEHOLEtombstone(tombstone, rand,ret.length) || (tombstone.townNames.contains(road.destinationTown.name) ||  tombstone.townNames.contains(road.sourceTown.name))) {
                ret.add(tombstone);
            }
        }
        return ret;
    }

    //dont just have hundreds, you have to have no cities and a random chance
    bool canUseTIMEHOLEtombstone(Tombstone tombstone, Random rand, int length) => (length < 3 &&tombstone.townNames.isEmpty && rand.nextDouble() >0.8);

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

    void loadTombstones(List<dynamic> loadedTombstones) {
        print("graves has ${graves.length} before loading");
        for(Map<dynamic,dynamic>json in loadedTombstones) {
            //will add too graves list
            Tombstone.loadFromJSON(new JsonHandler(jsonDecode(json["tombstoneJSON"])))..setID(json["id"]);
        }
        graves.shuffle();
        print("graves has ${graves.length} after loading");
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
        //wanderingNPCs.add(NPCFactory.jrTest());
        wanderingNPCs.add(NPCFactory.lilscumbag());
        wanderingNPCs.add(NPCFactory.ebony());
        wanderingNPCs.add(NPCFactory.rogerKoon());
        wanderingNPCs.add(NPCFactory.skol());
        wanderingNPCs.add(NPCFactory.halja());
        wanderingNPCs.add(NPCFactory.the_kid());
        wanderingNPCs.add(NPCFactory.loki());
        wanderingNPCs.add(NPCFactory.grim());
        //yn will be spawned at town time
        //wanderingNPCs.forEach((LOMATNPC npc) => npc.dead = true);
        print('after initialization, npcs are $wanderingNPCs');
    }

    void makeAmagalmates() async {
        Random rand = new Random();
        for(int i = 0; i< 7; i++) {
            wanderingNPCs.add(await LOMATNPC.generateRandomNPC(rand.nextInt()));
        }
    }

    LOMATNPC findLilScumbag() {
        if(wanderingNPCs.contains(lilScumbag)) {
            wanderingNPCs.remove(lilScumbag);
            return lilScumbag;
        }else {
            return lilScumbag;
        }
    }

    bool amalgmationTime() {
        if(amagalmatesMode) return false; //don't infinite loop
        if(!halja.dead) return false;
        if(!the_kid.dead) return false;
        if(!roger_koon.dead) return false;
        if(!skol.dead) return false;
        if(!ebony.dead) return false;
        return true;
    }

    void beginAmalgamatesMode() async{
        amagalmatesMode = true;
        wanderingNPCs.clear(); //remove regular npcs too
        await makeAmagalmates();
    }

    List<LOMATNPC> findWanderingNPCS() {
        if(amagalmatesMode && wanderingNPCs.isEmpty) {
            makeAmagalmates();
            return [];
        }
        if(wanderingNPCs.isEmpty) return [];
        Random rand = new Random();
        List<LOMATNPC> ret = <LOMATNPC>[];
        int npcs = rand.nextIntRange(1,3);
        for(int i = 0; i< npcs; i++) {
            LOMATNPC choice = rand.pickFrom(wanderingNPCs);
            //shouldn't happen but be careful becaues multiple recruits keep happening
            if(choice != null && !partyMembers.contains(choice)) {
                ret.add(choice);
                wanderingNPCs.remove(choice);
            }
        }
        return ret;
    }

    bool recruit(LOMATNPC npc) {
        print("before recruiting $npc, party members length is ${partyMembers.length} and is $partyMembers");
        if(partyMembers.length >= maxPartySize || partyMembers.contains(npc)) {
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
        Town town = new Town.dontevercallthisblindly("Landing Site",new List<LOMATNPC>(),null,startingGenome());
        town.proceduralIntroInit("Starting Town");

        //town = Town.voidTown;
        //don't overwrite genome
        currentLocation = town;
    }


//eventually load from JSON
    TownGenome  startingGenome() {
        TownGenome ret = new TownGenome("starting town",new Random(13),new Map<String, String>());
        ret.startText = "The majestic SWEET VIKING BOAT crashes uselessly on the decidedly non liquid water of the frozen wastelands of the Land of Mists and Trails. Whether a cruel prank or mere careless oversight, it seems the Oracles of the Golden Moon failed to warn the Player of LOMAT, Eirikr Kharun, not to bother bringing his boat.  ";
        ret.middleText = "You waste no time converting it to a SWEET VIKING LAND BOAT and resolve to figure out just how this crazy land works.";
        ret.endText = "You feel...really optimistic. You were born to play this game, and boy will you.";
        ret.playList = <String>["Trails_Slice1","Trails_Slice2","Trails_Slice3","Trails_Slice4","Trails_Slice5","Trails_Slice6"];
        ret.foreground = "${TownGenome.foregroundBase}/5.png";
        ret.midGround = "${TownGenome.midgroundBase}/7.png";
        ret.ground = "${TownGenome.groundBase}/5.png";
        ret.background = "${TownGenome.backgroundBase}/6.png";
        DelayEffect smallDelay = new DelayEffect(1);
        DelayEffect mediumEffect = new DelayEffect(2);

        DelayEffect largeEffect = new DelayEffect(3);
        DelayEffect largeEffectBackwards = new DelayEffect(-13)..image.src = "images/EventIcons/raidho.png";

        ret.events.clear();
        ret.events = new WeightedList<RoadEvent>();
        ret.events.add(new RoadEvent("Get Homaged","${RoadEvent.PARTYMEMBER} gets dysentery or something.", new DiseaseEffect(new Disease("Dysentery","Like that one game", 8,5)), 1));
        ret.events.add(new RoadEvent("Lightning Strike","A lightning bolt comes out of nowhere, striking ${RoadEvent.PARTYMEMBER}.", new InstaKillEffect("lightning to the face"), 0.1));
        ret.events.add(new RoadEvent("Diss the Sentry","A sentry blocks the way, and ${RoadEvent.PARTYMEMBER} is really rude to them.", new InstaKillEffect("dissing a sentry"), 0.1));
        ret.events.add(new RoadEvent("A Cactus Or Something","A lone cactus sits in the road. It's friendly aura compels ${RoadEvent.PARTYMEMBER} to give it a hug.", new DiseaseEffect(new Disease("Needle Affliction.","It hurts.", 8,5))..image.src="images/EventIcons/cactus.png", 0.5));
        ret.events.add(new RoadEvent("Disease!!!","${RoadEvent.PARTYMEMBER} spends the night shivering in wet boots.", new DiseaseEffect(), 0.5));
        ret.events.add(new RoadEvent("Disease!!!","${RoadEvent.PARTYMEMBER} mentions finding interesting new friends back in the last town.", new DiseaseEffect(), 0.05));

        //ret.events.add(new RoadEvent("Road Work Being Done","You encounter a group of sqwawking 'ghosts' in the middle of the road. They refuse to move.", smallDelay, 0.01));
        ret.events.add(new RoadEvent("Absolutely Get Wrecked","BY ODINS LEFT VESTIGAL VENOM SACK, your wago...I mean SWEET VIKING LAND BOAT breaks down.", largeEffect, 0.2));
        ret.events.add(new RoadEvent("Absolutely Get Stoked","BY THE FATHERS MANY EYES, uh. Is that drunken revelry in the distance you hear? You better go a little bit faster to make sure you avoid it.", largeEffectBackwards, 0.4));
        ret.events.add(new RoadEvent("Be Lucky!!!!!!!!","Oh, hey. While repairing your SWEET VIKING LAND BOAT you happened to find some funds!", new MoneyEffect(13), 0.3));

        return ret;
    }


}