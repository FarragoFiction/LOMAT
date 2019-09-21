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
    //TODO have a trigger system like (ebony is in party)
    //have npcs have two sets of events. one for Is in party (gulls only)
    //and one for "approaching/leaving town where npc is"
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

    void replaceText(Element targetContainer) {
        if(effect.target != null) {
            targetContainer.text.replaceAll(
                PARTYMEMBER, "${effect.target.name}");
        }

    }

    void popup(Element gameContainer) {
        DivElement container = new DivElement()..classes.add("event");
        //animation or displaying a grave stone or whatever.
        //don't append to the road cuz things like deaths will hide it and then you wont see this
        gameContainer.append(container);

        titleElement = new DivElement();
        ImageElement img = effect.image;
        img.classes.add("eventIcon");
        container.append(img);
        titleElement.setInnerHtml("<h2>$title</h2>");
        container.append(titleElement);
        flavorTextElement = new DivElement();
        flavorTextElement.setInnerHtml(fullFlavorText);
        replaceText(flavorTextElement);

        container.append(flavorTextElement);
        SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");

        gameContainer.onClick.listen((Event e)
        {
            container.remove();
        });

    }

    Future<bool> triggered(Road road) async {
        print("checking trigger for event $title");
        if(random.nextDouble() < oddsOfHapening && effect.isValid(road)) {
            //effect will set relevant info like target name, have it go first
            await effect.apply(road);
            popup(Game.instance.container);
            return true;
        }
        return false;
    }

}
