import 'TalkyItem.dart';
import 'dart:html';

//a wrapper for a list of talky items, with the ability for any talk item to return to this level
class TalkyLevel {
    List<TalkyItem> talkyItems = new List<TalkyItem>();
    //simple linked list
    TalkyLevel parent;

    TalkyLevel(List<TalkyItem> this.talkyItems, TalkyLevel this.parent);

    void display(Element container) {
        for(TalkyItem talkyItem in talkyItems) {
            talkyItem.display(container);
        }
    }

    void goUpALevel(Element container) {
        container.setInnerHtml("");
        if(parent != null) {
            parent.display(container);
        }else {
            container.setInnerHtml("TODO: have this go back to the previous screen (this is top level)");
        }
    }
}