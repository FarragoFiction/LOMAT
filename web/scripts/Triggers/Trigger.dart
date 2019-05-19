//borrow concepts from the AiEngine.
// events, talky items and cities can all be triggered
import '../Game.dart';

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