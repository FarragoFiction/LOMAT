import 'TalkyItem.dart';
import 'dart:html';

//a wrapper for a list of talky items, with the ability for any talk item to return to this level
class TalkyLevel {
    List<TalkyItem> talkyItems = new List<TalkyItem>();

    TalkyLevel(List<TalkyItem> this.talkyItems);

    void display(Element container) {
        for(TalkyItem talkyItem in talkyItems) {
            talkyItem.display(container);
        }
    }
}