import 'TalkyItem.dart';

class TalkyResponse extends TalkyItem {
    //for most it will just be the "go back" button, but
    //could have sub questions
    List<TalkyItem> results = new List<TalkyItem>();
    String associatedEmotion;

  TalkyResponse(List<TalkyItem> this.results,String displayText,String this.associatedEmotion ) : super(displayText);
}