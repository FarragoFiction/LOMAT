//displays a popup if triggered and applies an event to the game.

import '../Road.dart';
import 'Effects/DelayEffect.dart';
import 'Effects/Effect.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class RoadEvent {
    //TODO integrate both title and flavor text to suppor text engine hooks.
    //TODO probably want the effect to have an icon of some sort for ease of understanding.
    //things like "Bitten by ANIMALNOUN" or whatever.
    //allowed to be true random or this shit would get boring.
    Random random = new Random();
    String title = "???";
    String flavorText = "An event happens!!!";
    String get fullFlavorText {
        return "$flavorText <br><br>${effect.flavorText}";
    }
    DivElement flavorTextElement;
    DivElement titleElement;

    //higher is more likely to happen
    double oddsOfHapening = 0.5;
    Effect effect;
    RoadEvent(String this.title, String this.flavorText, Effect this.effect, double this.oddsOfHapening);

    void popup(Road road) {
        //TODO make this nice and styled and everything and go away on dismiss
        //TODO some events should cause effects on screen like stopping the
        //animation or displaying a grave stone or whatever.
        DivElement popupContainer = new DivElement()..classes.add("flavorText");
        road.container.append(popupContainer);

        titleElement = new DivElement();
        titleElement.setInnerHtml("<h2>$title</h2>");
        popupContainer.append(titleElement);

        flavorTextElement = new DivElement();
        flavorTextElement.setInnerHtml(fullFlavorText);
        popupContainer.append(flavorTextElement);

        road.container.onClick.listen((Event e)
        {
            popupContainer.remove();
        });

    }

    bool triggered(Road road) {
        print("checking trigger for event $title");
        if(random.nextDouble() < oddsOfHapening && effect.isValid(road)) {
            popup(road);
            effect.apply(road);
            return true;
        }
        return false;
    }

}
