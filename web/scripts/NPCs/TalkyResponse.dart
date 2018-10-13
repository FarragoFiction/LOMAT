import 'LOMATNPC.dart';
import 'TalkyEnd.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'dart:html';

class TalkyResponse extends TalkyItem {
    //for most it will just be the "go back" button, but
    //could have sub questions
    TalkyLevel talkyLevel;
    String associatedEmotion;
    //needed to emote
    LOMATNPC npc;
    TalkyEnd talkyEnd;

  TalkyResponse(LOMATNPC this.npc, List<TalkyItem> results,String displayText,String this.associatedEmotion, TalkyLevel level) : super(displayText,level) {
        talkyLevel = new TalkyLevel(results, owner);

      //talkyLevel.talkyItems.add(this);
  }

    @override
    void display(Element cont) {
        super.display(cont);
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