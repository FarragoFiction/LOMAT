//'dialogue' is too easy to typo, i am officially declaring 'talky' just as good.

import 'dart:html';

abstract class TalkyItem {
    //todo have talky items have conditions (maybe only responses?)
    static final String HAPPY = "_happy";
    static final String SAD = "_sad";
    static final String NEUTRAL = "_blank";
    DivElement div;

    String displayText;
    TalkyItem owner;

    TalkyItem(String this.displayText);

    void display(Element container, TalkyItem myOwner) {
        if(myOwner != null) owner = myOwner;
        //if i'm passed in null use whatever owner i have cached
        div = new DivElement()..classes.add("dialogueItem");
        container.append(div);
        div.setInnerHtml("$displayText");
    }

    void goUpALevel(Element container) {
        container.setInnerHtml("");
        if(owner != null) {
            owner.display(container, null);
        }else {
            container.setInnerHtml("TODO: have this go back to the previous screen.");
        }
    }


}