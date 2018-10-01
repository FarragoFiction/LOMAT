import 'TalkyItem.dart';
import 'dart:html';

class TalkyEnd extends TalkyItem {
    //for most it will just be the "go back" button, but
    //could have sub questions
    TalkyEnd() : super("End Conversation");

    @override
    void display(Element container, TalkyItem myOwner) {
        super.display(container, myOwner);
        div.onClick.listen((Event e) {
           owner.goUpALevel(container);
        });
    }
}