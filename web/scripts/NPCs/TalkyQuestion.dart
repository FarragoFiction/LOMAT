import 'dart:convert';

import 'package:CommonLib/Utility.dart';

import 'LOMATNPC.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'TalkyResponse.dart';
import 'dart:html';

class TalkyQuestion extends TalkyItem {
    static String TYPE = "TalkyQuestion";
    TalkyResponse response;
  TalkyQuestion(String displayText,TalkyResponse this.response, TalkyLevel owner) : super(displayText,owner) {
        response.talkyLevel.parent = owner;
  }

  @override
    void display(Element cont) {
        super.display(cont);
        div.setInnerHtml(">$displayText");
    }


    @override
    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = super.toJSON();
        ret["type"] = TYPE;
        ret ["response"] =response.toJSON();
        return ret;
    }

    static TalkyItem loadFromJSON(LOMATNPC npc, JsonHandler json, TalkyLevel owner) {
        TalkyResponse response = TalkyResponse.loadFromJSON(npc, new JsonHandler(json.getValue("response")),owner);
        TalkyItem ret = new TalkyQuestion(TalkyItem.loadDisplayTextFromJSON(json),response, owner);
        ret.loadTriggersFromJSON( json);
        return ret;
    }



    void onClick() {
        container.setInnerHtml("");
        response.display(container);
    }

}