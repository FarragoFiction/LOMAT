import 'TalkyEnd.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'dart:html';

class TalkyResponse extends TalkyItem {
    //for most it will just be the "go back" button, but
    //could have sub questions
    TalkyLevel talkyLevel;
    String associatedEmotion;

  TalkyResponse(List<TalkyItem> results,String displayText,String this.associatedEmotion, TalkyLevel level) : super(displayText,level) {
        results.add(new TalkyEnd(owner));
        talkyLevel = new TalkyLevel(results);
        talkyLevel.talkyItems.add(this);
  }

    @override
    void display(Element container) {
        super.display(container);
        for(TalkyItem talkyItem in talkyLevel.talkyItems) {
            talkyItem.display(container);
        }
    }
}