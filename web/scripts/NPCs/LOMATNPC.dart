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
        //TODO
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

    static LOMATNPC test() {
        String dataString = "Archbishop, Junior:___ N4IgdghgtgpiBcICCAnAxgCwEYEsDOGA9gA4A0ABAFICuYOhKIpIANjBAG45gDmAsjDx4IPOInIAVAPIARKeSgQA1jHJ5qKVe0zkAcgAUAwuQwQ85COTTU8AF0JRybTtx4LBw0QDomINBBsYKQAzGXZbDAQQCCw8QhZqWxgWAE9yMEII118MYgQADgBWZlsU4jEQAHFqFhZfABN8djxBBABtAF0SiBYlFIAZGA5khFBbHr6ASSSoPHbQRrxiFggUiRgAD1sogHVTWysIMHIUwmpyJNr3Cywzg6zzHmgYAH5fWxQcHlEUOfhOkplCoSCYpACK1EEtnoYF8miWhDALVGIEWy1W6y2UQkAAlJgBlciVJB8ACi5B2k36-XIk10ADUpP16eSAGKkgBKHIAmnTKpIceSAOT4qQAVX6hKkrIF5JkpKQMiFknkuNJkw55FZdKQNI5pPxEj55H0-SQhlJXnI+LBOyQOwA0gBCF0u96fb4wX7tLogca9AZDEbwMag6YwWY+gC+gPK2NBHMExERyOYZjiaBwECS9VJUEyMIQAEYAEwABijMYW+HRa0220Qe2zh2Op3OlxY1xidwuGHwF0IAHcwG8Sh6fn82qAVlhg8h87RbKzaPU5swcFBkyhxmBbDsGPUEGAaix15uGDvbJNd8WyxXfaU44gQQGIVDC8x4cmkWJq0sVnWWKIDadqOq6LrkKSLI8lIujknSAoEiqOy6OQhhILoQoSFqkyVGK+rkOK2E4lIOwquQ-QKiytISD4Y5fBOPrdAGgzDHUIZ+mGMyTh0MZ+kC8YBomCI-r46aEJm2YwLm+bQoit4VlWqI1gBmINiAOwQDgtgUCwOAqBQbZCpo5D1Ow9Sjn645epO04xHOSALruy5gKuvgblul77igh7wMetRnp5RxXje8BFkW96xsCoJvnYH4gF+Ka-sp-4YvWUQgfazrgeQ3IGlapIABrmhI-TchRkwOuSuJILRtJCnw5DyoqdFWQxNlMZxLFBuxoYBuGkb-LxUWCX0wnfqm0RCBJWY5nmBbyWFd6VqQf61mpuwYGkEAmW2pnwi09ROPpqiWDwRB2JZHztd6-x2bO7HzmczkrmuIAeRewXeb5-mnu957bsF14NhFkX8U+IAvn0sVybCn5JklKJoqp6WIAAQqSJH9DI5B8OVHJSBjhLcgA9LoV3WbdAJdX0rHBn1UzcfMKXrajGlaTpx0GScZzGaoZkQBZ7o3bZrD2Y9jnPUur3uQDXkHkeJ6BZ9u7A8WEVRg+AnPjFkJxfJ8MiciHHI2lQEgJlYE5Xl+IFcVhileV-SVdVOK1VakwNU1CoyK112elTD6gnTvU0ykA08Xxj7RUJCOiWm02SXNsmFktinDeDMdjXHk3iUn0nzbDCkrWtKPm02Bz+K2ZwXMknawDcPawBTIuddHo3gnrReGxNyWm4B6ncuK5BIARaomgT+iCvikykjjgoExSJEUlSNJ4ZM8qyhRUiGta4qSoRMq4khZq6Dj0iyhqOG6Lq5D6oaxqmualrCwHPHMbTPUov6jMRpHI061jkbOACcMyzQLinRaoMS4szLupGQhAebnEHMFAc5AABWhBuDuBbm-Nu2tIa63fAbBKOc+4qTNupHY+8caTCdC8a0tosrgSdK-RiQ0P6BjYt-Lif9mb9w2ogRMaAUDUG0rg9h1N25CNJIYDkYpJhGgkKSPgIBNZRwIVDFI41EagJmlJGSC1YRp0rBnI4G5syp1APsXQ1AoCzkYPAAALMwW49QUi2PsV6YszBiA9BgLYJIURKiEEmGKKQeAwQ8B2DidBg5Kj9HqAAR0oBgdBYIWCGEHIYMUlQeDTCUGCUkMA8nTCgPk2w5Tpg4DQAANicUgAAvI0tRUYgAArchbishop, Junior:___ N4IgdghgtgpiBcICCAnAxgCwEYEsDOGA9gA4A0ABAFICuYOhKIpIANjBAG45gDmAsjDx4IPOInIAVAPIARKeSgQA1jHJ5qKVe0zkAcgAUAwuQwQ85COTTU8AF0JRybTtx4LBw0QDomINBBsYKQAzGXZbDAQQCCw8QhZqWxgWAE9yMEII118MYgQADgBWZlsU4jEQAHFqFhZfABN8djxBBABtAF0SiBYlFIAZGA5khFBbHr6ASSSoPHbQRrxiFggUiRgAD1sogHVTWysIMHIUwmpyJNr3Cywzg6zzHmgYAH5fWxQcHlEUOfhOkplCoSCYpACK1EEtnoYF8miWhDALVGIEWy1W6y2UQkAAlJgBlciVJB8ACi5B2k36-XIk10ADUpP16eSAGKkgBKHIAmnTKpIceSAOT4qQAVX6hKkrIF5JkpKQMiFknkuNJkw55FZdKQNI5pPxEj55H0-SQhlJXnI+LBOyQOwA0gBCF0u96fb4wX7tLogca9AZDEbwMag6YwWY+gC+gPK2NBHMExERyOYZjiaBwECS9VJUEyMIQAEYAEwABijMYW+HRa0220Qe2zh2Op3OlxY1xidwuGHwF0IAHcwG8Sh6fn82qAVlhg8h87RbKzaPU5swcFBkyhxmBbDsGPUEGAaix15uGDvbJNd8WyxXfaU44gQQGIVDC8x4cmkWJq0sVnWWKIDadqOq6LrkKSLI8lIujknSAoEiqOy6OQhhILoQoSFqkyVGK+rkOK2E4lIOwquQ-QKiytISD4Y5fBOPrdAGgzDHUIZ+mGMyTh0MZ+kC8YBomCI-r46aEJm2YwLm+bQoit4VlWqI1gBmINiAOwQDgtgUCwOAqBQbZCpo5D1Ow9Sjn645epO04xHOSALruy5gKuvgblul77igh7wMetRnp5RxXje8BFkW96xsCoJvnYH4gF+Ka-sp-4YvWUQgfazrgeQ3IGlapIABrmhI-TchRkwOuSuJILRtJCnw5DyoqdFWQxNlMZxLFBuxoYBuGkb-LxUWCX0wnfqm0RCBJWY5nmBbyWFd6VqQf61mpuwYGkEAmW2pnwi09ROPpqiWDwRB2JZHztd6-x2bO7HzmczkrmuIAeRewXeb5-mnu957bsF14NhFkX8U+IAvn0sVybCn5JklKJoqp6WIAAQqSJH9DI5B8OVHJSBjhLcgA9LoV3WbdAJdX0rHBn1UzcfMKXrajGlaTpx0GScZzGaoZkQBZ7o3bZrD2Y9jnPUur3uQDXkHkeJ6BZ9u7A8WEVRg+AnPjFkJxfJ8MiciHHI2lQEgJlYE5Xl+IFcVhileV-SVdVOK1VakwNU1CoyK112elTD6gnTvU0ykA08Xxj7RUJCOiWm02SXNsmFktinDeDMdjXHk3iUn0nzbDCkrWtKPm02Bz+K2ZwXMknawDcPawBTIuddHo3gnrReGxNyWm4B6ncuK5BIARaomgT+iCvikykjjgoExSJEUlSNJ4ZM8qyhRUiGta4qSoRMq4khZq6Dj0iyhqOG6Lq5D6oaxqmualrCwHPHMbTPUov6jMRpHI061jkbOACcMyzQLinRaoMS4szLupGQhAebnEHMFAc5AABWhBuDuBbm-Nu2tIa63fAbBKOc+4qTNupHY+8caTCdC8a0tosrgSdK-RiQ0P6BjYt-Lif9mb9w2ogRMaAUDUG0rg9h1N25CNJIYDkYpJhGgkKSPgIBNZRwIVDFI41EagJmlJGSC1YRp0rBnI4G5syp1APsXQ1AoCzkYPAAALMwW49QUi2PsV6YszBiA9BgLYJIURKiEEmGKKQeAwQ8B2DidBg5Kj9HqAAR0oBgdBYIWCGEHIYMUlQeDTCUGCUkMA8nTCgPk2w5Tpg4DQAANicUgAAvI0tRUYgA";
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

        NonGullLOMATNPC npc =  LOMATNPC.loadFromDataString(data);
        npc.avatar.src = "images/Seagulls/Lil_Scumbag.png"; //it actually encodes it as having the full url (localhost nad all)
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
