//displays a popup if triggered and applies an event to the game.

import '../../Game.dart';
import '../../NPCs/LOMATNPC.dart';
import '../../SoundControl.dart';
import '../Road.dart';
import 'Effects/DelayEffect.dart';
import 'Effects/DiseaseEffect.dart';
import 'Effects/Effect.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

import 'Effects/InstaKillEffect.dart';

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
    LOMATNPC requiredPartyMember;
    LOMATNPC antiRequiredPartyMember;

    DivElement container;
    String get fullFlavorText {
        return "$flavorText <br><br>${effect.flavorText}";
    }
    DivElement flavorTextElement;
    DivElement titleElement;

    //1.0 is guaranteed to happen if asked.
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
        //if a specific party member has to exist,
        if(requiredPartyMember != null && !Game.instance.partyMembers.contains(requiredPartyMember)) {
            return false;
        }
        //if, for example, Ebony is in your party, no Grim Events will hit.
        if(antiRequiredPartyMember != null && Game.instance.partyMembers.contains(antiRequiredPartyMember)) {
            return false;
        }

        if((effect is DiseaseEffect || effect is InstaKillEffect) && Game.instance.dangerousMode) {
            await effect.apply(road);
            popup(Game.instance.container);
            return true; //yeah no.
        }else if(Game.instance.dangerousMode) {
            return false; //shhhh, only disease and death now
        }

        if (random.nextDouble() < oddsOfHapening && effect.isValid(road)) {
            //effect will set relevant info like target name, have it go first
            await effect.apply(road);
            popup(Game.instance.container);
            return true;
        }


        return false;
    }

}
