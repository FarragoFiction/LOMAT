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
        //actually play the hunting mini game
    }

    void clickTravelButton() {
        //find a button labeled hunt
        DivElement button = querySelector("#travelButton");
        button.click();
        //need to pick a city to travel to
    }

    void clickTalkButton() {
        //find a button labeled hunt
        DivElement button = querySelector("#talkButton");
        button.click();
        //TODO once the talk screen is up, click through all the text options i guess?
    }


}