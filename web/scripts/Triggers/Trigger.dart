//borrow concepts from the AiEngine.
// events, talky items and cities can all be triggered
import 'package:CommonLib/Utility.dart';

import '../Game.dart';
import 'FundsTrigger.dart';
import 'GravesNumberTrigger.dart';
import 'PartyMemberWithName.dart';
import 'PartyNumberTrigger.dart';

abstract class Trigger {
    //for auto form shit
    String importantWordLabel;
    String importantIntLabel;
    bool invert = false;
    String label = "???";

    String importantWord;
    int importantInt;
    Game game;

    Trigger() {
        game = Game.instance;
    }

    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = new Map<dynamic, dynamic>();
        //TODO don't serialize the owner or it loops, just set it on load
        ret["label"] = label;
        ret["importantWord"] = importantWord;
        ret["importantInt"] = importantInt;
        return ret;
    }

    //super simple
    void loadJSON(JsonHandler json) {
        importantWord = json.getValue("importantWord");
        importantWord = json.getValue("importantInt");
    }


    static Trigger loadFromJSON(JsonHandler json) {
        //need to figure out what kind of trigger this is, via label
        String type = json.getValue("label");
        if(type == new FundsTrigger().label) {
            return new FundsTrigger()..loadJSON(json);
        }else if(type == new GravesNumberTrigger().label) {
            return new GravesNumberTrigger()..loadJSON(json);
        }else if(type == new PartyMemberWithName().label) {
            return new PartyMemberWithName()..loadJSON(json);
        }else if(type == new PartyNumberTrigger().label) {
            return new PartyNumberTrigger()..loadJSON(json);
        }else {
            throw("I don't know how to parse trigger label $type");
        }
    }

    static bool allTriggered(List<Trigger> triggers) {
        return triggers.isEmpty || triggers.every((Trigger trigger) => trigger.isTriggered());
    }

    bool isTriggered() {
        if(invert) {
            return !isTriggeredRaw();
        }else {
            return isTriggeredRaw();
        }
    }

    //each sub type implements this. if ANY are false, return false.
    bool isTriggeredRaw();

    void renderForm() {
        //TODO
    }

    void syncToForm() {
        //TODO
    }
    void syncFormToMe() {
        //TODO
    }

}