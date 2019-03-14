//displays a popup if triggered and applies an event to the game.

import '../../Game.dart';
import '../../SoundControl.dart';
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
    static String PARTYMEMBER = "PARTYMEMBER"; //to replace
    String title = "???";
    String flavorText = "An event happens!!!";
    DivElement container;
    String get fullFlavorText {
        return "$flavorText <br><br>${effect.flavorText}";
    }
    DivElement flavorTextElement;
    DivElement titleElement;

    //higher is more likely to happen
    double oddsOfHapening = 0.5;
    Effect effect;
    RoadEvent(String this.title, String this.flavorText, Effect this.effect, double this.oddsOfHapening);

    void popup(Road road, Element container) {
        //TODO make this nice and styled and everything and go away on dismiss
        //TODO some events should cause effects on screen like stopping the
        //animation or displaying a grave stone or whatever.
        //don't append to the road cuz things like deaths will hide it and then you wont see this
        Game.instance.container.append(container);

        titleElement = new DivElement();
        titleElement.setInnerHtml("<h2>$title</h2>");
        container.append(titleElement);

        flavorTextElement = new DivElement();
        flavorTextElement.setInnerHtml(fullFlavorText);
        container.append(flavorTextElement);
        SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");

        Game.instance.container.onClick.listen((Event e)
        {
            container.remove();
        });

    }

    Future<bool> triggered(Road road) async {
        print("checking trigger for event $title");
        if(random.nextDouble() < oddsOfHapening && effect.isValid(road)) {
            //effect will set relevant info like target name, have it go first
            DivElement container = new DivElement()..classes.add("event");
            await effect.apply(road,container);
            popup(road, container);
            return true;
        }
        return false;
    }

}
