import '../Screens/LOMATScreen.dart';
import 'TalkyEnd.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'TalkyQuestion.dart';
import 'TalkyResponse.dart';
import 'dart:html';

import 'package:CommonLib/Random.dart';

class LOMATNPC {
    ImageElement displayImage;
    String imageModifier;
    String positiveEmotion;
    String neutralEmotion;
    String negativeEmotion;
    DivElement div;
    //TODO add all the shit they'll need as party members, maybe in a sub class (since not all townsfolk are potential party members)
    //health, hunger, etc.
    TalkyLevel talkyLevel;
    TalkyEnd talkyEnd;

    LOMATNPC(String this.imageModifier,String this.positiveEmotion, String this.neutralEmotion,String this.negativeEmotion, TalkyLevel this.talkyLevel ) {
        displayImage = new ImageElement(src: "${neutralEmotion}_${imageModifier}.gif")..classes.add("npcImage");
    }

    void displayDialogue(Element container, LOMATScreen screen) {
        talkyLevel.screen = screen;
        if(talkyEnd == null) talkyEnd = new TalkyEnd(talkyLevel);

        div = new DivElement()..classes.add("dialogueContainer");
        container.append(displayImage);
        container.append(div);
        talkyLevel.display(div);
    }

    void emote(String emotion) {
        if(emotion == TalkyItem.HAPPY) {
            displayImage.src = "${positiveEmotion}_${imageModifier}.gif";
        }else if(emotion == TalkyItem.NEUTRAL) {
            displayImage.src = "${neutralEmotion}_${imageModifier}.gif";;
        }else if (emotion == TalkyItem.SAD) {
            displayImage.src = "${negativeEmotion}_${imageModifier}.gif";;
        }
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

    //TODO not gonna use this for the real game or anything, but good for testing
    static LOMATNPC generateRandomNPC(int seed) {
        Random rand = new Random(seed);
        List<TalkyItem> talkyItems = new List<TalkyItem>();


        TalkyLevel level = new TalkyLevel(talkyItems,null);
        List<String> avatars = <String>["classic","red","blue","yellow"];
        LOMATNPC testNPC = new LOMATNPC(rand.pickFrom(avatars),"images/Seagulls/happy","images/Seagulls/neutral","images/Seagulls/sad", level);


        List<String> emotions = <String>[TalkyItem.HAPPY, TalkyItem.NEUTRAL, TalkyItem.SAD];
        List<String> gameQuips = <String>["This game is going to be based on the retro game 'Oregon Trail'.","This game will involve ferrying the 'souls of the dead' to their final resting place.","This game is the Land of Mists and Trails."];
        List<String> townQuips = <String>["This town is a default test town scribbled by JR.","This town is snowy, and has some huge trees in it.","This town will probably be redrawn by an actual artist at some point.","Everyone in this town can't figure out how to leave it."];
        List<String> meQuips = <String>["You are the Guide of Void. Or was it dark?????","You are the prophesied Hero who will guide the lost souls of this land to their final resting place.","Your horns are very nice."];
        List<String> youQuips = <String>["I'm not DRESSED like a ghost, I AM a ghost.", "Behold my robes y/n?", "Because I AM a ghost!", "I am a lost soul!"];


        TalkyResponse tr = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(gameQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question1 = new TalkyQuestion("What can you tell me about this game?",tr,level);

        TalkyResponse tr2 = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(townQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question2 = new TalkyQuestion("What can you tell me about this town?",tr2,level);

        TalkyResponse trghost = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(youQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion questionghost = new TalkyQuestion("Why are you dressed like a ghost?",trghost,level);

        TalkyResponse tr3 = new TalkyResponse(testNPC,new List<TalkyItem>(),seagullQuirk(rand.pickFrom(meQuips)), rand.pickFrom(emotions),null);
        TalkyQuestion question3 = new TalkyQuestion("What can you tell me about me?",tr3,level);

        return testNPC;
    }

}