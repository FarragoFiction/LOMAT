import 'dart:convert';

import 'package:CommonLib/Utility.dart';

import '../Sections/LOMATSection.dart';
import '../Sections/TalkySection.dart';
import 'LOMATNPC.dart';
import 'TalkyEnd.dart';
import 'TalkyItem.dart';
import 'dart:html';

import 'TalkyRecruit.dart';

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
        //for now end and recruit don't serialize okay?
        talkyItems.where((TalkyItem item ) =>!(item is TalkyEnd) && !(item is TalkyRecruit)).forEach((TalkyItem item)=>  talkyItemsJSON.add(item.toJSON()));
        ret ["talkyItems"] = talkyItemsJSON;
        //don't serialize parent or loop
        return ret;
    }

    static TalkyLevel loadFromJSON(LOMATNPC npc, JsonHandler json) {
        //print("i am trying to load a talky level from json, its ${json}");
        TalkyLevel ret = TalkyLevel(new List<TalkyItem>(),null);
        List<dynamic> aThing = json.getArray("talkyItems");
        //print("a thing is $aThing");
        for(dynamic thing in aThing) {
           // print("thing is $thing");
            //ret.talkyItems.add(TalkyItem.loadFromJSON(npc,new JsonHandler(thing),ret)); don't need to add directly, because creating them does that
            (TalkyItem.loadFromJSON(npc,new JsonHandler(thing),ret));

        }
        return ret;
    }

    void display(Element container) {
        print("displaying $this with children ${talkyItems.length}");
        for(TalkyItem talkyItem in talkyItems) {
            if(talkyItem.triggered()) {
                talkyItem.display(container);
            }
        }
    }

    void goUpALevel(Element container) {
        container.setInnerHtml("");
        if(parent != null) {
            print("Debug SubQuestions: I'm going up a level. my parent is $parent and has children ${parent.talkyItems.length}");
            parent.display(container);
        }else {
            screen.teardown();
        }
    }
}