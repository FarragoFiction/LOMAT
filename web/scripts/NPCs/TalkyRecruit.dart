import '../Game.dart';
import 'LOMATNPC.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'dart:html';

class TalkyRecruit extends TalkyItem {
    LOMATNPC recruitTarget;
    //for most it will just be the "go back" button, but
    //could have sub questions
    TalkyRecruit(LOMATNPC this.recruitTarget,TalkyLevel level) : super("Recruit?",level);

    //TODO if already in party this shouldn't actually display
    @override
    void display(Element cont) {
        super.display(cont);
        div.setInnerHtml(">$displayText");

    }

    void onClick() {
        //get back up to talky level, then to talky section, then to npc, then ask game to recruit them.
        //TODO if there is no room in their party, display error popup
        bool worked = Game.instance.recruit(recruitTarget);
        if(worked) {
            Game.instance.dismissTalkySection();
        }else {
            window.alert("TODO have error popup if no room for recruit");
        }
    }
}