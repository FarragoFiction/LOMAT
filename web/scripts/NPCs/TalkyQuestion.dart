import 'TalkyItem.dart';
import 'TalkyResponse.dart';
import 'dart:html';

class TalkyQuestion extends TalkyItem {
    TalkyResponse response;
  TalkyQuestion(String displayText,TalkyResponse this.response) : super(displayText);

  @override
    void display(Element container, TalkyItem myOwner) {
        super.display(container, myOwner);
        div.onClick.listen((Event e) {
            container.setInnerHtml("");
            response.display(container,this);
        });
    }

}