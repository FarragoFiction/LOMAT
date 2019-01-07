import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'dart:html';

class TalkyEnd extends TalkyItem {
    //for most it will just be the "go back" button, but
    //could have sub questions
    TalkyEnd(TalkyLevel level) : super("Recruit?",level);

    @override
    void display(Element cont) {
        super.display(cont);
        div.setInnerHtml(">$displayText");

    }

    void onClick() {
        //get back up to talky level, then to talky section, then to npc, then ask game to recruit them.
        //TODO if there is no room in their party, display error popup
    }
}