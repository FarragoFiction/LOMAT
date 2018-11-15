import '../SoundControl.dart';
import 'PhysicalLocation.dart';
import 'Town.dart';
import 'Trail.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class Road {
    //maybe let progress in the game, or what consorts you have with you (should they have stats???)
    //effect this
    static int minTimeInMS = 100;
    static int maxTimeInMS = 1000;

    Town sourceTown;
    Town destinationTown;
    //distance is voided at first
    int travelTimeInMS;
    //TODO also has events

    Road({this.sourceTown,this.destinationTown, this.travelTimeInMS:13}) {
        //.......once i realized i needed error handing well....one thing lead to another
        if(sourceTown == null) sourceTown = Town.getVoidTown();
        if(destinationTown == null) destinationTown = Town.getVoidTown();

    }

    @override
    String toString() {
        return "${sourceTown} to ${destinationTown} in ${travelTimeInMS} ms.";
    }

    void displayOption(PhysicalLocation prevLocation,Element parent,Element container) {
        Element div = new DivElement()..classes.add("dialogueSelectableItem");
        container.append(div);
        div.setInnerHtml("> $destinationTown (Estimated ${(travelTimeInMS).round()} ms)");

        div.onClick.listen((Event t) {
            container.remove();
            prevLocation.teardown();
            SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
            new Trail(this,prevLocation)..displayOnScreen(parent);
        });
    }

    static List<Road> spawnRandomRoadsForTown(Town town) {
        List<Town> towns = Town.makeAdjacentTowns();
        List<Road> ret = new List<Road>();
        Random rand = new Random();
        towns.forEach((Town destinationTown) {
            ret.add(new Road(sourceTown: town, destinationTown: destinationTown, travelTimeInMS: rand.nextIntRange(minTimeInMS,maxTimeInMS)));
        });
        return ret;
    }

}