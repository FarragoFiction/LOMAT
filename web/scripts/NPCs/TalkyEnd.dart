import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'dart:html';

class TalkyEnd extends TalkyItem {
    //for most it will just be the "go back" button, but
    //could have sub questions
    TalkyEnd(TalkyLevel level) : super("Shit Go Back",level);

    @override
    void display(Element container) {
        super.display(container);
        div.setInnerHtml(">$displayText");
        div.onClick.listen((Event e) {
           owner.goUpALevel(container);
        });
    }
}