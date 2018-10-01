import 'TalkyItem.dart';
import 'TalkyResponse.dart';

class TalkyQuestion extends TalkyItem {
    TalkyResponse response;
  TalkyQuestion(String displayText,TalkyResponse this.response) : super(displayText);

}