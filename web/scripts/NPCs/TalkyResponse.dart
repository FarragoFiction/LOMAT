import 'dart:convert';

import 'package:CommonLib/Utility.dart';

import '../CipherEngine.dart';
import 'LOMATNPC.dart';
import 'TalkyEnd.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'dart:html';
//TODO have certain words redacted or voided or ciphered, especially [REDACTED] after [REDACTED]
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

    @override
    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = super.toJSON();
        //TODO don't serialize the owner or it loops, just set it on load
        ret["talkyLevel"] = talkyLevel.toJSON();
        ret["type"] = TYPE;
        ret["associatedEmotion"] = associatedEmotion;
        return ret;
    }

    static TalkyItem loadFromJSON(LOMATNPC npc, String jsonString, TalkyLevel owner) {
        JsonHandler json = new JsonHandler(jsonDecode(jsonString));
        TalkyLevel level = TalkyLevel.loadFromJSON(npc, json.getValue("talkyLevel"));
        TalkyItem ret = TalkyResponse(npc, level.talkyItems,json.getValue("displayText"),json.getValue("associatedEmotion"), owner);
        return ret;
    }


    @override
    void display(Element cont) {
        super.display(cont);
        CipherEngine.applyRandom(div);
        if(talkyEnd == null) talkyEnd = new TalkyEnd(talkyLevel);
        npc.emote(associatedEmotion);
        for(TalkyItem talkyItem in talkyLevel.talkyItems) {
            talkyItem.display(container);
        }
    }

    void onClick() {
        //does nothing.
    }
}