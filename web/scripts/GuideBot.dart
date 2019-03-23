import 'dart:async';
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
        new Timer(new Duration(milliseconds: 1000), () => {
            rand.pickFrom(travelOptions).click()
        });
        //need to periodically click away popups and shit
    }

    void clickTalkButton(){
        //find a button labeled hunt
        DivElement button = querySelector("#talkButton");
        button.click();
        //TODO once the talk screen is up, click through all the text options i guess?
        //oh i see, react taught me about this
        Random rand = new Random();
        new Timer(new Duration(milliseconds: 1000), () => {
            dialogueLoop(rand,0)
        });


    }

    void dialogueLoop(Random rand, int loop) {
        List<Element> dialogueOptions = querySelectorAll(".dialogueSelectableItem");
        if(dialogueOptions.isEmpty) {
            //TODO maybe have some kind of bot status that flags its run out of things to do here
            return;
        }
        if(loop <100) {
            rand.pickFrom(dialogueOptions).click();
        }else {
            dialogueOptions.last.click(); //try to escape please
        }
        new Timer(new Duration(milliseconds: 1000), () => {
            dialogueLoop(rand, loop+1)
        });

    }


}