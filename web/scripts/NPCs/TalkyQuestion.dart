import 'TalkyItem.dart';
import 'TalkyResponse.dart';

class TalkyQuestion extends TalkyItem {
    TalkyResponse response;
  TalkyQuestion(TalkyResponse this.response, String displayText, String associatedEmotion) : super(displayText, associatedEmotion);

}