import 'TalkyItem.dart';
import 'dart:html';

class LOMATNPC {
    ImageElement displayImage;
    String positiveEmotion;
    String neutralEmotion;
    String negativeEmotion;
    //TODO add all the shit they'll need as party members, maybe in a sub class
    //health, hunger, etc.
    List<TalkyItem> dialogueItems = new List<TalkyItem>();

    LOMATNPC(String this.positiveEmotion, String this.neutralEmotion,String this.negativeEmotion, List<TalkyItem> this.dialogueItems ) {
        displayImage = new ImageElement(src: positiveEmotion);
    }

}