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
      //don't pass the owner here, respones aren't on screen at first.
        TalkyResponse response = TalkyResponse.loadFromJSON(npc, new JsonHandler(json.getValue("response")),null);
        TalkyItem ret = new TalkyQuestion(TalkyItem.loadDisplayTextFromJSON(json),response, owner);
        ret.loadTriggersFromJSON( json);
        //print("loading question from json, ${ret.displayText}");

        return ret;
    }



    void onClick() {
        container.setInnerHtml("");
        response.display(container);
    }

}