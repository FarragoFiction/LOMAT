import '../Game.dart';
import '../NPCs/LOMATNPC.dart';
import '../Sections/TalkySection.dart';
import '../SoundControl.dart';
import 'Events/RoadEvent.dart';
import 'HuntingGrounds.dart';
import 'Layers/ProceduralLayer.dart';
import 'Layers/StaticLayer.dart';
import 'MenuItems/MenuHolder.dart';
import 'MenuItems/Talk.dart';
import 'PhysicalLocation.dart';
import 'Road.dart';
import 'TownGenome.dart';
import 'Trail.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';

//A town has a list of npcs, a pop up when entering the town
//and a list of 'dialogue' options talk/trade/travel/hunt
//a town is also not parallax
//but might have gently wobbling mist (like hunting?)

class Town extends PhysicalLocation {
    static String INSERTNAMEHERE = "INSERTNAMEHERE";
    //TODO load from localStorage
    static List<Town> cachedTowns = [];
    static int maxTowns = 85; //TODO configure this.
    static int minTowns = 13; //just long enough that you don't notice at first what's going on.
    int seed = 0;
    TownGenome genome;
    //TODO store this in json
    static int nextTownSeed = 0;
    Random rand = new Random();
    int numTrees = 3;
    String name = "city2";
    Element travelContainer;
    int playListIndex = 0;
    bool firstTime = true;

    //TODO towns have traits that contribute introductionText and graphics and the kinds of events they have???

    //TODO a road can spawn a trail if you choose to travel down it
    List<Road> roads = new List<Road>();
    //what text displays when you show up in a town.
    //think about fallen london
    String introductionText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed lobortis in purus non egestas. Aliquam erat volutpat. Aenean luctus tellus purus, non ultrices augue sagittis ut. Morbi ac luctus mauris, blandit euismod magna. Sed mauris nisi, feugiat eu accumsan sit amet, elementum eget orci. Nullam vel magna at leo feugiat sagittis. Praesent convallis vel lectus et convallis. Cras vel imperdiet eros. Sed interdum efficitur malesuada. Morbi iaculis ex dolor, sed rutrum eros malesuada a. Proin vel ligula id mi euismod vestibulum ac non augue. Praesent aliquam dui vel neque vehicula feugiat. <br><br>Praesent nec accumsan enim. Duis euismod, risus tincidunt efficitur vulputate, orci dui feugiat lorem, non pretium lorem erat sed odio. Quisque semper ipsum mauris, sit amet tincidunt tortor efficitur in. Donec ultricies nisl eget sapien posuere, vitae pellentesque elit mollis. Suspendisse vitae augue sapien. Vivamus cursus vehicula blandit. Sed eu sem ac nulla porttitor malesuada. Suspendisse et laoreet ipsum. In eget viverra magna, id dignissim est. Cras a augue blandit, fermentum justo ac, fermentum lectus.";
    Element flavorTextElement;
    List<StaticLayer> layers = new List<StaticLayer>();
    Element parent;

    //who is in this town right now?
    List<LOMATNPC> npcs = new List<LOMATNPC>();
    List<RoadEvent> get events => genome.events;

  Town(String this.name, List<LOMATNPC> this.npcs, PhysicalLocation prev, TownGenome this.genome) : super(prev) {
      print("passed in genome is $genome");
      seed = nextTownSeed;
      nextTownSeed ++;
      if(genome == null) {
          genome = new TownGenome(new Random(seed), null);
      }else {
        print("genome wasn't null for $name");
      }
      introductionText = "${genome.startText}<br><Br>${genome.middleText}<br><br>${genome.endText}";
      cachedTowns.add(this);
  }

  @override
  void init() {
      rand.setSeed(name.length);
      drawTown();

      parent.onClick.listen((Event e)
      {
          dismissFlavorText();
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
  }

   String get bg {
      return genome.simpleGenes[TownGenome.BGIMAGEKEY];
   }


  @override
  void teardown() {
      super.teardown();
      SoundControl.instance.stopMusic();
      if(travelContainer != null) travelContainer.remove();
  }

  @override
  Future displayOnScreen(Element div) async {

      roads = await Road.spawnRandomRoadsForTown(this);
      super.displayOnScreen(div);
      //auto play not allowed but we can try cuz this might not be first screen
      startPlayingMusic();
      container.onClick.listen((Event e)
      {
          //don't play more than once unless you came from a diff place
          if(!SoundControl.instance.musicPlaying && !SoundControl.instance.bgMusic.src.contains("Slice")) {
             startPlayingMusic();
          }
      });
      Element labelElement = new DivElement()..text = "$name"..classes.add("townLable");
      container.append(labelElement);
  }

  void startPlayingMusic() {
      SoundControl.instance.playMusicList(nextSong, startPlayingMusic);
  }

  //if there is room in the cache, 70% chance of making a child
    //otherwise 30% chance of it being batshit insane
  Future<Town> makeBaby() async {
      if(cachedTowns.length < minTowns ||(cachedTowns.length < maxTowns && rand.nextDouble()>0.7)) {
          Town coparentSource = rand.pickFrom(cachedTowns);
          TownGenome coparent = null;
          if(coparentSource != null) {
              coparent = coparentSource.genome;
          }
          List<LOMATNPC> npcs = await generateProceduralNPCs();

          return new Town(generateProceduralName(), npcs,null,genome.breed(coparent,rand));
      }else {
          Town ret = rand.pickFrom(cachedTowns);
          ret.firstTime = false;
          return ret;
      }
  }

  String get nextSong {
      if(playListIndex >= genome.playListLength-1) {
          playListIndex = 1;
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

  static Future<Town> generateProceduralTown(Random rand,Town town) async {
      List<LOMATNPC> npcs = await generateProceduralNPCs();
      return new Town(generateProceduralName(), npcs,null,null);
  }

  //should never spawn, technically
  static Town getVoidTown() {
      TownGenome ret = new TownGenome(new Random(13),null);
      ret.startText = "";
      ret.middleText = "";
      ret.endText = "";
      ret.playList = <String>["","","","","",""];
      ret.foreground = "${TownGenome.foregroundBase}/0.png";
      ret.midGround = "${TownGenome.midgroundBase}/0.png";
      ret.ground = "${TownGenome.groundBase}/0.png";
      ret.background = "${TownGenome.backgroundBase}/0.png";;
      return new Town("The Void",[],null,ret)..introductionText ="You arrive in INSERTNAMEHERE. You are not supposed to be here. You feel the presence of DENNIS.";
  }

  @override
  String toString() {
    return "$name";
  }

  static String generateProceduralName() {
      List<String> bullshitNamesPLZReplaceWithTextEngine = <String>["Pirate","Mining","Absolute","Utter","Total","Complete","Incredible","Viking","Seaside","Empty","Abandoned","Snake","Troll","Elf","Consort","Seagull","Ghost","Angry","Envious","Not-On-Main","Lazy","Greedy","Hungry","Prideful","Boasting"];
      List<String> bullshitNamesPLZReplaceWithTextEngine2 = <String>["Bullshit","Shit","Dumbass","Dunkass","Crap","Village","Burg","Town","City","Vista","Placeholder","Island"];
      return "${new Random(nextTownSeed).pickFrom(bullshitNamesPLZReplaceWithTextEngine)} ${new Random(nextTownSeed).pickFrom(bullshitNamesPLZReplaceWithTextEngine2)}" ;
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
      menu.addTrade();
      menu.addTravel();
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
        flavorTextElement.setInnerHtml("$introductionText$before");
        container.append(flavorTextElement);
  }

  void dismissFlavorText() {
      flavorTextElement.remove();
  }

    void doTalky() {
        //window.alert("gonna find an npc to talk to for town $name");
        Game.instance.popupTalkySection(rand.pickFrom(npcs), container);
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
        //if  clicked, will handle loading trail
        roads.forEach((Road road) {
            road.displayOption(this,parent,travelContainer);
        });
    }
}