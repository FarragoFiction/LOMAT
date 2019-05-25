import 'dart:convert';

import 'package:CommonLib/Compression.dart';
import 'package:TextEngine/TextEngine.dart';

import '../AnimationObject.dart';
import '../Game.dart';
import '../Locations/Road.dart';
import '../Locations/Town.dart';
import '../Sections/LOMATSection.dart';
import '../Sections/PartySection.dart';
import '../SoundControl.dart';
import '../Triggers/FundsTrigger.dart';
import 'Disease.dart';
import 'NonGullLOMATNPC.dart';
import 'TalkyEnd.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'TalkyQuestion.dart';
import 'TalkyRecruit.dart';
import 'TalkyResponse.dart';
import 'Tombstone.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:CommonLib/Utility.dart';

class LOMATNPC {
    //TODO have town they want to go to, have their recruit text mention it. maybe can mention CURRENT_NEAREST_TOWN or GOAL_TOWN
    //TODO most kleptomaniac birds, have them swipe shit out of your inventory as an effect

    String name;
    Town currentTown; //so i can remove them from it when they get recruited. or the town is destroyed. ;)
    String leavingMessage = " TODO make sure each NPC has a custom leaving message.";
    GullAnimation animation;
    static String labelPattern = ":___ ";


    SinglePartyMember myStatsView;
    String causeOfDeath = "absolutely nothing";
    int _hp = 85;
    //if its null its good
    //make sure this goes into the json yo
    List<Disease> diseases =  new List<Disease>();

    int get hp => _hp;

    set hp(int value) {
        _hp = value;
        if(myStatsView != null) {
            myStatsView.sync();
        }
    }
    void diseaseTick(Road road) {
        new List<Disease>.from(diseases).forEach((Disease d) {
            //TODO have modifiers based on road pace or something
            d.tick(this, road, 1.0, 1.0);
        });
    }

    @override
    String toString() {
        return name;
    }

    String get diseasePhrase {
        if(diseases.isEmpty) return "None";
        return diseases.map((d) => d.name).toList().join(",");
    }
    String get healthPhrase {
        if(hp >= 85) {
            return "Energetic";
        }else if (hp > 50) {
            return "Chipper";
        }else if (hp > 17) {
            return "Persevering";
        }else if(hp > 0) {
            return "Listliss";
        }else {
            return "Probably Dead";
        }
    }

    //TODO maybe an unanimated one for 'dead'
    int get emotionForCurrentHealth {
        if(hp >= 66) {
            return TalkyItem.HAPPY;
        }else if (hp > 33) {
            return TalkyItem.NEUTRAL;
        }else {
            return TalkyItem.SAD;
        }
    }
    //where are they trying to get to?
    String goalTownName;
    DivElement div;
    //TODO add all the shit they'll need as party members, maybe in a sub class (since not all townsfolk are potential party members)
    //health, hunger, etc.
    TalkyLevel talkyLevel;
    TalkyEnd talkyEnd;

    LOMATNPC(String this.name,TalkyLevel this.talkyLevel, GullAnimation this.animation ) {
    }

    static LOMATNPC loadFromDataString(String dataString) {
        return loadFromJSON(LZString.decompressFromEncodedURIComponent(removeLabelFromString(dataString)));
    }

    static LOMATNPC loadFromJSON(String jsonString) {
        print("the uncompressed string is ${jsonString}");
        JsonHandler json = new JsonHandler(jsonDecode(jsonString));
        LOMATNPC ret = LOMATNPC(json.getValue("name"), null, null);
        ret.leavingMessage = json.getValue("leavingMessage");
        ret.causeOfDeath = json.getValue("causeOfDeath");
        ret.hp = json.getValue("hp");
        //TODO serialize diseases
        ret.talkyLevel = TalkyLevel.loadFromJSON(ret,new JsonHandler(json.getValue("talkyLevel")));
        //TODO serialize animation
        //TODO encode this to LZ or some shit.

        return ret;
    }

    static String removeLabelFromString(String ds) {
        try {
            ds = Uri.decodeQueryComponent(ds); //get rid of any url encoding that might exist
        }catch(error, trace){
            //print("couldn't decode query component, probably because doll name had a % in $ds . $error $trace");
        }
        List<String> parts = ds.split("$labelPattern");
        if(parts.length == 1) {
            return parts[0];
        }else {
            return parts[1];
        }
    }



    //not called for save data, just for form shit and loading
    String toDataString() {
        return  "$name$labelPattern${LZString.compressToEncodedURIComponent(jsonEncode(toJSON()))}";
    }

    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = new Map<dynamic, dynamic>();
        ret["name"] = name;
        ret ["leavingMessage"] = leavingMessage;
        ret["causeOfDeath"] = causeOfDeath;
        ret["hp"] = hp;
        //TODO serialize diseases
        //TODO serialize talky shit
        ret["talkyLevel"] = talkyLevel.toJSON();
        //TODO serialize animation
        //TODO encode this to LZ or some shit.
        return ret;
    }

    void removeDisease(Disease disease) {
        diseases.remove(disease);
        myStatsView.sync();
        DivElement container = new DivElement()..classes.add("event");
        //animation or displaying a grave stone or whatever.
        //don't append to the road cuz things like deaths will hide it and then you wont see this
        Game.instance.container.append(container);

        Element titleElement = new DivElement();
        titleElement.setInnerHtml("<h2>${name} is cured!</h2>");
        container.append(titleElement);
        Element flavorTextElement = new DivElement();
        flavorTextElement.setInnerHtml("$name no longer has ${disease.name}! Praise the Sun Swallower!");

        container.append(flavorTextElement);
        SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");

        Game.instance.container.onClick.listen((Event e)
        {
            container.remove();
        });
    }

    void addDisease(Disease disease) {
        diseases.add(disease);
        myStatsView.sync();
    }

    //takes in a road becaue tombstones go on roads
    void die(String cod, Road road) {
        causeOfDeath = cod;
        hp = -1;
        //okay what needs to happen here is the road needs to plzStopKThanxBai and then
        //a tombstone is created and added to the game list while the consort is removed from the party (added to the tombstone)
        //and also the road div gets hidden and the builder gets created
        //there should be a button on the builder to tear down the builder, and give control back to the road
        //(as well as rendering the mini tombstone on the road)
        road.stop(); //you can turn this on again later
        //it LOOKS like its still going, but the progresion is turned off which is what matters
        //TODO i need to hide the trail when the road stops
        //TODO i need to show the trail when the road starts
        //TODO need to display the tombstone and shove the consort into it
        Tombstone grave = new Tombstone();
        grave.npc = this;
        Game.instance.eject(this);
        SoundControl.instance.playSoundEffect("Dead_jingle_bells");
        grave.drawSelf(Game.instance.container, road);
    }

    void displayDialogue(Element container, LOMATSection screen) {
        talkyLevel.screen = screen;
        if(talkyEnd == null) talkyEnd = new TalkyEnd(talkyLevel);

        div = new DivElement()..classes.add("dialogueContainer");
        DivElement nameElement = new DivElement()..text = "$name"..classes.add("dialogueName");
        container.append(nameElement);
        container.append(animation.element);
        animation.addClassToCanvas("npcImage");
        container.append(div);
        talkyLevel.display(div);
    }




    void emote(int emotion) {
       animation.frameRateInMS = emotion;
    }

    static String seagullQuirk(String text) {
        Random rand = new Random();
        rand.nextInt();
        text = text.toUpperCase();

        if(rand.nextDouble() > 0.6) {
            text = "SQWAWK!!!!! $text";
        }else if(rand.nextBool()) {
            text = "$text SQWAWK!!!!!";
        }
        return text;

    }

    static Future<String> randomName(int seed) async {
        Random rand = new Random(seed);
        TextEngine textEngine = new TextEngine(rand.nextInt());
        await textEngine.loadList("names");
        return textEngine.phrase("wigglername_all");
    }

    //TODO not gonna use this for the real game or anything, but good for testing
    static Future<LOMATNPC> generateRandomNPC(int seed) async {
        Random rand = new Random(seed);
        List<TalkyItem> talkyItems = new List<TalkyItem>();


        TalkyLevel level = new TalkyLevel(talkyItems,null);
        String name = await randomName(seed);
        LOMATNPC testNPC = new LOMATNPC(name, level, GullAnimation.randomAnimation);

        List<int> emotions = <int>[TalkyItem.HAPPY, TalkyItem.NEUTRAL, TalkyItem.SAD];
        //so happy past jr made quirks automatic
        List<String> gameQuips = <String>["This game is going to be based on the retro game 'Oregon Trail'.","This game will involve ferrying the 'souls of the dead' to their final resting place.","This game is the Land of Mists and Trails.", "The Titan is a real jerk."];
        List<String> townQuips = <String>["This town is a default test town scribbled by JR.","This town is snowy, and has some huge trees in it.","This town will probably be redrawn by an actual artist at some point.","Everyone in this town can't figure out how to leave it."];
        List<String> meQuips = <String>["You are the Guide of Void. Or was it dark?????","You are the prophesied Hero who will guide the lost souls of this land to their final resting place.","Your horns are very nice."];
        List<String> youQuips = <String>["I'm not DRESSED like a ghost, I AM a ghost.", "Behold my robes y/n?", "Because I AM a ghost!", "I am a lost soul!"];
        List<String> recruitQuips = <String>["Let me just grab my bags!","Hell yes!","Would I!?"];

        TalkyResponse tr = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(gameQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question1 = new TalkyQuestion("What can you tell me about this game?",tr,level);

        TalkyResponse tr2 = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(townQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question2 = new TalkyQuestion("What can you tell me about this town?",tr2,level);
        question2.addTrigger(new FundsTrigger()..importantInt = 100); //means town should happen at first

        TalkyLevel level2 = new TalkyLevel(talkyItems,null);
        TalkyResponse ghost2 = new TalkyResponse(testNPC,<TalkyItem>[],seagullQuirk("Yes. Exactly like that. I'm dead."), rand.pickFrom(emotions),null);
        TalkyQuestion questionGhost2 = new TalkyQuestion("Wait, like, you're dead?",ghost2,level2);
        questionGhost2.addTrigger(new FundsTrigger()..importantInt = 110..invert=true); //means ghost shouldn't happen at first


        TalkyResponse trghost = new TalkyResponse(testNPC,<TalkyItem>[questionGhost2],seagullQuirk(rand.pickFrom(youQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion questionghost = new TalkyQuestion("Why are you dressed like a ghost?",trghost,level);
        questionghost.addTrigger(new FundsTrigger()..importantInt = 100..invert=true); //means ghost shouldn't happen at first

        TalkyResponse tr3 = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(meQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question3 = new TalkyQuestion("What can you tell me about me?",tr3,level);

        TalkyResponse tr4 = new TalkyResponse(testNPC,<TalkyItem>[new TalkyRecruit(testNPC,null)],seagullQuirk(rand.pickFrom(recruitQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question4 = new TalkyQuestion("Do you want to join me?",tr4,level);

        List<TalkyItem> talkyItems2 = new List<TalkyItem>();


        querySelector("#output").innerHtml = ("${testNPC.toDataString()}");

        return testNPC;
    }

}


abstract class NPCFactory {

    //TODO eventaully all this is serialized.
    static LOMATNPC jrTest() {
        List<TalkyItem> talkyItems = new List<TalkyItem>();
        TalkyLevel level = new TalkyLevel(talkyItems,null);
        LOMATNPC testNPC = new LOMATNPC("VOID GULL",level, new GullAnimation(1,3, GullAnimation.voidPalette));

        TalkyResponse tr = new TalkyResponse(testNPC,new List<TalkyItem>(),LOMATNPC.seagullQuirk("Hello, I am a set seagull and definitely not a void glitch."), 3,null);
        TalkyQuestion question1 = new TalkyQuestion("Wait you seem different...",tr,level);
        return testNPC;
    }

    static stimpyTigger() {
        String dataString = "Stimpy Tigger:___ N4IgdghgtgpiBcIDKAXAllADgTwAQBU0BzImAJxABoQAbGCANzTCIFkYBnDiUhEAgPIARAbigQA1jFwcArmWn0AxgAtcAOQAKAYVwqIHXBFxLZHFAHsouOo2ZExnbqQB0VEEohmYAgGZD6FBU+CAAjDgsaWRQYGjwwCyD7dxVMBAAOAFZqFAgaCWwAGRgGWIRQXPzsAEkYqA4EAG1QABM0DkwaCGx8GAAPFD4AdX0UEwgwXGwLWVwYmhpHI1CZsaTDImgYAH53FDJiUjIG+EaAXRzsTDhEfDyCgEVZTnQLMHcFDreOG9b2zu6vQGfCQDyGAEEhgBpACEcLhBAAEgBRAjVfDg9S4apIXDg3AAJWR4MKuAAUsiCVC3DkDiRyCdzjl7kUSmV4BUWbUYPUmmcAL6Xa58O5VAmcTDfODUAwRJRoCAxFrIqCJNBvBAARgADNr+YK-h0uj1+oNECNFeNJtNZvNFrBlqs5ip2nMLAB3MC7WmHBlNUBdULskDg1WyMAoABi4ZaDWoGElZFyEaGFjILQQYFkC3jWDTyZQ1QjWt1-IuIBQVxuIFFj2e5nV72on0lYB+5RAbSNgNNIsROMEQyxA6Q6gEQwAmpQ8eohLhEeDcUgBKxUYiAKoAcVR+CJyNx1WH+BpFbpR0Z5cqBWKpRoHavNTqF8FFarIpZ4q+belIFlFnliowMqqqvO88A6nqBqdv8xpAmaIBDBAaAoNONBoFI042gA5AouAtPQLTeqevrHP6tBhMGoYzBG0ZgLG7gJvmEwoKm6aZtmNC5omBZFmamo6mWQrVrW2BPC8jYfBKUodl2AImsCiATvuLi4MiAAa4LaPghQTrghTVFCO4Lse2JYawuBCMSQgnvsJEXsyVQ3uynJVNyvKnAKQnvmKUnfu4f4AUqKpqhq8DpJBlCGnJcHDCoeAQLhNp4Z8PwtDY6HSMYRAqBY5hEbZ9KkacAYUXeiBUeGUYxnGICMUmzGsRm8BZjmtV5vVEa8SWeqXm+twsmJDYas2vnthy0HdvJ8GghC0Lwgi1RmRoAj4BZRJIEgyJzvphl4rgm6IgISD4NO1R4uZ+IHUdx57GefoeQ515smVLkFG5jJRbBvbmkhKHpRhUwzDh0j4RAhG3XZZGBpRYY0dVDHtQWjXsa1dU8cW4ECb1wr9VUg2gZJX5jZ9PYKSASlICp6madpuk7UZ4ImYt5mWeC1kQ4V9kViyTkvdzrlPnyL6VjjNYfqNP4BQqQUgRJYWQZ5r6iyJn6tu2MpcP+0tAcFBPgaWUGyV9ZMWmMnjWjMcyxPamUrNEjj5XdRVMkrwkDfWBMjUTvwTdF33IGCkKwvNuATgI654kSSKopoBICJoKJINUW3zpSohDIduBDNUhSkpu67VJZ0d6dduDLuuhS4gIkZIgOhSYnO+CiPgKLVASuCRoeJKEvu+CHpuuCaPX2jIjZTtcw+vP3lygsecLfViz53v+ZrgU67LoWagATBFJNTXwQgWIDszusxbq4AAVhYzAOxz558l5uN1uJw0gC20njUbpPTYHc0h0M4dChzmqDCR2kMHr8yereaeAseQfV9sbeC4olBkFkMhMBnMH6uz4ESbQBIC593wMiVgkkUFoJQOoLYIJ0BYDwIQQqIAyzz2VuLZeGs5Ta2AiFMC4V9QCn5EAA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    //TODO eventaully all this is serialized.
    static LOMATNPC lilscumbag() {
        List<TalkyItem> talkyItems = new List<TalkyItem>();
        TalkyLevel level = new TalkyLevel(talkyItems,null);
        NonGullLOMATNPC testNPC = new NonGullLOMATNPC("Lil Scumbag",level,new ImageElement(src: "images/Seagulls/Lil_Scumbag.png"));

        TalkyResponse tr = new TalkyResponse(testNPC,new List<TalkyItem>(),"Takes gargbag. Eat. Bai.", 3,null);
        TalkyQuestion question1 = new TalkyQuestion("Uh. Hello?",tr,level);

        return testNPC;
    }

    //TODO eventaully all this is serialized.
    static LOMATNPC loki() {
        List<TalkyItem> talkyItems = new List<TalkyItem>();
        TalkyLevel level = new TalkyLevel(talkyItems,null);
        NonGullLOMATNPC testNPC = new NonGullLOMATNPC("Loki",level,new ImageElement(src: "images/Seagulls/loki2.png"));

        TalkyResponse tr = new TalkyResponse(testNPC,new List<TalkyItem>(),"A completely normal seagull, obviously!", 3,null);
        TalkyQuestion question1 = new TalkyQuestion("Uh. What are you?",tr,level);

        return testNPC;
    }

    //TODO eventaully all this is serialized.
    static LOMATNPC yn() {
        List<TalkyItem> talkyItems = new List<TalkyItem>();
        TalkyLevel level = new TalkyLevel(talkyItems,null);
        NonGullLOMATNPC testNPC = new NonGullLOMATNPC("YN",level,new ImageElement(src: "images/Seagulls/dainsleif.png"));

        TalkyResponse tr = new TalkyResponse(testNPC,new List<TalkyItem>(),"???", 3,null);
        TalkyQuestion question1 = new TalkyQuestion("???",tr,level);

        return testNPC;
    }

    //TODO eventaully all this is serialized.
    static LOMATNPC grim() {
        List<TalkyItem> talkyItems = new List<TalkyItem>();
        TalkyLevel level = new TalkyLevel(talkyItems,null);
        NonGullLOMATNPC testNPC = new NonGullLOMATNPC("Grim",level,new ImageElement(src: "images/Seagulls/grim_reaper.png"));

        TalkyResponse tr = new TalkyResponse(testNPC,new List<TalkyItem>(),"Yeah, but don't tell that one gull. She's freaking obsessed with me.", 3,null);
        TalkyQuestion question1 = new TalkyQuestion("Are you...the grim reaper?",tr,level);

        return testNPC;
    }
}
