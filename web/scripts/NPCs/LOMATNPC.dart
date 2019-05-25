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

    void loadJSON(JsonHandler json) {
        leavingMessage = json.getValue("leavingMessage");
        causeOfDeath = json.getValue("causeOfDeath");
        hp = json.getValue("hp");
        //TODO serialize diseases
        talkyLevel = TalkyLevel.loadFromJSON(this,new JsonHandler(json.getValue("talkyLevel")));
        //TODO
        //animation = GullAnimation.loadFromJSON();
    }

    static LOMATNPC loadFromJSON(String jsonString) {
        print("the uncompressed string is ${jsonString}");
        JsonHandler json = new JsonHandler(jsonDecode(jsonString));
        String type = json.getValue("type");
        LOMATNPC ret;
        if(type == "Gull") {
            ret = LOMATNPC(json.getValue("name"), null, null);
        }else {
            ret = NonGullLOMATNPC(json.getValue("name"), null, null);
        }
        ret.loadJSON(json);


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
        ret["type"] = "Gull";
        List<Map<dynamic, dynamic>> diseasesJson = new List<Map<dynamic,dynamic>>();
        diseases.forEach((Disease disease)=> diseasesJson.add(disease.toJSON()));
        ret ["diseases"] = diseasesJson;
        ret["talkyLevel"] = talkyLevel.toJSON();
        //TODO serialize animation
        ret["animation"] = animation.toJSON();
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
        String dataString = "Vice President Wario:___ N4IgdghgtgpiBcIBqBLAxjABABQE4wGcUATGMAF0wHUJcUB7EAGhABsYIA3FMAcwFlCBCLziJMAFQDyAESmYoEANZYCAV3yYOaABaYActgDCmHRAKYImNGoLl6UTOy49eCoSJgA6ZiDQRbGCkAMxkOch0EEAgAIwJ6VjVyGFYAT0wwegjXXx0ABwQADgBWFnJUvLEQAHE1VlZfcghWJVSAGRhOFIRQJpbUgElkqAIEAG1QYhQCPNYIVIkYAA9yKKozSn8wTFT6NUxk+vdLGL3KbIteaBgAfka6XlFcUfgxgF0yiqqJZtaARTUhHIDDAvnwM3oYAIYkm01m80WKyiEgAEgMAMqYaoAQX4AFFqAM2m1MAN9EgpG0kASAGJ4gBK9IAmmTqpIUQSAOToqQAVTamKkNPZBJkeOxMk5knkqLxA3pmBpZOxJPpePRElZODa2KMeJ8ZQeTxe7zKv3anW68F65qGMBG4zeAF9PpVkeb6YQ8pDob5zPE0CgIMliHioFkQQgAIwAJgADE6XbCZnMFstVoh1sHrBBtrt9odWMdYmcDjppgd6AB3MB3Q0oR4wZ7jUBzGJWkDY8NqCg0nvEUYsFBQb24JoUKj0XDEBBgOqsIcjqfj8gDCjRuMJj4gcpuxA-foAoGRljg71QmEgKYphHpqJ46nMqT6Alk9kY6VUfSYIzY-SciRFQGapeTVTA+UAlEpCoaVMDacVqVJCQvEwdE-iobEqAAaQAQjwvD7gbY1HTNfoOi6BprR3W1hhNZ1XW+D0vR9OAWH9ehA2DGBQ3DYFISKBMkyvOFU0RDMQBoFByCYJwUBUGT805TRSAgYg6x3I0mxNVtYg7Ls9l7ftBxAYdRxXSdp1nedFzM3NV3XeAoyjLcGPdQ9ATsE8QDPFiemEm80yRRA0Iw7D8LwzAmXVFC8QADV1CQ2iZOCBiwglUWxZDSU5fhMDFCUDQ0oitJI6iyMtSibX6O0HVeeidy+NzWk9CELz9AgAyDEMwwjfj4EKQSmGTeFAvE9Z0loLB80wYhwWhYhZJUSxMF4HR6DsdTyE05tXh09tKM7btDLAAdfFM5c7Ismd4DneobIuig1wzZyXIavcQAPf4PL40FT2YtqqOvEaxKiAAhPEoLaGRMH4ZL6SkcHMSZAB6fQblQ9DMNw8LCMbHbTTK1pyKtKrWhq7T-OBu9MwgKSZNYOSYAUvYlKwFS1Nx4jdrYXSDv0ntyD7E7jPOsdLqna7boXEylzFx6HKc17d0Y9zj34v7Wt9QGRNvIKQBCrHwpwyLoswOKEqSlK0vZTKUIGHK8vFGRCq24r8e3PoiYqvzPcGWjHRdN6Vea-7fTYjqOK67iep+gTE3q5WmtSFrzzD6II847reMjRz40TIbKdE6mJI2HM8z2A4UiLWATlLWBNu2ujXP3c0j089XvNDy8gaLvWmT5TBsTA2UsV5AYxXA4UKXHlCpAVDDMQGQCZCHrCbnX9eMdC7H8M5kq6tIr2KJ9mj7TowPE5b-oU988POq4njetBRzN3z4be-EmR6B2CuqzsytMAACt6A8HcA3N2Tcg5JzbrHDWqdu461GlEA2YVwqYA5MSE26IcJ73dofC0x8qK+3Ji2QuutxKejQLgNQUlwF40gZfEAaojD0jHpqCQeJ+AgCdAnRqV8Q6a1Yune+Wcn7RjzjwxMQA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    //TODO eventaully all this is serialized.
    static LOMATNPC lilscumbag() {
        /*
        List<TalkyItem> talkyItems = new List<TalkyItem>();
        TalkyLevel level = new TalkyLevel(talkyItems,null);
        NonGullLOMATNPC testNPC = new NonGullLOMATNPC("Lil Scumbag",level,new ImageElement(src: "images/Seagulls/Lil_Scumbag.png"));

        TalkyResponse tr = new TalkyResponse(testNPC,new List<TalkyItem>(),"Takes gargbag. Eat. Bai.", 3,null);
        TalkyQuestion question1 = new TalkyQuestion("Uh. Hello?",tr,level);
        return testNPC;*/
        String data = "Lil Scumbag:___ N4IgdghgtgpiBcIAyBLANgAgMoGMCuUARhAOYgA0IaMEAbimCQLIwDOrpciGAKgPIARPhigQA1jAys8AJ0k0cACwwA5AAoBhDIoisMEDPlYAXAPZQM1OgxIi2HEjAB0FEDgh5WMPgDMBNY0UEEAhCVlM0PGMYNABPDDBTQJtXRQAHBAAOAFZKY1i0rhAAflLXYwg0MVikGFoYhFAKqtiASWioVgQAbVAAExRWNLQIWJ4YAA9jYIBVRScMAAkYtFNi8pkUEkcZLvhugF08gqKeSuqARTw2YxRTMFc5IfuvRpABoZGxyenEM4k9CQIDISMQSAsAKIQYwLABCEBQLjym22MF2PSOIGa1Vq9TQb2xbQ6e0OAF9joVgmcWgAlNhpF5wSi6cI4FDQmB9CFQJJ3B7wADMpNJB3JIBQUBIWBkOGCimMxjS8AA9MrVu40IpTCZ4NkBQKAEwG5USzisZVYGgkPBoNDm1BoAD6uAIYKcaUYIFJQA";
        return LOMATNPC.loadFromDataString(data);
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
