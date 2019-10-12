/*
 fenrir needs to be able to write words to the screen. roughly at head height. similar to magical girl sim
 needs to be timed, for him to just say BORK at you. and then say more things
 maybe sounds that are audio libed?
 */
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';

import '../Game.dart';

class Fenrir {

    static void wakeUP(Element container) {
        print("trying to wake up okay");
        sayHello(container);
        //TODO even if you try talking to him specifically he might interupt because he's so damn excited
    }


    static void sayHello(Element container) {
        popup("bork!!!", container);
    }

    static Future<void> popup(String text, Element container, [DivElement currentPopup, int tick=0]) async {
        int maxTicks = 30;

        if(currentPopup != null && tick == 0) {
            currentPopup.remove();
            currentPopup = null;
        }

        if(currentPopup == null) {
            currentPopup = new DivElement()
                ..classes.add("fenrirPopup")
                ..text = text;
            container.append(currentPopup);
        }
        Random rand = new Random();
        rand.nextInt();
        if(rand.nextBool()) {
            currentPopup.style.left = "${170+rand.nextInt(15)}px";
        }else {
            currentPopup.style.left = "${170-rand.nextInt(15)}px";
        }
        if(rand.nextBool()) {
            currentPopup.style.top = "${80+rand.nextInt(15)}px";
        }else {
            currentPopup.style.top = "${80-rand.nextInt(15)}px";
        }
        if(tick == 1) {
            currentPopup.animate([{"opacity": 100},{"opacity": 0}], 6000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 200), () =>
                popup(text, container, currentPopup, tick+1));
        }else {
            currentPopup.remove();
        }

    }

}