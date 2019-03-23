import 'dart:html';

import 'package:CommonLib/Random.dart';

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
        List<Element> travelOptions = querySelectorAll(".travelOption");
        Random rand = new Random();
        rand.pickFrom(travelOptions).click();
        //need to periodically click away popups and shit
    }

    void clickTalkButton() {
        //find a button labeled hunt
        DivElement button = querySelector("#talkButton");
        button.click();
        //TODO once the talk screen is up, click through all the text options i guess?
    }


}