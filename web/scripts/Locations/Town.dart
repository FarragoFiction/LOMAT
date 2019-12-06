import 'package:CommonLib/Collection.dart';
import 'package:TextEngine/TextEngine.dart';
import 'package:recase/recase.dart';

import '../CipherEngine.dart';
import '../Game.dart';
import '../NPCs/LOMATNPC.dart';
import '../Sections/TalkySection.dart';
import '../SoundControl.dart';
import 'Events/RoadEvent.dart';
import 'Fenrir.dart';
import 'HuntingGrounds.dart';
import 'Layers/ProceduralLayer.dart';
import 'Layers/StaticLayer.dart';
import 'MenuItems/MenuHolder.dart';
import 'MenuItems/Talk.dart';
import 'PhysicalLocation.dart';
import 'Road.dart';
import 'TownGenome.dart';
import 'TrailLocation.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';

//A town has a list of npcs, a pop up when entering the town
//and a list of 'dialogue' options talk/trade/travel/hunt
//a town is also not parallax
//but might have gently wobbling mist (like hunting?)
//IMPORTANT  predesigned towns (besides secret ones) don't show up at all in the early or mid game
//only their remixes do because of what fenrir did
class Town extends PhysicalLocation {
    static String INSERTNAMEHERE = "INSERTNAMEHERE";
    //TODO load from localStorage
    static List<Town> cachedTowns = [];
    static Town voidTown;
    static int maxTowns = 85; //TODO configure this.
    static int minTowns = 13; //just long enough that you don't notice at first what's going on.
    int seed = 0;
    TownGenome genome;
    //TODO store this in json
    static int nextTownSeed = 0;
    Random rand = new Random();
    int numTrees = 3;
    String name = "Landing Site";
    Element travelContainer;
    int playListIndex = 0;
    bool firstTime = true;

    //TODO towns have traits that contribute introductionText and graphics and the kinds of events they have???

    //TODO a road can spawn a trail if you choose to travel down it
    List<Road> roads = new List<Road>();
    //what text displays when you show up in a town.
    //think about fallen london
    String introductionText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed lobortis in purus non egestas. Aliquam erat volutpat. Aenean luctus tellus purus, non ultrices augue sagittis ut. Morbi ac luctus mauris, blandit euismod magna. Sed mauris nisi, feugiat eu accumsan sit amet, elementum eget orci. Nullam vel magna at leo feugiat sagittis. Praesent convallis vel lectus et convallis. Cras vel imperdiet eros. Sed interdum efficitur malesuada. Morbi iaculis ex dolor, sed rutrum eros malesuada a. Proin vel ligula id mi euismod vestibulum ac non augue. Praesent aliquam dui vel neque vehicula feugiat.";
    Element flavorTextElement;
    List<StaticLayer> layers = new List<StaticLayer>();
    Element parent;

    //who is in this town right now?
    List<LOMATNPC> npcs = new List<LOMATNPC>();
    WeightedList<RoadEvent> get events => genome.events;

    //this should only be called by something async so it can initGenome correctly
  Town.dontevercallthisblindly(String this.name, List<LOMATNPC> this.npcs, PhysicalLocation prev, TownGenome this.genome) : super(prev) {
      npcs.forEach((LOMATNPC npc) => npc.currentTown = this);
      seed = nextTownSeed;
      nextTownSeed ++;
      cachedTowns.add(this);
  }

  List<Town> get neighbors {
    final List<Town> ret = new List<Town>();
    //couldn't get map to work how i wanted, this is easier fo rnow
      for(Road r in roads) {
        ret.add(r.destinationTown);
      }
      return ret;

  }

  //bye bye little butterfly
  void npcLeaves(LOMATNPC npc, bool recruited) {
        npcs.remove(npc);
        npc.currentTown = null;
       if(!recruited) {
           Game.instance.wanderingNPCs.add(npc);
       }
  }


    void testFenrir() {
        layers.add(new StaticLayer("images/Enemies/FenrirBottom.gif", this, 1));
        layers.add(new StaticLayer("images/Enemies/FenrirMid.gif", this, 1,true));
        layers.add(new StaticLayer("images/Enemies/FenrirTop.gif", this, 1));

    }


    Future<void> initGenome() async{
    if(genome == null) {
        //oh no the genome has async elements
        genome = new TownGenome("$name",new Random(seed), new Map<String, String>() );
        await genome.init("town wants to init a new genome");
    }else {
    }
    proceduralIntroInit("genome init");

  }

  String proceduralIntroInit(String reason) {
      introductionText = "${genome.startText}<br><Br>${genome.middleText}<br><br>${genome.endText}";
  }



  @override
  void init() {
      rand.setSeed(name.length);
      drawTown();
        dynamic ss;
      ss =parent.onClick.listen((Event e)
      {
          dismissFlavorText();
          ss.cancel();
      });
      showFlavorText();
      menu = new MenuHolder(parent,this);
      createMenuItems();
  }

  void drawTown() {
      layers.add(new StaticLayer(genome.simpleGenes[TownGenome.BGIMAGEKEY], this, 1));
      layers.add(new StaticLayer(genome.simpleGenes[TownGenome.GROUNDKEY], this, 1));
      layers.add(new StaticLayer(genome.simpleGenes[TownGenome.MIDGROUNDKEY], this, 1));
      layers.add(new StaticLayer(genome.simpleGenes[TownGenome.FOREGROUNDKEY], this, 1));
      if(this == voidTown) {
          Game.instance.gameStats.visitAGoodBoi();
          testFenrir();
      }
  }

   String get bg {
      return genome.simpleGenes[TownGenome.BGIMAGEKEY];
   }


  @override
  void teardown() {
      super.teardown();
      Fenrir.onScreen = false;
      List<LOMATNPC> tmp = new List.from(npcs);
      tmp.forEach((LOMATNPC npc) => npcLeaves(npc, false));
      SoundControl.instance.stopMusic();
      if(travelContainer != null) travelContainer.remove();
  }

  Future<Null> scrambleRoads() async {
        roads.clear();
        roads = await Road.spawnRandomRoadsForTown(this);

  }

  @override
  Future displayOnScreen(Element div) async {
      if(this != voidTown) {
          npcs = await Game.instance.findWanderingNPCS();
          if(genome.background.contains("5.png")) {
              LOMATNPC scumbag = Game.instance.findLilScumbag();
              if (scumbag != null) {
                  npcs.add(scumbag);
              }
          }
      }
      print("wandering npcs for $name = $npcs");

      if(rand.nextDouble()>0.95){ //yn shows up 5% of the time.
          npcs.add(NPCFactory.yn(rand)); //yn only exists if the town is a real place
      }
      npcs.forEach((LOMATNPC npc) => npc.currentTown = this);
      roads = await Road.spawnRandomRoadsForTown(this);

      super.displayOnScreen(div);
      Element labelElement = new DivElement()..text = "$name"..classes.add("townLable");
      container.append(labelElement);

      firstTime = false;
      setNPCGoals();
  }

  //in theory an npc could accidentally be recruited befor they have a destination?
    //probably should have a thing where if town name is null, just let them off at next stop?
  Future<Null> setNPCGoals() async {
      npcs.forEach((LOMATNPC npc) async {
            Town town = rand.pickFrom(cachedTowns);
            if(town == this) {
                town = await makeBaby();
            }
            npc.goalTownName = town.name;
      });
  }

  void startPlayingMusic([bool firstTime=false]) {
      String next = nextSong;
      if(firstTime) {
        SoundControl.instance.scaleUpVolume();
      }
      SoundControl.instance.playMusicList(next, startPlayingMusic);
  }

  static bool get canMakeTown => cachedTowns.length < minTowns;
  List<Town> get allCacheButMe {
      List<Town> ret = new List<Town>.from(cachedTowns);
          ret.remove(this);
          //print("all cache but me is ${ret.length} long");
      return ret;
  }

  bool get otherTownsExist => allCacheButMe.length >1;

  //if there is room in the cache, 30% chance of making a child
    //otherwise 30% chance of it being pulled from somewhere before
  Future<Town> makeBaby([bool forceScramble = false]) async {
      //can't do this if i'm the only existin gtown. cant do it over max.
      if(forceScramble) {
          return rand.pickFrom(allCacheButMe);
      }else if(otherTownsExist && canMakeTown && rand.nextDouble() > 0.45) {
          Town ret = rand.pickFrom(allCacheButMe);
          return ret;
      }else {
          return await spawnNewBaby();
      }

  }

  Future<Town> spawnNewBaby() async {
    Town coparentSource = rand.pickFrom(cachedTowns);
    TownGenome coparent = null;
    if (coparentSource != null) {
        coparent = coparentSource.genome;
    }
    Town town = new Town.dontevercallthisblindly(
        await generateProceduralName(nextTownSeed), npcs, null,
        await genome.breed(coparent, rand));
    await town.initGenome();
    town.proceduralIntroInit("spawn new baby");
    return town;


  }

  String get nextSong {
      if(playListIndex >= genome.playListLength-1) {
          playListIndex = 0;
      }
      String ret =  genome.playList[playListIndex];
      //print("playListINdex is ${playListIndex} and i'm returning ${ret}");
      playListIndex ++;
      return ret;
  }

  static Future<List<Town>> makeAdjacentTowns(Random rand,Town town) async {
      //TODO pull from pool of special towns, already generated towns and new towns (without going over 85)
      int adjAmount = rand.nextInt(4)+1;
      List<Town> ret = new List<Town>();
      for(int i = 0; i<adjAmount; i++) {
          Town baby = await town.makeBaby();
          ret.add(baby);
      }
      return ret;
  }

  static Future<Town> generateProceduralTown(Random rand) async {
      Town town = new Town.dontevercallthisblindly(await generateProceduralName(nextTownSeed), <LOMATNPC>[],null,null);
      await town.initGenome();
      return town;
  }

  //fenrir is in the void
  static void initVoidTown() async {
      window.console.warn(
          "getting a void town, this is probably a problem");
      Map<String, String> simpleGenes = new Map<String, String>();
      simpleGenes[TownGenome.BGIMAGEKEY] = "${TownGenome.backgroundBase}/0.png";
      simpleGenes[TownGenome.GROUNDKEY] = "${TownGenome.groundBase}/3.png";
      simpleGenes[TownGenome.MIDGROUNDKEY] = "${TownGenome.midgroundBase}/0.png";
      simpleGenes[TownGenome.FOREGROUNDKEY] = "${TownGenome.foregroundBase}/0.png";
      simpleGenes[TownGenome.STARTTEXT] = "You arrive in INSERTNAMEHERE.";
      simpleGenes[TownGenome.MIDDLETEXT] = "You are not supposed to be here.";
      simpleGenes[TownGenome.ENDTEXT] = "You feel the presence of FENRIR.";
      simpleGenes[TownGenome.STARTSONG1] = "wind0";
      simpleGenes[TownGenome.STARTSONG2] = "wind1";
      simpleGenes[TownGenome.MIDDLESONG1] =  "wind2";
      simpleGenes[TownGenome.MIDDLESONG2] =  "wind3";
      simpleGenes[TownGenome.ENDSONG1] =  "wind4";
      simpleGenes[TownGenome.ENDSONG2] =  "wind2";
      TownGenome ret = new TownGenome("void town",new Random(13), simpleGenes);
      ;

      voidTown = new Town.dontevercallthisblindly(
          "The Void", [], null, ret)
          ..introductionText = "You arrive in INSERTNAMEHERE. You are not supposed to be here. You feel the presence of FENRIR.";
      await voidTown.initGenome(); //in theory this not being awaited means the void town might crash
      Town.cachedTowns.remove(voidTown);
  }

  @override
  String toString() {
    return "$name";
  }

  static Future<String> generateProceduralName(nextSeed ) async {
      TextEngine textEngine = new TextEngine(nextSeed);
      await textEngine.loadList("towns");
      String name = textEngine.phrase("TownNames");
      ReCase rc = new ReCase(name);
      name = rc.titleCase;
      return name;
  }


  static Future<List<LOMATNPC>> generateProceduralNPCs() async {
      List<LOMATNPC> ret = new List<LOMATNPC>();
      int npcAmount = new Random(nextTownSeed).nextInt(5)+1;
      for(int i = 0; i<npcAmount; i++) {
          //should at least mean adjacent towns don't have blatant repetition, town 3 has 3*1+1, 3*2+2, while 4 has 4*1+1,4*2+2
          //if no multiplication it would be 3,4,5 and then 4,5,6, so 2 incommon (assuming 3 npcs in each town)
          ret.add(await LOMATNPC.generateRandomNPC((nextTownSeed*i)+i));
      }
      return ret;
  }


  void createMenuItems() {
      menu.addTalk();
     // menu.addTrade();
      menu.addTravel();
      menu.addVoidTravel();
      menu.addBotButton();
      menu.addHunt();
  }

  void replaceTemplateText() {
      introductionText = introductionText.replaceAll(INSERTNAMEHERE,"$name");
  }

  void showFlavorText() {
        replaceTemplateText();
        flavorTextElement = new DivElement();
        flavorTextElement.classes.add("flavorText");
        String before = "";
        if(firstTime == false) {
            before = "<Br><br>You could swear you have been here before.";
        }

        List<LOMATNPC> arrivingNPCs = Game.instance.processArrivingParty(this);
        arrivingNPCs.forEach((LOMATNPC npc) {
            before = "$before <br> ${npc.leavingMessage} ${npc.name} leaves the party with a dejected SQWAWK!!!!!";
        });
        if(npcs.length >0) {
            before = "$before <br> In the distance, you see, ${npcs.join(",")}";
        }

        flavorTextElement.setInnerHtml("$introductionText$before");
        CipherEngine.applyRandom(flavorTextElement,Game.instance.amagalmatesMode);
        container.append(flavorTextElement);
  }



  void dismissFlavorText() {
      //auto play not allowed but we can try cuz this might not be first screen
      startPlayingMusic(true);
      flavorTextElement.remove();
      if(this == Town.voidTown) {
          if(Game.instance.amalgmationTime()) {
              Fenrir.amaglamationMode(querySelector("body"));
          }else{
              Fenrir.onScreen = true;
              Fenrir.wakeUP(container);
          }
      }
  }

    void doTalky() {
        //window.alert("gonna find an npc to talk to for town $name");
        if(npcs.isNotEmpty) {
            Game.instance.popupTalkySection(rand.pickFrom(npcs), container);
        }else {
            //print("trying to do talk but no one came");
            Game.instance.popup("But no one came...");
        }
    }

    void doHunt() {
        teardown();
        //new screen
        new HuntingGrounds(this)..displayOnScreen(parent);


    }

    void doTravel() {
        //new screen
        travelContainer = new DivElement()..classes.add("travelPopup");
        travelContainer.appendHtml("<h2>Travel To Neighboring City:</h2>");
        parent.append(travelContainer);
        travelContainer.onClick.listen((Event e) {
            travelContainer.remove();
        });
        //if  clicked, will handle loading trail
        roads.forEach((Road road) {
            road.displayOption(this,parent,travelContainer);
        });
        Road.shitGoBack(travelContainer);
    }
}