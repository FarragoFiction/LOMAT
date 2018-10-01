import 'TalkyItem.dart';
import 'TalkyResponse.dart';
import 'dart:html';

class TalkyQuestion extends TalkyItem {
    TalkyResponse response;
  TalkyQuestion(String displayText,TalkyResponse this.response) : super(displayText);

  @override
    void display(Element container) {
        super.display(container);
        div.onClick.listen((Event e) {
            div.style.backgroundColor = "red";
        });
    }

}