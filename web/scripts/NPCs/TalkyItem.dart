//'dialogue' is too easy to typo, i am officially declaring 'talky' just as good.

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../SoundControl.dart';
import '../Triggers/Trigger.dart';
import 'TalkyLevel.dart';
import 'TalkyResponse.dart';
import 'dart:html';
abstract class TalkyItem {
    Element container;

    static final int HAPPY = AnimationObject.FAST;
    static final int SAD = AnimationObject.MIDDLE;
    static final int NEUTRAL = AnimationObject.SLOW;
    //either this is empty or all are true.
    List<Trigger> _triggers = new List<Trigger>();
    DivElement div;

    String displayText;
    TalkyLevel owner;

    TalkyItem(String this.displayText, TalkyLevel this.owner) {
        if(owner != null) owner.talkyItems.add(this);
    }

    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = new Map<dynamic, dynamic>();
        //TODO don't serialize the owner or it loops, just set it on load
        ret["displayText"] = displayText;
        List<Map<dynamic, dynamic>> triggersJSON = new List<Map<dynamic,dynamic>>();
        _triggers.forEach((Trigger trigger)=> triggersJSON.add(trigger.toJSON()));
        ret ["triggers"] = triggersJSON;

        return ret;
    }

    void addTrigger(Trigger trigger) {
        _triggers.add(trigger);
    }

    bool triggered() {
        return Trigger.allTriggered(_triggers);
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