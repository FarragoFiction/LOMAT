import '../SoundControl.dart';
import 'Events/RoadEvent.dart';
import 'PhysicalLocation.dart';
import 'Town.dart';
import 'Trail.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class Road {
    //maybe let progress in the game, or what consorts you have with you (should they have stats???)
    //effect this
    static int minTimeInMS = 1000;
    static int maxTimeInMS = 10000;

    Town sourceTown;
    Town destinationTown;
    //distance is voided at first
    int travelTimeInMS;
    //TODO comes from  source and destination towns
    List<RoadEvent> events = new List<RoadEvent>();

    String get label {
        return "Traveling to $destinationTown";
    }

    Road({this.sourceTown,this.destinationTown, this.travelTimeInMS:13}) {
        //.......once i realized i needed error handing well....one thing lead to another
        if(sourceTown == null) sourceTown = Town.getVoidTown();
        if(destinationTown == null) destinationTown = Town.getVoidTown();

    }

    void addDelay(int delayInMS) {
        travelTimeInMS += delayInMS;
        //TODO stop the parallax from happening maybe??? wagon is stopped.
    }

    String get bg {
        return sourceTown.bg;
    }



    @override
    String toString() {
        return "${sourceTown} to ${destinationTown} in ${travelTimeInMS} ms.";
    }

    void displayOption(PhysicalLocation prevLocation,Element parent,Element container) {
        Element div = new DivElement()..classes.add("dialogueSelectableItem");
        container.append(div);
        String before = "";
        if(destinationTown.firstTime == true) before = "[NEW!!!]";
        div.setInnerHtml("> $destinationTown (Estimated ${(travelTimeInMS).round()} ms) $before");

        div.onClick.listen((Event t) {
            container.remove();
            prevLocation.teardown();
            SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
            new Trail(this,prevLocation)..displayOnScreen(parent);
        });
    }

    static List<Road> spawnRandomRoadsForTown(Town town) {
        Random rand = new Random(Town.nextTownSeed);
        List<Town> towns = Town.makeAdjacentTowns(rand,town);
        List<Road> ret = new List<Road>();
        towns.forEach((Town destinationTown) {
            ret.add(new Road(sourceTown: town, destinationTown: destinationTown, travelTimeInMS: rand.nextIntRange(minTimeInMS,maxTimeInMS)));
        });
        return ret;
    }

}