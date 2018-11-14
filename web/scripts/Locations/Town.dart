import '../NPCs/LOMATNPC.dart';
import '../Screens/TalkyScreen.dart';
import 'HuntingGrounds.dart';
import 'Layers/ProceduralLayer.dart';
import 'Layers/StaticLayer.dart';
import 'MenuItems/MenuHolder.dart';
import 'MenuItems/Talk.dart';
import 'PhysicalLocation.dart';
import 'Road.dart';
import 'Trail.dart';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';

//A town has a list of npcs, a pop up when entering the town
//and a list of 'dialogue' options talk/trade/travel/hunt
//a town is also not parallax
//but might have gently wobbling mist (like hunting?)

class Town extends PhysicalLocation {
    static String INSERTNAMEHERE = "INSERTNAMEHERE";
    //TODO store this in json
    static int nextTownSeed = 0;
    Random rand = new Random();
    int numTrees = 3;
    String name = "city2";



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

  Town(String this.name, String this.introductionText, List<LOMATNPC> this.npcs, PhysicalLocation prev) : super(prev);


  @override
  void init() {
      rand.setSeed(name.length);
      layers.add(new StaticLayer("images/BGs/SimpleSnowyPlainsLomat.png", this, 1));
      layers.add(new StaticLayer("images/BGs/${name}.png", this, 1));
      parent.onClick.listen((Event e)
      {
          dismissFlavorText();
      });
      showFlavorText();
      menu = new MenuHolder(parent,this);
      createMenuItems();
  }

  @override
  void displayOnScreen(Element div) {
      roads = Road.spawnRandomRoadsForTown(this);
      super.displayOnScreen(div);
  }

  static List<Town> makeAdjacentTowns() {
      //TODO pull from pool of special towns, already generated towns and new towns (without going over 85)
      int adjAmount = new Random().nextInt(4)+1;
      List<Town> ret = new List<Town>();
      for(int i = 0; i<adjAmount; i++) {
          ret.add(generateProceduralTown());
      }
      return ret;
  }

  static Town generateProceduralTown() {
      Town town = new Town(generateProceduralName(),generateProceduralIntroduction(), generateProceduralNPCs(),null);
      return town;
  }

  //should never spawn, technically
  static Town getVoidTown() {
      return new Town("The Void","You arrive in INSERTNAMEHERE. You are not supposed to be here.",[],null);
  }

  @override
  String toString() {
    return "$name";
  }

  static String generateProceduralName() {
      List<String> bullshitNamesPLZReplaceWithTextEngine = <String>["Absolute","Utter","Total","Complete","Incredible"];
      List<String> bullshitNamesPLZReplaceWithTextEngine2 = <String>["Bullshit","Shit","Dumbass","Dunkass","Crap"];
      return "${new Random(nextTownSeed).pickFrom(bullshitNamesPLZReplaceWithTextEngine)} ${new Random().pickFrom(bullshitNamesPLZReplaceWithTextEngine2)}" ;
  }

  static String generateProceduralIntroduction() {
      List<String> bullshitNamesPLZReplaceWithTextEngine = <String>["You arrive in INSERTNAMEHERE.","Exhausted, you arrive in INSERTNAMEHERE.","You stroll into INSERTNAMEHERE."];
      List<String> bullshitNamesPLZReplaceWithTextEngine2 = <String>["It's a procedural placeholder and is kinda bullshit.","It's really kind of lame.","There's nothing to do here."];
      return "${new Random(nextTownSeed).pickFrom(bullshitNamesPLZReplaceWithTextEngine)} ${new Random().pickFrom(bullshitNamesPLZReplaceWithTextEngine2)}" ;
  }

  static List<LOMATNPC> generateProceduralNPCs() {
      List<LOMATNPC> ret = new List<LOMATNPC>();
      int npcAmount = new Random(nextTownSeed).nextInt(5)+1;
      for(int i = 0; i<npcAmount; i++) {
          //should at least mean adjacent towns don't have blatant repetition, town 3 has 3*1+1, 3*2+2, while 4 has 4*1+1,4*2+2
          //if no multiplication it would be 3,4,5 and then 4,5,6, so 2 incommon (assuming 3 npcs in each town)
          ret.add(LOMATNPC.generateRandomNPC((nextTownSeed*i)+i));
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
        flavorTextElement.setInnerHtml(introductionText);
        container.append(flavorTextElement);
  }

  void dismissFlavorText() {
      flavorTextElement.remove();
  }

    void doTalky() {
        //window.alert("gonna find an npc to talk to for town $name");
        TalkyScreen screen = new TalkyScreen(rand.pickFrom(npcs), container);
    }

    void doHunt() {
        container.remove();
        menu.teardown();
        //new screen
        new HuntingGrounds(this)..displayOnScreen(parent);


    }

    void doTravel() {
        container.remove();
        menu.teardown();
        //new screen
        //TODO display popup of towns you can travel to
        window.alert("adjacent towns are: $roads ");
        new Trail(this)..displayOnScreen(parent);

    }
}