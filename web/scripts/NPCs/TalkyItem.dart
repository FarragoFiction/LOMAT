//'dialogue' is too easy to typo, i am officially declaring 'talky' just as good.
abstract class TalkyItem {
    //todo have talky items have conditions (maybe only responses?)
    static final String HAPPY = "_happy";
    static final String SAD = "_sad";
    static final String NEUTRAL = "_blank";

    String displayText;
    String associatedEmotion;

    TalkyItem(String this.displayText, String this.associatedEmotion);


}