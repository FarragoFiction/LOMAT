import 'dart:html';

class GuideBot {
    static GuideBot _instance;

    static GuideBot get instance {
        if(_instance == null) {
            _instance = new GuideBot();
        }
        return _instance;
    }

    GuideBot() {
        _instance = this;
    }

/*
    for now, just click on screen buttons.
 */

    void clickHuntButton() {
        //find a button labeled hunt
        DivElement button = querySelector("#huntingButton");
        button.click();
    }


}