//'dialogue' is too easy to typo, i am officially declaring 'talky' just as good.

import 'dart:html';

abstract class TalkyItem {
    //todo have talky items have conditions (maybe only responses?)
    static final String HAPPY = "_happy";
    static final String SAD = "_sad";
    static final String NEUTRAL = "_blank";
    DivElement div;

    String displayText;

    TalkyItem(String this.displayText);

    void display(Element container) {
        div = new DivElement()..classes.add("dialogueItem");
        container.append(div);
        div.setInnerHtml("$displayText");
    }


}