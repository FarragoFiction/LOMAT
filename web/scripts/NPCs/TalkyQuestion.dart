import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'TalkyResponse.dart';
import 'dart:html';

class TalkyQuestion extends TalkyItem {
    TalkyResponse response;
  TalkyQuestion(String displayText,TalkyResponse this.response, TalkyLevel owner) : super(displayText,owner);

  @override
    void display(Element container) {
        super.display(container);
        div.onClick.listen((Event e) {
            container.setInnerHtml("");
            response.display(container);
        });
    }

}