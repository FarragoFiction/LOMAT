//displays a popup if triggered and applies an event to the game.

import '../Road.dart';
import 'Effects/DelayEffect.dart';
import 'Effects/Effect.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class RoadEvent {
    //TODO integrate both title and flavor text to suppor text engine hooks.
    //things like "Bitten by ANIMALNOUN" or whatever.
    //allowed to be true random or this shit would get boring.
    Random random = new Random();
    String title = "???";
    String flavorText = "An event happens!!!";
    String get fullFlavorText {
        return "$flavorText <br><br>${effect.flavorText}";
    }
    //higher is more likely to happen
    double oddsOfHapening = 0.5;
    Effect effect;
    RoadEvent(String this.title, String this.flavorText, Effect this.effect, double this.oddsOfHapening);

    void popup() {
        //TODO make this nice and styled and everything and go away on dismiss
        window.alert("$title $fullFlavorText");
        //TODO some events should cause effects on screen like stopping the
        //animation or displaying a grave stone or whatever.
    }

    bool triggered(Road road) {
        if(random.nextDouble() < oddsOfHapening) {
            popup();
            effect.apply(road);
            return true;
        }
        return false;
    }

}
