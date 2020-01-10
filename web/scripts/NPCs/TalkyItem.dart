//'dialogue' is too easy to typo, i am officially declaring 'talky' just as good.

import 'dart:convert';

import 'package:CommonLib/Utility.dart';

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../SoundControl.dart';
import '../Triggers/Trigger.dart';
import 'LOMATNPC.dart';
import 'TalkyLevel.dart';
import 'TalkyQuestion.dart';
import 'TalkyRecruit.dart';
import 'TalkyResponse.dart';
import 'dart:html';
abstract class TalkyItem {
    Element container;

    static final int HAPPY = AnimationObject.FAST;
    static final int SAD = AnimationObject.SLOW;
    static final int NEUTRAL = AnimationObject.MIDDLE;
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

    static String loadDisplayTextFromJSON(JsonHandler json) {
        return json.getValue("displayText");
    }

     void loadTriggersFromJSON(JsonHandler json) {
         List<dynamic> aThing = json.getArray("triggers");

         for(dynamic thing in aThing) {
             _triggers.add(Trigger.loadFromJSON(new JsonHandler(thing)));
         }
    }

    static TalkyItem loadFromJSON(LOMATNPC npc,JsonHandler json, TalkyLevel owner) {
        String type = json.getValue("type");
        if(type == TalkyQuestion.TYPE) {
            return TalkyQuestion.loadFromJSON(npc,json, owner);
        }else if(type == TalkyResponse.TYPE) {
            return TalkyResponse.loadFromJSON(npc,json, owner);
        }else if(type == TalkyRecruit.TYPE) {
            return TalkyRecruit.loadFromJSON(npc,json, owner);
        }else {
            throw("I don't know how to parse type $type in json ${json.data}");
        }
    }

    void addTrigger(Trigger trigger) {
        _triggers.add(trigger);
    }

    bool triggered() {
        return Trigger.allTriggered(_triggers);
    }

    void display(Element parentContainer, bool seagull) {
        container = parentContainer;
        //if i'm passed in null use whatever owner i have cached
        div = new DivElement()..classes.add("dialogueItem");
        if(!(this is TalkyResponse)) {
            div.classes.add("dialogueSelectableItem");
        }

        container.append(div);
        if(this is TalkyResponse && seagull) {
            div.setInnerHtml("${LOMATNPC.seagullQuirk(displayText)}");
        }else {
            div.setInnerHtml("$displayText");
        }

        div.onClick.listen((Event t) {
            SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
            onClick(seagull);
        });
    }

    void onClick(bool seagull);




}