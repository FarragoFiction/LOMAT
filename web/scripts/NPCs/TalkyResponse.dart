import 'dart:convert';

import 'package:CommonLib/Utility.dart';

import '../CipherEngine.dart';
import '../Game.dart';
import 'LOMATNPC.dart';
import 'TalkyEnd.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'dart:html';
//TODO think about having full on alt text for responses possible after [REDACTED]
class TalkyResponse extends TalkyItem {
    //for most it will just be the "go back" button, but
    //could have sub questions
    static String TYPE = "TalkyResponse";
    TalkyLevel talkyLevel;
    int associatedEmotion;
    //needed to emote
    LOMATNPC npc;
    TalkyEnd talkyEnd;

  TalkyResponse(LOMATNPC this.npc, List<TalkyItem> results,String displayText,int this.associatedEmotion, TalkyLevel level) : super(displayText,level) {
        talkyLevel = new TalkyLevel(results, owner);

      //talkyLevel.talkyItems.add(this);
  }

  TalkyResponse.withLevel(LOMATNPC this.npc,String displayText,int this.associatedEmotion, TalkyLevel this.talkyLevel, TalkyLevel ownerLevel) : super(displayText,ownerLevel){

  }

    @override
    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = super.toJSON();
        //TODO don't serialize the owner or it loops, just set it on load
        ret["talkyLevel"] = talkyLevel.toJSON();
        ret["type"] = TYPE;
        ret["associatedEmotion"] = associatedEmotion;
        return ret;
    }

    static TalkyItem loadFromJSON(LOMATNPC npc, JsonHandler json, TalkyLevel owner) {
        TalkyLevel level = TalkyLevel.loadFromJSON(npc, new JsonHandler(json.getValue("talkyLevel")));
        TalkyItem ret = TalkyResponse(npc, level.talkyItems,TalkyItem.loadDisplayTextFromJSON(json),json.getValue("associatedEmotion"), owner);
        ret.loadTriggersFromJSON( json);
        return ret;
    }


    @override
    void display(Element cont, bool seagull) {
        super.display(cont, seagull);
        CipherEngine.applyRandom(div, Game.instance.amagalmatesMode);
        if(talkyEnd == null) talkyEnd = new TalkyEnd(talkyLevel);
        npc.emote(associatedEmotion);
        talkyLevel.display(cont, seagull);
    }

    void onClick(bool seagull) {
        //does nothing.
    }
}