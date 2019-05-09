//'dialogue' is too easy to typo, i am officially declaring 'talky' just as good.

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../SoundControl.dart';
import 'TalkyLevel.dart';
import 'TalkyResponse.dart';
import 'dart:html';

abstract class TalkyItem {
    Element container;

    //todo have talky items have conditions (maybe only responses?)

    static final int HAPPY = AnimationObject.FAST;
    static final int SAD = AnimationObject.MIDDLE;
    static final int NEUTRAL = AnimationObject.SLOW;
    DivElement div;

    String displayText;
    TalkyLevel owner;

    TalkyItem(String this.displayText, TalkyLevel this.owner) {
        if(owner != null) owner.talkyItems.add(this);
    }

    void display(Element parentContainer) {
        container = parentContainer;
        //if i'm passed in null use whatever owner i have cached
        div = new DivElement()..classes.add("dialogueItem");
        if(!(this is TalkyResponse)) {
            div.classes.add("dialogueSelectableItem");
        }
        container.append(div);
        div.setInnerHtml("$displayText");

        div.onClick.listen((Event t) {
            SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
            onClick();
        });
    }

    void onClick();




}