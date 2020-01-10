import 'dart:convert';

import 'package:CommonLib/Utility.dart';

import '../Game.dart';
import 'LOMATNPC.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'dart:html';

class TalkyRecruit extends TalkyItem {
    LOMATNPC recruitTarget;
    static String TYPE = "RECRUITITEM";
    //for most it will just be the "go back" button, but
    //could have sub questions
    TalkyRecruit(LOMATNPC this.recruitTarget,TalkyLevel level) : super("Recruit?",level);

    //TODO if already in party this shouldn't actually display
    @override
    void display(Element cont, bool seagull) {
        super.display(cont, seagull);
        div.setInnerHtml(">$displayText");

    }

    @override
    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = super.toJSON();
        //TODO don't serialize the owner or it loops, just set it on load
        ret["displayText"] = displayText;
        ret["type"] = TYPE;
        //recruit is encoded as who owns me
        return ret;
    }

    static TalkyItem loadFromJSON(LOMATNPC npc, JsonHandler json, TalkyLevel owner) {
        //in theory i could check the name but whatever.
        TalkyItem ret = TalkyRecruit(npc, owner);
        ret.displayText = TalkyItem.loadDisplayTextFromJSON(json);
        ret.loadTriggersFromJSON( json);

        return ret;
    }


    void onClick(bool seagull) {
        //get back up to talky level, then to talky section, then to npc, then ask game to recruit them.
        //TODO if there is no room in their party, display error popup
        bool worked = Game.instance.recruit(recruitTarget);
        if(worked) {
            Game.instance.dismissTalkySection();
        }else {
            window.alert("TODO have error popup if no room for recruit");
        }
    }
}