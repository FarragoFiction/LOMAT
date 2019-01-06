import '../SoundControl.dart';
import 'Events/Effects/ArriveEffect.dart';
import 'Events/RoadEvent.dart';
import 'PhysicalLocation.dart';
import 'Town.dart';
import 'Trail.dart';
import 'dart:async';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class Road {
    //maybe let progress in the game, or what consorts you have with you (should they have stats???)
    //effect this
    static int minTimeInMS = 1000;
    static int maxTimeInMS = 10000;
    static int maxElapsedTimeInMS= 30000;

    Town sourceTown;
    Town destinationTown;
    bool plzStopKThnxBai = false;
    Trail trail;
    //distance is voided at first
    int travelTimeInMS;
    int timeRemaining;
    int elapsedTime = 0;
    //TODO comes from  source and destination towns
    List<RoadEvent> events = new List<RoadEvent>();

    String get label {
        return "Traveling to $destinationTown: $timeRemaining";
    }

    Element get container => trail.container;

    Road({this.sourceTown,this.destinationTown, this.travelTimeInMS:13}) {
        //.......once i realized i needed error handing well....one thing lead to another
        //road to nowhere is go.
        if(sourceTown == null) sourceTown = Town.getVoidTown();
        if(destinationTown == null) destinationTown = Town.getVoidTown();
        events.addAll(sourceTown.events);
        events.addAll(destinationTown.events);
        timeRemaining = travelTimeInMS;

    }

    void addDelay(int delayInMS) {
        timeRemaining += delayInMS;
        //TODO stop the parallax from happening maybe??? wagon is stopped.
    }

    void applyArriveEffect() {
        trail.arrive();
    }

    String get bg {
        return sourceTown.bg;
    }

    //if this isn't called on arrival, then you will get lots of bad effects
    //such as: events being able to trigger in town or while hunting
    //events from the previous trail applying to the next trail and
    //adding up until their are hundreds and hundreds of events spamming everywhere
    //this is bad. don't let this happen.
    void tearDown() {
        plzStopKThnxBai = true;
    }

    Future<Null> startLoops(Trail trail) async {
        this.trail = trail;
        //wait at least one second before starting because its jarring if you start right off the bat with an event.
        new Timer(new Duration(milliseconds: 1000), () => eventLoop());
        new Timer(new Duration(milliseconds: 1000), () => timerLoop());
    }

    Future<Null> timerLoop() async {
        trail.updateLabel();
        print("elapsed time is $elapsedTime and max time is $maxElapsedTimeInMS");
        if(elapsedTime > maxElapsedTimeInMS && plzStopKThnxBai == false) {
            //handles suddenly arriving out of nowhere.
            new ArriveEffect(0).apply(this);
        }else {
            progressTime();
        }
    }

    void progressTime() {
        if(plzStopKThnxBai == true) {
            return;
        }
      int amount = 1000;
      timeRemaining += -1 * amount;
      elapsedTime += amount;
      if (timeRemaining > 0) {
          new Timer(new Duration(milliseconds: amount), () => timerLoop());
      } else {
          trail.arrive();
      }
    }

    Future<Null> eventLoop() async{
        //no more loop plz.
        if(plzStopKThnxBai) return;
        await window.animationFrame;
        for(RoadEvent event in events) {
            if(event.triggered(this)){
                break;
            }
        }
        //every ten seconds
        new Timer(new Duration(milliseconds: 10000), () => eventLoop());
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