import 'TalkyEnd.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'TalkyResponse.dart';
import 'dart:html';

class LOMATNPC {
    ImageElement displayImage;
    String positiveEmotion;
    String neutralEmotion;
    String negativeEmotion;
    DivElement div;
    //TODO add all the shit they'll need as party members, maybe in a sub class (since not all townsfolk are potential party members)
    //health, hunger, etc.
    TalkyLevel talkyLevel;
    TalkyEnd talkyEnd;

    LOMATNPC(String this.positiveEmotion, String this.neutralEmotion,String this.negativeEmotion, TalkyLevel this.talkyLevel ) {
        displayImage = new ImageElement(src: neutralEmotion)..classes.add("npcImage");
    }

    void displayDialogue(Element container) {
        if(talkyEnd == null) talkyEnd = new TalkyEnd(talkyLevel);

        div = new DivElement()..classes.add("dialogueContainer");
        container.append(displayImage);
        container.append(div);
        talkyLevel.display(div);
    }

    void emote(String emotion) {
        if(emotion == TalkyItem.HAPPY) {
            displayImage.src = positiveEmotion;
        }else if(emotion == TalkyItem.NEUTRAL) {
            displayImage.src = neutralEmotion;
        }else if (emotion == TalkyItem.SAD) {
            displayImage.src = negativeEmotion;
        }
    }

}