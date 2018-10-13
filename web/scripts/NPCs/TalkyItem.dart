//'dialogue' is too easy to typo, i am officially declaring 'talky' just as good.

import '../SoundControl.dart';
import 'TalkyLevel.dart';
import 'dart:html';

abstract class TalkyItem {
    Element container;

    //todo have talky items have conditions (maybe only responses?)
    static final String HAPPY = "_happy";
    static final String SAD = "_sad";
    static final String NEUTRAL = "_blank";
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
        container.append(div);
        div.setInnerHtml("$displayText");
        div.onClick.listen((Event t) {
            SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
            onClick();
        });
    }

    void onClick();




}