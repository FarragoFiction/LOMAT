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

import 'YNMaker.dart';

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
        if(this is NonGullLOMATNPC) {
            return name;
        }else {
            return "Gull $name";
        }
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
        animation = GullAnimation.loadFromJSON(new JsonHandler(json.getValue("animation")));
    }

    static LOMATNPC loadFromJSON(String jsonString) {
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
        animation.keepLooping = false; //tear down
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
        Tombstone grave = new Tombstone(this);
        Game.instance.eject(this);
        SoundControl.instance.playSoundEffect("Dead_jingle_bells");
        grave.drawSelf(Game.instance.container, road,false);
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
        }else if(rand.nextDouble() > 0.9) {
            text = "$text ONLY YOU CAN PREVENT FOREST FIRES!!!!! SQWAWK!!!!!"; //sburbsim meme

        }
        return text;

    }

    static Future<String> randomName(int seed) async {
        Random rand = new Random(seed);
        TextEngine textEngine = new TextEngine(rand.nextInt());
        await textEngine.loadList("names");
        return textEngine.phrase("wigglername_all");
    }

    static Future<LOMATNPC> generateRandomNPC(int seed) async {
        print("spawning a random npc. bad. stop. not till fenrir");
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

    //TODO make sure seagulls can randomly talk about preventing forest fires.

    static LOMATNPC stimpyTigger() {
        String dataString = "Stimpy Tigger:___ N4IgdghgtgpiBcIDKAXAllADgTwAQBU0BzImAJxABoQAbGCANzTCIFkYBnDiUhEAgPIARAbigQA1jFwcArmWn0AxgAtcAOQAKAYVwqIHXBFxLZHFAHsouOo2ZExnbqQB0VEEohmYAgGZD6FBU+CAAjDgsaWRQYGjwwCyD7dxVMBAAOAFZqFGxMOEQAcVkaGncAEzQOemqOBABtAF0ciBoJbAAZGAZYhFAUVvaASRioOvh60EqOTBoIbHwYAA8UPgB1fRQTCDBcbAtZXBjSxyNQg62kwyJoGAB+dxQyYlIycaacvIKQfEHsAEVZJx0BYwO4FDNQdU+iBprN5osVnx8AAJACiBCG+AAgupcEMkLhsbgAEpo7EdXAAKTRJIA0i5cEh-mtsWs6QBCLlcx7PEjkd7NEADNqdbq9eD9P4jGBjBqNAC+n3yyL+JM4mChcGoBgiSjQEBi5TRUESaFBCAAjAAGa0KpVTKrwhbLVaIDaG7a7faHY40U5hC5HFRVI4WADuYAeOT5r3eoDmoQlIGxptkYBQADF0+U6tQMJqyAMM2sLGRyggwCUaPmsGXiyghhmrbaFULcirEL9RYDgeawdQIZqwNDJbCnXMXUjEMzWezuVyCCiCYI1niV0h1AI1gBNShE9RCXAo7GEpACVgYlEAVUKGPwZLRhKG6-wbhjLwF8paoq6PTKY4isMoyCkqwpfKqorqpCI7aiAuoWPqhowMapogmC8A2naDrjjMk6Im6IBrBAaAoPuNBoFI+4+gA5AouDlPQ5TRsKsZfhMCZhMmqYHBm2ZgLm7gFvWOwoKW5aVtWtaFg2TZupaNptsq3zdu0vbmP24IalqMJwvhrp8LObKcguuA7k+jJogAGti2j4B0O64B0Qx0veJ5vviNGsLgQjkkI76sZ+bzfsKfx-hKUqijKcoTIqymQe00HDtCOpcIhBpGiaZoWvA6TYZQjp4QiBnuioeAQPRPoMRC1TlDYlHSMYRAqBY5gsU8QXxrQXEASmaZ8TmeYgMJRaieJFbwFWpTSSJGZyS2drthBXZ-Op6FaTBo6Fc6BGGSyxkLhynneVu+A+WSSBIGiR7Oa5RK4IUKICEg+D7kMRLecSj3PW+vKdSFQFiv+MKA9FXV6cV05ESRZH1VRewHHR0iMRAzF-fywUcd1Sa9Tx6ZZoNQl1qNJZlhNU01sNxOyc2mGKUtnY-KtQIaRag7abBukTpDhFGfOpnmUglk2XZDlOS5bnYh5QxeT5fkBR1GOCj+7ThQBkXAbKoHxStUEcyl8FpUhmVoZpuXYXF4GM6p2BJTpqV6hlKFZetmGtjhENToRHpbJ43oHEcsT+rAZxBrA7VsZjHxWypzN9mzIBDjpY6e7tiA7gI15EmSS4YpoJICJo6JIEM13HrSohrE9uBrEMHSUoU15DL5udOT9TKZx0hICJmS4rh0uJHvgoiomiQwkrgmYvhSpJPvgL6FLgmgD9oaIK5Hyuhb+4rq1vmsxU0YEdrHeubXBCHG87ps5ZaABM+XbfpUNCBYCOHOGolhrgABWFjMI4Ed-qxR1kzHsLN1rszPlzIqXt1idyPEMDkdwmT7X5tydGcYAZhR3iDaUIEGiPx5nwdUSgyCyFIoApWANlogDJNoEkTd574DRKwEAbYj40JtnbTmDt0rIVQtlDCeV7SWx2BgQ0ZtQCbHULIKASYKDwGyCAc45RsAyLkeQBAAAWagmBWgwBQDEPghRMAcEzgIKAawYAfw6PgHcZASTpAYOkNY4YiAAC8kAkRRBAdIKhrzpAsNoHx6Q0AhLCb4gAzAAWm-lSIgABeBJbCFRAA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    static LOMATNPC rogerKoon() {
        String dataString = "Roger Koon:___ N4IgdghgtgpiBcIBKB7A5jATgAgNIpTBABoQAbGCANwEsw0BZGAZ2YgwRGwBUB5AEV7YoEANYxszAK6YJlAMYALbADkACgGFsiiM2wRs8qcwAuKKNgrU6aYSzYYAdCRDyIxmLwBm-SicWcEABGzChkUiYwZACe2GAo-jYuigAOCAAcAKykJtEpcIgA4lJkZC4AJjTMlNXMCADaALo5EGSi0QAyMFRRCKAmre0AkpFQdfD1oJXMKWQQ0dwwAB4mnADqOiaGEGDY0ShS2JGldvpBB1uJemjQMAD8LiaYNGgYmONNOXkFINyD0QBFKQsEw0QguWQzQjVPogaazeaLFacbgACSGAGVsIUAIIMACi2DWQw6HWwQxUADVeB1KYSAGL4pBIACaFMKPFRhIA5BjeABVDpY3j0zmE-j4nH8bk8IRo-FDJDYekUnFkpD4jHcdnYNQdHEafGObAYgFrHFrXAAQhtNsez1eWA+zRAAzanW6vXg-X+IxgYwajQAvl98ij-kgWCloXBSLpQvIaBBIuV8VAEmCiPAAIwAJgADEGQ1MqgiFstVogNsntrt9odjmRTsELkdFFUjigAO5gB45B1vD6gOZBL0gHHpqRgEz0qflOqkGhQaOYAbTtYoTDlBBgEpkRfLzdrkxDacIbP5wsu3JhxB-d1AkGZiFRmOw+FzcvIxCm82W202tg+J0qyvAqISFKcpisprCo2AaDiKjctwypDIU-IatgAooaivBrLK2AdJKdLktwzj9i8g6Bi07pdD0ZTeq6vqjM6Iaut84bupGUJgDCcasCgibJjAqbpqC4I5peRbECWMyfkilYgGsEA0CYxCWDQ4jqfW3KyNg5SUOUfaugOToNMOwRjhOBzTrOYDzi4S4rseG5bjue4Hs5OwnmeOYXkG14cXe-yPqYz6kJC0a8QUsllgpnC-ha1oAdgLKasa+IABoGtwHQsoRQy4ISaI4mR5Lcgw2ASlK5EmZRZkTNe-x0V6Prun6AaNWxN4-Pe7TcVFfEgPGglJimaYZhJF6FsWcKlvJFbrIosQQHp9b6ZC1TlBp4j6NgaCKCgpjGU89XvOZ5CWQx46TrZc4LiATlHt5rnbvAu6lJ5z3TqelbTQFoa9SFwJheCEWvtF77zYii2IAAQviuEdPw2AMPlSC8AjWIsgA9CoJ2medjU0e0LUMW1wwsRdH4w9+SkqWpO0wNpBy6RIBkQEZ9pnUOl2jtd1lTjO92OYeq4vZub0ffuj1i8ev3nv5gW3r8wNPmDICRW+jE01+imJf+KVpRiGXZRouX5R0hXFaipXGkMFVVZK-C1adjpE58TG0Z65Ne5T-qsYDnH9RDQ0jUJ41ic+kkzcGQfBVxoexsNAkRyJE3iVm-2zbr8VVpstZ7AcRxRE2sBnK2sAEzz1HsSrfWAiDmcvjxMI69DeucCyArYDimHyrqGNqFyGJDPiKNchjRK4USJJkuhQwSmKhG8FqJoCkKWGimi0H6ioKN8GKiqoSoarYBqWo6nqBpGtz7vOiTHr0bCbr+51TTdUFquJ63yfh2N6co5TSkjnDuecQD8BQEXQ4XZvKdmwAAKxQHQOw1d761x6sHRu6siDg1-lDOStNFJrA3ijIYVo7gmjNElACVo75UWJn7J+rUmEdV5rnWGyAYDyEwFIVSaCGGe0wYgDUGgkD8iGNqbg+IGAgACp-euEYk4uH-sJUSk0s4gLjsNMAS5kzR1AJsFQUgoCjkwAgbIIBzjlGiMY0xWALGkBSK0GAJhIicEKCgIY-JeAAE4ljpC8AAKVwBiUQXZ8RwxxPSIJGJ+QAC95AAGYVAAH1UQBOgCkAAjuUVESB8xeFSWQVJABaMA3BUmZXpF4bgaAAC89S5FBiAA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    static LOMATNPC ebony() {
        String dataString = "Ebony:___ N4IgdghgtgpiBcICiAjA9mAniANCANjBAG4CWYA5gLIwDOtEFciABACoDyAIhy1BAGsYLWgFcATsKIBjABYsAcgAUAwi1kRaLCC2mjaAFzRQWhEuQp86DJgDpcIaRH0wOAMy5EDshCAgpaNHxRAxh8TBYwNG8LB1kABwQADgBWPANMeOYQAHFRfHwHABNSWiIy2gQAbQBddIh8AUwAGRhiMIRQAwamgElQqEr4KtAS2nj8CEw2GAAPA18AdQ0DXQgwFkw0URZQgqttdBDd2VKWCmgYAH4HA3FSCiZxIdr0zOy2HswARVE6A1IGAcknGGDKnRAYwmUxm818bAAEr0AMosHIAQSoSBYi16zWaLF6CgAahxmsTsQAxJAAJRpAE0iTl2AjsQByZEcACqzVRHEpLOxXCQ6K4bPYvERSF6NJYlKJ6IJNKQyLYTJYSma6JUSFsLGR30W6MWAGkAIQWi23e6PGDPap1EDdRotNodeBdL79GCDB0AXzeWXhXxpdHiYLgeE0gWkpAgoSKSCg0UBYAQAEYAEwABj9AdGpWh0zmC0Qy3jaw2Wx2e3wB3821WMS0RgA7mAbukbU8XqBJih3SB0cnRGADJTR0VKnhSFBw+JumPFmhxEUEGB8vgZ3OV4uDL0xxns7nHRkg4hPi7fv9U8CwxGIVDJsW4YgDUbTZaLSwkBSGRwFGxIkWRRCVFgUFgVHRBQ2TYOVehyLllRYbk4IRDhFglFhmhFClCTYewuweHsHXqF1WnaQoPSdL0BheGoAydd5gxdUNQTAcEo3oNBY3jGBE2TAEgXgdNjzzHAC3GZ9YVLEBFggUgDBwUxSCEZTqzZSQWCKIgik7J1uztXsCH8Qdh22McJzAKcHFnec92XVd103bd7PWfdDxE0S-VPZiLy+a9DFvPAQXDDjmEkosZN8d9jXNL8WHpFU9SQAANbU2GaelsN6E1sURdECMJNkqBYYVRUIgziKM0iaPIt0qM9F1vV9YYGMDD4Q3vcKHGjHi4wTJMU2E0Tc3zSFC2kksllkCIIC06ttJBMoihUoRtHOWQ0EMfS7mq+1hj7UyqKHEdLMnacQDs3d3Mctd4A3ApXJuscD1LUafI6limkCoS0xC7rwWop8YWmxAACEkHQ5ouBYKhsppDhIdRekAHoFF2wyDteOqmgo90mr6OjqkiqbXzkhSlLWmB1O2TThB0iA9OtfbjP7MyzvHC7bJ3BdbpXe7Hq3K7eb3N6M283zzxAS8fr+IKgQB9igdJ0Hydiz8EqS5EUvSlRMuy5pcvyhFCr1XoSrKkUuEqvbbWx08vnxxrccwFr6MYs9OtYwHIz8bjeMGwTbxEsSfM9vyZa65W-b6wP+KGv6jzGiSJqktXZPLVYnCrbZdjCOtYEORsrEx1naq976fnlpOlbClW06isGQHpbkWHRZCpQ1RGlFZZFeiQWHWURnF0JxPECUQ3phUFbCOFVfVuV5FCBURUCtQUWHOEFGV4IURUWGVVV1U1bVdRZ+36LIvGGohZ0iZ9D2vv8n2Y96gOBoT4ORrD1OQZfWSXA0CbDzq2dyuxgEACs0DkFLhfEibVn5RyvDXYKIBQoPmBpNDOSwl6w16GaK4+pDRxS-GaeBNVEGu2dnfWij8SaNzJrJUM0hxCiEUmXS+FdI7KhUDSLkvQ1RsCQFQEA4ckGy0wGxeuscP58QEsNNMocxrtT8GAWc8YQ6gBWAoUQUABziAQAAFjwOgIomBdH6LtMYvA8QGgwAMKEXwORaAACkcgwDYCkAQxBWzNAUDkFAABacxvRvjogEAAL2kAAZgUFAcGFB6Q5ESfSIoCIaTZjcAAfXwNkoJYA2DZKoAALRgKICgABeSpYi-RAA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    static LOMATNPC halja() {
        //String dataString = "Halja:___ N4IgdghgtgpiBcIASEA2ArCIA0JUwgDcBLMAcwFkYBnaiMuRAAgBUB5AETaaggGsYTagFcAToIIBjABZMAcgAUAwk2kRqTCE0nDqAFwD2UJviKkyPGnQYA6HCEkRdMNgDMOBPdIQgIAI2oDVGE9GFQATyYwAy9ze2kABwQADgBWXD1whMYQAHFhVFR7ABNiagJy6gQAbQBdDLQ+cIAZGEIwhFA9RvCASVCoKvhq0FLqBNQIcJYYAA89HwB1NT1tCDAmcINhJlDCy00-bdXYjTJoGAB+ez1RYjIGUSG6jKyclh6ARWEaPWIDMD2cTjAHlTogMYTKYzeY+FhIXoAZSYuQAghQAKJMRa9ZrNJi9OQANTYzSJWIAYhiAErUgCahNyrCQWIA5Ii2ABVZrItgU5lYjgY1EcVmsbjwjG9alMCmE1H46kYxEsRlMBTNVFKDE2JiIz6LVGLADSAEJzeabncHjAnjV6iBuqgmq12kV4F0ev0YIN7QBfV7ZOE9ak0BKguC4dSBSTECChYoYqAxf6A+AARgATAAGP0B0ZlKHTOYLRDLeNrDZbHZ7VAHfzHXbSMq7AwAdzA1wy1sez1Akz8HUQqOTwjAegpY+KVVwxCg4dE3XHiwMomKCDABVQs-nq6Xel644Q6ezuYdmSDiA+zvC31+qaBYYj4Mhk2LsMQ+sNJot5qYGPJek2DkLFCWZJFxUWOQmCUVE5FZFhZV6XJOSVJguUQpA2EWcUmGaYVyQJFg7G7e5e3tBob1dIdPRvb1fWGWoA0dN5gxvUMQTAMEo1oAxY3jGBE2TP4AWPU882wAtxjfGFSxARYIGIPRsBMYgBBU6tWXEJhigIYou0dHtbT7PB-CHEAR22cdJzAad7DnBd9xXNcNy3HdHPWA8jwzE8-XPViry+H59AfXBgXDLjGCkotZJ8L8jTNX8mDpZVdQxAANLUWGaOk8N6Y0sXhVFiIJVkKCYIURRIwyyOMijHR6aj3Vopp6OeJjA3eEMn0i+xoz4uMEyTFNRIzcT8whQsZJLJZpEiCBtOrHTgXKYpVIETQmDIaQDH0Azblqu1hn7Mz3Qs0drKnGcQAcvdPOc9d4E3Qp3Lu8dD1LE8z06timjvELRLCnqwQ9SbpOhGbEAAIQxLDmg4JgKFy6k2Bh5E6QAejkfajKOl4GqotoaIJ1qBhM18IY-eTFOU9aYA07YtMEXSIH0q1DpMgdzMsscJyu+zd0Xe7V0e57txuwX9w+49fP8y8QGvP7gpEwEgc4kHoumqn4p-JKUsRNLMqUbLcuafLCqQYrdV6MqKuFDhqoOm08fPRqieakm+jJ-0fsC9jgcjXxeP4obhIfMbcz85iLy6-31cD-qQ8E4aVbEyPJLBmLIfklZK02bZdjCOtYEORtYBxjn6pj37b2V0KQHC59QYp985LpLkmFRNDJXVFGFBZRFegxBGWRR7EsOxXF8RQ3ohQFPC2BVPUuR5dD+XhCDNTkBH2AFaUkLkBUmCVFU1Q1LUdXZ532sol13fBJ1SZ9dro4ChXuvjvrg8G5Ow9Gr6JKa0pnJDgBh847DbJ5VsTB0AGFIJYCu18q5v0VrXe8gMG4BxfFNYBSwV4I16KaS4eoDQJV-KaK+5FGK3xaPfUGj8vbPxqEA1uPhQySFEMIJSiCqH42rogJUShqScl6KqFgGIKAgCjr7d+ccIrcSDjGH+QkRppgAdI3wYA5zxnDqAFYchhBQEHKIBAABmXARxijhAMUY20ZjcAJDQDAPQoQfC5HTEoAAtKiVwnioDFCJKiIJrgoaZmKKgAAWosIkZAkCeLIMUWYZA6S5Chsk4o6UFC2V6EE4oOSgkFNRAAXiKVIv0QA";
        String dataString = "Halja:___ N4IgdghgtgpiBcIASEA2ArCIA0JUwgDcBLMAcwFkYBnaiMuRAAgBUB5AETaaggGsYTagFcAToIIBjABZMAcgAUAwk2kRqTCE0nDqAFwD2UJviKkyPGnQYA6HCEkRdMNgDMOBPdIQgIAI2oDVGE9GFQATyYwAy9ze2kABwQADgBWXD1whMYQAHFhVFR7ABNiagJy6gQAbQBdDLQ+cIAZGEIwhFA9RvCASVCoKvhq0FLqBNQIcJYYAA89HwBlAyZwg2EAcnFNJgAdEDJpA319gH57PVFiMgZRIbqMrJyWHoBFYRo9YgMwe3Fxn7lTogMYTKYzeY+BQwURqBLUGxMJAwQTSFEAQiYAHVBAB3AiiJjrQmSVAGfjUbBMMgrfzrPREsRMYpTBFMXpMXE-YowqlqdqrdZMNowpiXAqRcowMCctQM1DEGhMPzSzzSU5MACi7VEazAgjKTAAjsJiKEhDBSbpiAK6SExXLEQAhCDFImwMAafUQQnS4qUoQrLwwSVTRFUDU4wpUs0bL0xVhIACCLGV1x2PLQiJYaKJwbuzJ+gEwCBn0cQwKledaHRFY9aoN1rYTaH2CQwWmCnGzdi5XG4w+71EDdVBNVrtIrwLo9fowQY1UZlMHTOYLRAAVWk3cRciDajAfARveut0Hj2yPheo-C70+31+uH+CUBjEX40mK8hiGRqJRVJ1kT4oUdgZH2p41EOI5jiKk7Ttes7zsMtQAL7ns8PQAEo0M+npwLg6iBJIxAQKExSalAMT3ggACMAAMtHIchKFoZemHYS+9gEQYREkTAZEUV8Pw0fRjHYG+y4QmuIBJts+aCBAYCRJcKIaD8TDNGwFApucoEngOEEsYgV5NLe+hUY+7G4cCoIfpJPhRqgUQGLiMbUGAJYOiRDqCCad5qQYrjeaoxKIgAmjQVJ+PaECSHowhoBEVLRIiSZgG6XnBkI0BtsQsBUuENCYk69rRAypBBZcrpmveaAWrhRKBZlXKiMUgBkBEiKKqH+PBTCqgrNtQRwFG6fXqHw5gZsQriuDC0oMr5Zk-BqbCEmNE2ZXQsDGh8i0yuVWilNNs1gAyuJTBqmpmmihJneEVIcsUKwqgqIqeQyUDhPoMKRIawgJGKKxNgDgaoAKrgGISTZ3GEriIhykgwt0pARJy9bFO5DKjX4+DA6EhT9UFCnUPioggcOYH6UhDTXuOHRTsOM4DIOqHDk8rHXlhAJWfhtDccRpHkZRQnwHRDGoeJtmrvZRyaNsTY6eTel3AZrMXkZbw7YJD4gE+HH0zZ4JS4gFCRJAW2GigGAQHDmjGD8ggBUFvCKUwpBqH4ZoKXoqmNdIho8oEkzmpMaVk5cStngzNMwcCUF9EzEEs5kasgMZ4SczhQI84R-N8YLWvCWLYkgkuktfiAWJyqoEAJNk+putdnbHv2ytU6r6HXqZBcWVzQL66Xhvl0m1LiF5bTEI5KrmJWuYeGAxAAF7SkwABi0pXKIkX4LiDqiNWsgKW6sC0HxwoAbE5BMH9taCGS+iBgUXoom67auKQbrEpyUzKjFfDA7iVd8TVwFHfPQVIDpOBOhNOY2RSha00PjLwe9hCHGrj6G+LYwClSYG-NKjIbrfzQPbcBeCzSuw0Jlbo1A-6O0yvkYgPIGpMAAGoGAYcDNEqB-q6B6gIIK2Qrhkh4egYk+pPphwpq3B4UdoITljozOczNDKpzYr3PCvheY8QFgJKiIsRLixLu+QeUlK4rENLEDQgAcAjXmADegBcAnZEWAUaIfQf1cArcOLdI7Jw7iZTW5kdaWT7hLYxl5Z7SkXsvGxG9wEj08EISQxIGBEhlBYkwh9ETInIUFe2LZrSXwSt5coTAEh72xookhL9cy5IASsKAugGSuEKeDQkwZjDtj6m-WYfFnR4h9PXPkBoKFXEkE0TEWTcQT0cqQce3RsaRH5PJfGgRRDeyYYNaUClrhE2BjyGaeC-aDBhnDQKQMWSyRWE0hGqhcpdVdAAWh+FSXgfCRAXKYIQBKXsUYQx5ISUg7YeREWoPeAMENhSoGKZMhsmg9DdFGRoQahTuh8L9OiZu4E25x1prBGR8dFGJ2UWnDOHFs5814vxIWvw9FFxCZ+ExVdDRyAKKgDxkjvFs3Vp3fxQke6Z1fIYiSRsQBsGIJiFggNCCbEkDKUQkwIZYLFNQO4VJwauA2J1KAxAWpyrdAvYoDIDAGFkIk5UYBcSzEkISKA6BjTED4MUBIO8oCQuKOgMgqBES5AXrMN0RojCYgwhsYwEBEhMCUIkGARomCzECuuYQuJhBUkkOEYgsw-DrA4AkPwmQDDoFsXybEqAc0wqcBAGakgiSiEIMYdG1AF6Lx3gANibXDDYDIwAL0rUaD2y9qB+FEP9f1boOSzHzdIMgCR2mEFUIUP+oa9B+FdsIDUchXAFE5IUNEn10kwE2AyfYEN1C-JgPsJgC9uKSA0IQQKClnJcKpP6PwEBE3hERO8AwCRiAoONBABM3sZQAMiFGwQIi1JTACriD+loZSgwMIQPw90Nh-zIK4T0C9NDhHmAYS0qxQYMmoLMRB1B0AMlCDAdArgEgI2QS++52HLT3IFOUI0lbnIhkRAAKTAK4XEqBpBIeuVAfUzY+OSEScQLIAN2EqgXvoWYMoKKVttVyYguIwDgOEC-SQcYY0hGuQkb0pAQi4jIClRIEAYAbAw1oC1DIb2clWWgBI25z1-WrYhoQM69AYefbDJgSZwjSCA1SFgGwZ3SFQIO7QKwp0QHQKILQ9aBTkfQHwYQxqPh8EnUwINhBHIetEGAGFRo-2GqgCqcIhA9CmezPFvhoaEiWeszwBelnNArE4wADXXJoSLO9DAwaEPgdNYoZ1+ASBqZh5aJvaEi0wLNkyGCRALLIHNlbMgAonr6UrzZwj6uFDAWuqA9ANg1F19AqaJBGhgEvKICmL3iY0HwAw4QNiVpRApUkgUwCGbdMUSLG2cO2pkIZmdMgfmzA1A9V7sBAIkYZNIWDUXCDlFEJW+EGokD+sIAkYoVIMuEAdVfbVggwudWiIIU14RhCRAEEpmU6BQo4Jq8UDDUAXPhsSBQpdg2tRGgnoFC98hsYuTTFgmrFgpUwAkRHFW2KY70zjghe4dK7KIFOOiTXGLKbSJ8ezPxflta6ysv3Ix9KfBsGkJiZYohdT3QdKQP+HJxgxVPvSHB4KkuWm5N5cQtZAGzQJnQVN5A2Vy6xT0HF8j4IJyQknTlKiOZBPUVxLRecdHC1FoxZi7cDfpxT5xTRudKUFxpTnlmWzeBl9AHKZlFWYQIAAMy4AzcUcI9eVSiGb7gJr+A4U5FyNRJQ9ykyuHuVAYozCkwz9cE6AATMUVAAAtLEzCyBIHuWQYoswyChVyE6PfxQusKDSr0GfxRz8z+v0mAAvLfkAjEgA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    static LOMATNPC skol() {
        String dataString = "Sköll Svelger:___ N4IgdghgtgpiBcIDKBrAbwGwwAiQNxgwHMYAnEAGhAxgjwEswiBZGAZzYhIRGwBUA8gBEB2KBBQxsbAK6kptAMYALbADkACgGFsyiG2wRsimWwAuAeyjYadRkTHtOJAHSUQiiKZgCAZkNozZR4IACM2CwwZM0IAT2wwCyD7d2UABwQADgBWKjNYtLhEAHEZLHcAE3o2Whq2BABtAF08iAwUWIAZGAIMBFAzNo6ASRioevgG0Cq2NIwIWL4YAA8zHgB1PTNjCDBsWIsZbBisR0NQw+3kgyJoGAB+dzNSeiISUgnmvIKikD4h2IARRk7DM9AsYHc8lmEJq-RAMzmCyWqx4fAAEsMkNhigBBZgAUWw62GnU62GGagAagJOlSiQAxAkAJWZAE1KcV+OiiQByJACACqnWxAgZ3KJQgJuKEvP4ogxBOGzOwDMpuPJzIJSD4nOwGk6uK0BJcuEB61x6wA0gBCO12p4vN5kT4tECDdpdHqEeEekZjV0AX2+hTRAOZ7DSsLgVH0EUU9AgMQqBKgSXBkPgAEYAEwABkDwem1SRixWa0QmyTOz2ByOJxwsHOl2OymqxwsAHcwI88k73p9QPNQj7ELi0zIwGYGZOKvUqPQoFHSIMp+sLKQKggwGUMAulxvV2ZhlOEFm8wW3flQ4h-p7gaCM1DI9H4Yj5mXUYgkObLbb7Ta2AEvS7ICGoRKUtyWLyusajYFouJqLyfCqsMxSClq2BCih6ICOs8rYJ00r0hSfBuH2rwDo0V4At0vS+gCowwOM1HBu6Pxhp6EYwmAcKxhwFgJkmMApmmYIQmeF6FhQxazB+KIViA6wQPQZgUDY9CSOpda8vI2AVLQFS9u6-Yuo0Q5hKOIDjocU4zmAc7uIuy5Huum7bru+4ubsx6ntm56BleHG3gCD7mE+VDQlGvFFLJpYKTwP4WtaAGAWy2qmgSAAaRp8J0bKEcMVpEhiuJkRSvLMNgUoyuRJmUWZkw0Z6dGjgMjEBqxIa-HeHTcdFfEgHGgmJsmqbphJ2ZSUWCIlvJ5YbMo8QQHpdb6dCNQVBpkiGNgRDKBY5jGc8DUfOZ1CWX0Y4TnZs7ziAzmHj5blbvAO5YF5T1TieFbnpe3WcR0YXiZCkUvjFb5zciC2IAAQgSuGdEI2DMAVzICPD2JsgA9Gox2mWdTWtC13pXe1npMSxkxxfNX5KSpanbTA2mHLpUgGRARmOqdg4XSOV3WTd053U5B4rs9G6ve9e4PWLR4-WeAVBTefyhSC4USWDPFwvANPQ3TSV-ql2DpUgmU5VoeUFZ0RUleiZWmsMlXVdKQh1SdzqE187q0aTDEU51TVsdePXhuDg3DUJY1iU+U0FoFwfBarXHhzGQ0CVHInjSDknxzJs1yfrilVtsni1ocxyEI2UhhC2sD4zz1EAyF97qznWsDbFBfxTDIBskK2C4phir6ujGg8kgwwEsjPLo8SuHEqS5LocMUoSoRAg6rgQoilh4oYtBhpqMjggSsqqFqBq2BajqeoGkaJrc57rrEx0rVkz7AfMUGzfJ31qfuEjqNLOMdJp-WknrT8ikhAWH2BXTsPkOzYAAFYWEYI4Buz8m7sRVr1IEbcIogCiq+XW3dabFx3sjYYNp7hmmSv+e0T8qJE0-m-P2pC-SxEprzd8RceARkUKQGQqlMHMO9iHfhBItDMkFMMXUfACTMBAAnX+eD+qvn4vGYBokJqZnASooaYBFxJljqALYagZBQBHOQeAOYqAXAqLECxViyAIDsSANIbQYBmBiDwYoWYtAAFpcQhJCVSUJvhYY5gqAAfTiTEog6JAlEAqMsIgbJiiw3ScwAAXrk0JuIKjDBCTALKGBsi4gALyVOUYGIAA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    static LOMATNPC the_kid() {
        String dataString = "The Kid:___ N4IgdghgtgpiBcIAqALGACA0gSwCYgBoQAbGCAN2zAHMBZGAZwYmrkXSQHkART9KCAGsMDAK4AnDGQDGKdADkACgGF0KCA3QR000QwAuAeyjpSFKtX6NmrAHSEQ0iHpicAZtzL6UCEBABGDIbEovowxACe6GCG3hYOKAAOCAAcAKxE+hGJbCAA4qLExA642Axk5QwIANoAupkQxIIRADIw5OEIoPqNzQCSYVBV8NWgpQyJxBARSDAAHvq+AOrq+joQYOgRhqLoYUVWWv47a3Ga1NAwAPwO+uLY1Kziw3WZ2blIvREAiqKM+thDGAHJIJkDyl0QONJtNZgtfEgABJ9ADK6DyAEFaABRdBLPotFroPryABqnBapNxADFsQAlOkATRJeQ4iNxAHIUZwAKotNGcals3HcbEY7gcjh8JHYvp09DUkkYol07EopAs9CKFoY5TY2zoFHfJYYpaYACElstt3ujxgzxq9RAPSarXanXg3S+AxgQ0dAF83jkEV86YxEuC4EQNEFpNgIGFcNioLFAcD4ABGABMAAZ-YGxmUYTN5otECsE+tNttdvtiIcAic9igyntDAB3MA3TK2p4vUBTfwekAYlOiMD6anj3BVIjYKAR8Q9CdLQzifDwMCFYhzhdr5f6PoThAZnN5p1ZYOIT6u37-NMg8ORyHQqYl+GII0ms1Wy3obFUkynDyLiJJsqiUpLPI6DKBi8gckgCp9HkPKqugvKIYinBLFK6AtGKVLEkg9g9g8faOg0rptB0xSes63qDC8tSBs67whq6YZgmAELRkwhhxgmMBJimAJAieZ75gQhYTG+cJliASwQNg+gEKY2DCKpNYcpI6C4GQuDds6vb2v2JABMOo47BOU5gDODjzouB6ruuCBbkUu6ORsh7Hpmp7+hebHXl8d4GA+RCghG3FsNJxZyb4X6mhav7oIyaoGtiAAaupIC0jJ4X0mC4kiGLEcSHK0OgoriiRRlkSZFH0VR7q0V6ro+n6IzMUGHyhk+UUODG-HxomyapmJmYSQWUJFrJpbLCgUQQDpNa6aC5S4GpwhaOg1AoIYBiGXcdUOiMA7mbRI5jtZ06ziADn7l5zkbm5O53XuS5eUeZanue3Xsc0IWicC4V9RCdGvrCc2IAAQtiWEtNw6C0HldKcLDaKMgA9PIh3GSdryNc01Eeq1-SMTUMWzR+ClKSpm0wJpOzaRgekQAZNrHaZg4WVdk43fZ71OWuz3bh5D0Tl9J5+QFV7IMFfyhWJINcWDlOQ9TCU-slqUoulWXKDleUtAVRWIiVBp9OVlVitwNVHXa+MXl8xMtYTETtUxLGXj1HGg1Gfh8QJI0iQ+E15v5XuBXLvsq-7g1B0Jo1A+J4dSdNMnq-JFZrE41Y7Hs4T1rARxNrAuOcw13v-T8CvJ8rkWq+nsVQyAjK8ugGJoTKWqo4o7Ion02KI+yqN4lheIEkSKF9KKwp4Zw6qGry-LoUKSIQTq8iI1wwpykh8jKugqrqpq2q6vqHMO0xlFE81kIumTvqe39QUxw3ceB8Nich+NP2SWr755LcEMFsfO7YvJtnQAAK0MFQKw5cr6VyjjeAGtcwogAis+cGM1M7LGXojPo5oriGmNIlX85pL7kU6jfN0NF74MSfhTJuVN5JhmkOIUQykEFUIJlXRAqplB0h5H0DUSBsS0BABHF+0dmicXfgNT+glhJjXTH-KRfgwDzgTKHUAqx5CiCgEOcQJ4iDHFwBEfRhj7QmJAIkRoMB9BhF8HkAALHkaG1A3DkAxAATgzBiAJbhoZZlwAARzSIyAJiIAC01BcBzGoIydxiSABaghsTKG+BiaGGJcB9ACUsbgSxYIAF4SmSP9EAA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    static LOMATNPC blank() {
        String dataString = "";
        return LOMATNPC.loadFromDataString(dataString);
    }

    static LOMATNPC test() {
        String dataString = "Archbishop, Junior:___ N4IgdghgtgpiBcICCAnAxgCwEYEsDOGA9gA4A0ABAFICuYOhKIpIANjBAG45gDmAsjDx4IPOInIAVAPIARKeSgQA1jHJ5qKVe0zkAcgAUAwuQwQ85COTTU8AF0JRybTtx4LBw0QDomINBBsYKQAzGXZbDAQQCCw8QhZqWxgWAE9yMEII118MYgQADgBWZlsU4jEQAHFqFhZfABN8djxBBABtAF0SiBYlFIAZGA5khFBbHr6ASSSoPHbQRrxiFggUiRgAD1sogHVTWysIMHIUwmpyJNr3Cywzg6zzHmgYAH5fWxQcHlEUOfhOkplCoSCYpACK1EEtnoYF8miWhDALVGIEWy1W6y2UQkAAlJgBlciVJB8ACi5B2k36-XIk10ADUpP16eSAGKkgBKHIAmnTKpIceSAOT4qQAVX6hKkrIF5JkpKQMiFknkuNJkw55FZdKQNI5pPxEj55H0-SQhlJXnI+LBOyQOwA0gBCF0u96fb4wX7tLogca9AZDEbwMag6YwWY+gC+gPK2NBHMExERyOYZjiaBwECS9VJUEyMIQAEYAEwABijMYW+HRa0220Qe2zh2Op3OlxY1xidwuGHwF0IAHcwG8Sh6fn82qAVlhg8h87RbKzaPU5swcFBkyhxmBbDsGPUEGAaix15uGDvbJNd8WyxXfaU44gQQGIVDC8x4cmkWJq0sVnWWKIDadqOq6LrkKSLI8lIujknSAoEiqOy6OQhhILoQoSFqkyVGK+rkOK2E4lIOwquQ-QKiytISD4Y5fBOPrdAGgzDHUIZ+mGMyTh0MZ+kC8YBomCI-r46aEJm2YwLm+bQoit4VlWqI1gBmINiAOwQDgtgUCwOAqBQbZCpo5D1Ow9Sjn645epO04xHOSALruy5gKuvgblul77igh7wMetRnp5RxXje8BFkW96xsCoJvnYH4gF+Ka-sp-4YvWUQgfazrgeQ3IGlapIABrmhI-TchRkwOuSuJILRtJCnw5DyoqdFWQxNlMZxLFBuxoYBuGkb-LxUWCX0wnfqm0RCBJWY5nmBbyWFd6VqQf61mpuwYGkEAmW2pnwi09ROPpqiWDwRB2JZHztd6-x2bO7HzmczkrmuIAeRewXeb5-mnu957bsF14NhFkX8U+IAvn0sVybCn5JklKJoqp6WIAAQqSJH9DI5B8OVHJSBjhLcgA9LoV3WbdAJdX0rHBn1UzcfMKXrajGlaTpx0GScZzGaoZkQBZ7o3bZrD2Y9jnPUur3uQDXkHkeJ6BZ9u7A8WEVRg+AnPjFkJxfJ8MiciHHI2lQEgJlYE5Xl+IFcVhileV-SVdVOK1VakwNU1CoyK112elTD6gnTvU0ykA08Xxj7RUJCOiWm02SXNsmFktinDeDMdjXHk3iUn0nzbDCkrWtKPm02Bz+K2ZwXMknawDcPawBTIuddHo3gnrReGxNyWm4B6ncuK5BIARaomgT+iCvikykjjgoExSJEUlSNJ4ZM8qyhRUiGta4qSoRMq4khZq6Dj0iyhqOG6Lq5D6oaxqmualrCwHPHMbTPUov6jMRpHI061jkbOACcMyzQLinRaoMS4szLupGQhAebnEHMFAc5AABWhBuDuBbm-Nu2tIa63fAbBKOc+4qTNupHY+8caTCdC8a0tosrgSdK-RiQ0P6BjYt-Lif9mb9w2ogRMaAUDUG0rg9h1N25CNJIYDkYpJhGgkKSPgIBNZRwIVDFI41EagJmlJGSC1YRp0rBnI4G5syp1APsXQ1AoCzkYPAAALMwW49QUi2PsV6YszBiA9BgLYJIURKiEEmGKKQeAwQ8B2DidBg5Kj9HqAAR0oBgdBYIWCGEHIYMUlQeDTCUGCUkMA8nTCgPk2w5Tpg4DQAANicUgAAvI0tRUYgAArchbishop, Junior:___ N4IgdghgtgpiBcICCAnAxgCwEYEsDOGA9gA4A0ABAFICuYOhKIpIANjBAG45gDmAsjDx4IPOInIAVAPIARKeSgQA1jHJ5qKVe0zkAcgAUAwuQwQ85COTTU8AF0JRybTtx4LBw0QDomINBBsYKQAzGXZbDAQQCCw8QhZqWxgWAE9yMEII118MYgQADgBWZlsU4jEQAHFqFhZfABN8djxBBABtAF0SiBYlFIAZGA5khFBbHr6ASSSoPHbQRrxiFggUiRgAD1sogHVTWysIMHIUwmpyJNr3Cywzg6zzHmgYAH5fWxQcHlEUOfhOkplCoSCYpACK1EEtnoYF8miWhDALVGIEWy1W6y2UQkAAlJgBlciVJB8ACi5B2k36-XIk10ADUpP16eSAGKkgBKHIAmnTKpIceSAOT4qQAVX6hKkrIF5JkpKQMiFknkuNJkw55FZdKQNI5pPxEj55H0-SQhlJXnI+LBOyQOwA0gBCF0u96fb4wX7tLogca9AZDEbwMag6YwWY+gC+gPK2NBHMExERyOYZjiaBwECS9VJUEyMIQAEYAEwABijMYW+HRa0220Qe2zh2Op3OlxY1xidwuGHwF0IAHcwG8Sh6fn82qAVlhg8h87RbKzaPU5swcFBkyhxmBbDsGPUEGAaix15uGDvbJNd8WyxXfaU44gQQGIVDC8x4cmkWJq0sVnWWKIDadqOq6LrkKSLI8lIujknSAoEiqOy6OQhhILoQoSFqkyVGK+rkOK2E4lIOwquQ-QKiytISD4Y5fBOPrdAGgzDHUIZ+mGMyTh0MZ+kC8YBomCI-r46aEJm2YwLm+bQoit4VlWqI1gBmINiAOwQDgtgUCwOAqBQbZCpo5D1Ow9Sjn645epO04xHOSALruy5gKuvgblul77igh7wMetRnp5RxXje8BFkW96xsCoJvnYH4gF+Ka-sp-4YvWUQgfazrgeQ3IGlapIABrmhI-TchRkwOuSuJILRtJCnw5DyoqdFWQxNlMZxLFBuxoYBuGkb-LxUWCX0wnfqm0RCBJWY5nmBbyWFd6VqQf61mpuwYGkEAmW2pnwi09ROPpqiWDwRB2JZHztd6-x2bO7HzmczkrmuIAeRewXeb5-mnu957bsF14NhFkX8U+IAvn0sVybCn5JklKJoqp6WIAAQqSJH9DI5B8OVHJSBjhLcgA9LoV3WbdAJdX0rHBn1UzcfMKXrajGlaTpx0GScZzGaoZkQBZ7o3bZrD2Y9jnPUur3uQDXkHkeJ6BZ9u7A8WEVRg+AnPjFkJxfJ8MiciHHI2lQEgJlYE5Xl+IFcVhileV-SVdVOK1VakwNU1CoyK112elTD6gnTvU0ykA08Xxj7RUJCOiWm02SXNsmFktinDeDMdjXHk3iUn0nzbDCkrWtKPm02Bz+K2ZwXMknawDcPawBTIuddHo3gnrReGxNyWm4B6ncuK5BIARaomgT+iCvikykjjgoExSJEUlSNJ4ZM8qyhRUiGta4qSoRMq4khZq6Dj0iyhqOG6Lq5D6oaxqmualrCwHPHMbTPUov6jMRpHI061jkbOACcMyzQLinRaoMS4szLupGQhAebnEHMFAc5AABWhBuDuBbm-Nu2tIa63fAbBKOc+4qTNupHY+8caTCdC8a0tosrgSdK-RiQ0P6BjYt-Lif9mb9w2ogRMaAUDUG0rg9h1N25CNJIYDkYpJhGgkKSPgIBNZRwIVDFI41EagJmlJGSC1YRp0rBnI4G5syp1APsXQ1AoCzkYPAAALMwW49QUi2PsV6YszBiA9BgLYJIURKiEEmGKKQeAwQ8B2DidBg5Kj9HqAAR0oBgdBYIWCGEHIYMUlQeDTCUGCUkMA8nTCgPk2w5Tpg4DQAANicUgAAvI0tRUYgA";
        return LOMATNPC.loadFromDataString(dataString);
    }

    static LOMATNPC lilscumbag() {
        String data = "Lil Scumbag:___ N4IgdghgtgpiBcIAyBLANgAgMoGMCuUARhAOYgA0IaMEAbimCQLIwDOrpciGAKgPIARPhigQA1jAys8AJ0k0cACwwA5AAoBhDIoisMEDPlYAXAPZQM1OgxIi2HEjAB0FEDgh5WMPgDMBNY0UEEAhCVlM0PGMYNABPDDBTQJtXRQAHBAAOAFZKY1i0rhAAflLXYwg0MVikGFoYhFAKqtiASWioVgQAbVAAExRWNLQIWJ4YAA9jYIBVRScMAAkYtFNi8pkUEkcZLvhugF08gqKeSuqARTw2YxRTMFc5IfuvRpABoZGxyenEM4k9CQIDISMQSAsAKIQYwLABCEBQLjym22MF2PSOIGa1Vq9TQb2xbQ6e0OAF9joVgmcWgAlNhpF5wSi6cI4FDQmB9CFQJJ3B7wADMpNJB3JIBQUBIWBkOGCimMxjS8AA9MrVu40IpTCZ4NkBQKAEwG5USzisZVYGgkPBoNDm1BoAD6uAIYKcaUYIFJQA";

        NonGullLOMATNPC npc =  LOMATNPC.loadFromDataString(data);
        return npc;
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

    //TODO: FUTURE JR, FIGURE OUT HOW TO SPAWN A YN BASED ON WHAT TOWN THEY ARE IN. RANDOMLY PICK WHETHER YN IS IN A GIVEN TOWN.
    static LOMATNPC yn(Random rand) {
        return YNMaker.spawnAYN(rand.nextInt());
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
