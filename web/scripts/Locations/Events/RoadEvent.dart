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
    Road road;
    Random random = new Random();
    String title = "???";
    String flavorText = "An event happens!!!";
    String get fullFlavorText {
        return "$flavorText <br><br>${effect.flavorText}";
    }
    //higher is more likely to happen
    double oddsOfHapening = 0.5;
    Effect effect;
    RoadEvent(Road this.road, String this.title, String this.flavorText, Effect this.effect, double this.oddsOfHapening);


    static List<RoadEvent> makeSomeTestEvents(Road road) {
        List<RoadEvent> ret = new List<RoadEvent>();
        DelayEffect smallDelay = new DelayEffect(1000);
        DelayEffect mediumEffect = new DelayEffect(5000);
        DelayEffect largeEffect = new DelayEffect(10000);
        ret.add(new RoadEvent(road, "Road Work Being Done","You encounter a group of sqwawking 'ghosts' in the middle of the road. They refuse to move.", smallDelay, 0.5));
        ret.add(new RoadEvent(road, "Get Homaged","One of your currently nonexistant party members gets dysentery or something.", mediumEffect, 0.25));
        ret.add(new RoadEvent(road, "Absolutely Get Wrecked","BY ODINS LEFT VESTIGAL VENOM SACK, your wago...I mean SWEET VIKING LAND BOAT breaks down.", largeEffect, 0.05));

        return ret;
    }

    void popup() {
        //TODO make this nice and styled and everything and go away on dismiss
        window.alert("$title $fullFlavorText");
        //TODO some events should cause effects on screen like stopping the
        //animation or displaying a grave stone or whatever.
    }

    bool triggered() {
        if(random.nextDouble() < oddsOfHapening) {
            popup();
            effect.apply(road);
            return true;
        }
        return false;
    }

}
