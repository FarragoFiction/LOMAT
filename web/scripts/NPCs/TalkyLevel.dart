import 'dart:convert';

import 'package:CommonLib/Utility.dart';

import '../Sections/LOMATSection.dart';
import '../Sections/TalkySection.dart';
import 'LOMATNPC.dart';
import 'TalkyItem.dart';
import 'dart:html';

//a wrapper for a list of talky items, with the ability for any talk item to return to this level
class TalkyLevel {
    List<TalkyItem> talkyItems = new List<TalkyItem>();
    //simple linked list
    TalkyLevel parent;
    TalkySection screen;

    TalkyLevel(List<TalkyItem> this.talkyItems, TalkyLevel this.parent);

    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = new Map<dynamic, dynamic>();
        List<Map<dynamic, dynamic>> talkyItemsJSON = new List<Map<dynamic,dynamic>>();
        talkyItems.forEach((TalkyItem item)=> talkyItemsJSON.add(item.toJSON()));
        ret ["talkyItems"] = talkyItemsJSON;
        //don't serialize parent or loop
        return ret;
    }

    static TalkyLevel loadFromJSON(LOMATNPC npc, JsonHandler json) {
        print("i am trying to load a talky level from json, its ${json}");
        TalkyLevel ret = TalkyLevel(new List<TalkyItem>(),null);
        List<dynamic> aThing = json.getArray("talkyItems");

        for(dynamic thing in aThing) {
            ret.talkyItems.add(TalkyItem.loadFromJSON(npc,new JsonHandler(thing),ret));
        }
        return ret;
    }

    void display(Element container) {
        for(TalkyItem talkyItem in talkyItems) {
            if(talkyItem.triggered()) {
                talkyItem.display(container);
            }
        }
    }

    void goUpALevel(Element container) {
        container.setInnerHtml("");
        if(parent != null) {
            parent.display(container);
        }else {
            screen.teardown();
        }
    }
}