import '../Game.dart';
import '../Locations/Road.dart';
import '../Locations/Town.dart';
import '../Sections/LOMATSection.dart';
import '../Sections/PartySection.dart';
import '../SoundControl.dart';
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

class LOMATNPC {
    //TODO have town they want to go to, have their recruit text mention it. maybe can mention CURRENT_NEAREST_TOWN or GOAL_TOWN
    //TODO most kleptomaniac birds, have them swipe shit out of your inventory as an effect
    ImageElement rawImage;
    ImageElement displayImage;

    String get imageSrc => rawImage.src;
    ImageElement get imageCopy => new ImageElement(src: rawImage.src);
    String name;
    String imageModifier;
    String positiveEmotion;
    String neutralEmotion;
    String negativeEmotion;
    SinglePartyMember myStatsView;
    String causeOfDeath = "absolutely nothing";
    int _hp = 85;
    //if its null its good
    Disease disease;

    int get hp => _hp;

    set hp(int value) {
        _hp = value;
        if(myStatsView != null) {
            myStatsView.sync();
        }
    }

    String get diseasePhrase {
        if(disease == null) return "None";
        return disease.name;
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
    String get emotionForCurrentHealth {
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

    LOMATNPC(String this.name, String this.imageModifier,String this.positiveEmotion, String this.neutralEmotion,String this.negativeEmotion, TalkyLevel this.talkyLevel ) {
        rawImage = new ImageElement(src: "${neutralEmotion}_${imageModifier}.gif");
        displayImage = new ImageElement(src: imageSrc)..classes.add("npcImage");
    }

    void syncImages() {
        displayImage.src = imageSrc;
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
        SoundControl.instance.playSoundEffect("Dead_Jingle");
        grave.drawSelf(Game.instance.container, road);
    }

    void displayDialogue(Element container, LOMATSection screen) {
        talkyLevel.screen = screen;
        if(talkyEnd == null) talkyEnd = new TalkyEnd(talkyLevel);

        div = new DivElement()..classes.add("dialogueContainer");
        container.append(displayImage);
        container.append(div);
        talkyLevel.display(div);
    }

    String imgSrcForEmotion(String emotion) {
        if(emotion == TalkyItem.HAPPY) {
            return "${positiveEmotion}_${imageModifier}.gif";
        }else if(emotion == TalkyItem.NEUTRAL) {
            return  "${neutralEmotion}_${imageModifier}.gif";;
        }else if (emotion == TalkyItem.SAD) {
            return "${negativeEmotion}_${imageModifier}.gif";;
        }
    }


    void emote(String emotion) {
        rawImage.src = imgSrcForEmotion(emotion);
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

    static Future<String> randomName() async {
        //TextEngine textEngine = new TextEngine(13, "/WordSource");
        return "TODO: TE";
    }

    //TODO not gonna use this for the real game or anything, but good for testing
    static Future<LOMATNPC> generateRandomNPC(int seed) async {
        Random rand = new Random(seed);
        List<TalkyItem> talkyItems = new List<TalkyItem>();


        TalkyLevel level = new TalkyLevel(talkyItems,null);
        List<String> avatars = <String>["classic","red","blue","yellow"];
        String name = await randomName();
        LOMATNPC testNPC = new LOMATNPC(name,rand.pickFrom(avatars),"images/Seagulls/oldshit/happy","images/Seagulls/oldshit/neutral","images/Seagulls/oldshit/sad", level);


        List<String> emotions = <String>[TalkyItem.HAPPY, TalkyItem.NEUTRAL, TalkyItem.SAD];
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

        TalkyResponse trghost = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(youQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion questionghost = new TalkyQuestion("Why are you dressed like a ghost?",trghost,level);

        TalkyResponse tr3 = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(meQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question3 = new TalkyQuestion("What can you tell me about me?",tr3,level);

        TalkyResponse tr4 = new TalkyResponse(testNPC,<TalkyItem>[new TalkyRecruit(testNPC,null)],seagullQuirk(rand.pickFrom(recruitQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question4 = new TalkyQuestion("Do you want to join me?",tr4,level);

        return testNPC;
    }

}

class Disease
{
    //make this text engine procedural
    String name;
    int healthDrainPerSecond;
    //its worse if you aren't resting
    double movingMultiplier;

}