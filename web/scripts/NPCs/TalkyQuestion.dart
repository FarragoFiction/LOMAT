import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'TalkyResponse.dart';
import 'dart:html';

class TalkyQuestion extends TalkyItem {
    TalkyResponse response;
  TalkyQuestion(String displayText,TalkyResponse this.response, TalkyLevel owner) : super(displayText,owner) {
        response.talkyLevel.parent = owner;
  }

  @override
    void display(Element container) {
        super.display(container);
        div.setInnerHtml(">$displayText");
        div.onClick.listen((Event e) {
            container.setInnerHtml("");
            response.display(container);
        });
    }

}