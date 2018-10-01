import 'TalkyItem.dart';
import 'dart:html';

class LOMATNPC {
    ImageElement displayImage;
    String positiveEmotion;
    String neutralEmotion;
    String negativeEmotion;
    DivElement div;
    //TODO add all the shit they'll need as party members, maybe in a sub class (since not all townsfolk are potential party members)
    //health, hunger, etc.
    List<TalkyItem> dialogueItems = new List<TalkyItem>();

    LOMATNPC(String this.positiveEmotion, String this.neutralEmotion,String this.negativeEmotion, List<TalkyItem> this.dialogueItems ) {
        displayImage = new ImageElement(src: positiveEmotion);
    }

    void displayDialogue(Element container) {
        div = new DivElement()..classes.add("dialogueContainer");
        container.append(div);
        for(TalkyItem talkyItem in dialogueItems) {
            talkyItem.display(div,null);
        }
    }

}