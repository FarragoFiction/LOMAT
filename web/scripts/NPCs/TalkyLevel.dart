import '../Sections/LOMATSection.dart';
import '../Sections/TalkySection.dart';
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
        if(parent != null) {
            ret["parent"] = parent.toJSON();
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