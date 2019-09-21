import 'package:CommonLib/Collection.dart';

import '../Game.dart';
import '../NPCs/LOMATNPC.dart';
import '../NPCs/Tombstone.dart';
import '../SoundControl.dart';
import 'Events/Effects/ArriveEffect.dart';
import 'Events/Effects/DelayEffect.dart';
import 'Events/RoadEvent.dart';
import 'PhysicalLocation.dart';
import 'Town.dart';
import 'TrailLocation.dart';
import 'dart:async';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class Road {
    //maybe let progress in the game, or what consorts you have with you (should they have stats???)
    //effect this
    static int minTimeInS = 1;
    static int maxTimeInS = 4;
    //manic says multiple of 3.43 seconds are best for music reasons
    static int maxElapsedTimeInMS= DelayEffect.measureUnitInMS * 100;

    Town sourceTown;
    List<Tombstone> tombstones = new List<Tombstone>();
    Town destinationTown;
    bool plzStopKThnxBai = false;
    TrailLocation trail;
    //distance is voided at first
    int travelTimeInMS;
    int timeRemaining;
    int elapsedTime = 0;
    //TODO comes from  source and destination towns
    WeightedList<RoadEvent> events = new WeightedList<RoadEvent>();

    String get label {
        return "Traveling to $destinationTown: $timeRemaining";
    }

    Element get container => trail.container;

    Road({this.sourceTown,this.destinationTown, this.travelTimeInMS:13}) {
        //.......once i realized i needed error handing well....one thing lead to another
        //road to nowhere is go.
        if(sourceTown == null) {
            print("source town was null, but destination town is ${destinationTown}");
            sourceTown = Town.voidTown;
        }
        if(destinationTown == null) {
            print("destination town was null, but source town is ${sourceTown}");
            destinationTown = Town.voidTown;
        }
        events.addAll(sourceTown.events);
        events.addAll(destinationTown.events);
        Game.instance.partyMembers.forEach((LOMATNPC npc) {
            npc.partyEvents.forEach((RoadEvent event) {
                event.requiredPartyMember = npc;
                events.add(event);
            });        });

        sourceTown.npcs.forEach((LOMATNPC npc) {
            npc.roadEvents.forEach((RoadEvent event) {
                event.requiredPartyMember = npc;
                events.add(event);
            });        });

        destinationTown.npcs.forEach((LOMATNPC npc) {
            npc.roadEvents.forEach((RoadEvent event) {
                event.requiredPartyMember = npc;
                events.add(event);
            });
        });

        timeRemaining = travelTimeInMS;
        loadTombstones();

    }

    void loadTombstones() {
        tombstones = Game.instance.tombstonesForRoad(this);
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

    Future<Null> startLoops(TrailLocation trail) async {
        this.trail = trail;
        this.tombstones.shuffle();
        //wait at least one second before starting because its jarring if you start right off the bat with an event.
        new Timer(new Duration(milliseconds: Game.instance.eventAmount), () => eventLoop());
        new Timer(new Duration(milliseconds: Game.instance.diseaseAmount), () => diseaseLoop());
        new Timer(new Duration(milliseconds: Game.instance.travelAmount), () => timerLoop());

    }

    void stop() {
        //window.alert("going to stop");
        plzStopKThnxBai = true;
        trail.hide();

    }

    void start() {
        plzStopKThnxBai = false;
        trail.show();

        //start it back up
        startLoops(trail);

    }

    Future<Null> timerLoop() async {
        print("plz stop is $plzStopKThnxBai");
        if(plzStopKThnxBai == true) {
            return;
        }
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
      int amount = Game.instance.travelAmount;

      timeRemaining += -1 * amount;
      elapsedTime += amount;
      Game.instance.travelTick();
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
        bool eventHappened = false;
        //yes, if there are dead gulls on a trail it makes events less likely
        Random rand = new Random();
        print("event loop is happening, about to test tombstones, count is ${tombstones.length}");
        for(Tombstone tombstone in tombstones) {
            if(rand.nextBool()) {
                print("going to spawn a trailsona for a tombstone");
                tombstone.spawnTrailsona(trail,this);
                eventHappened = true;
                tombstones.remove(tombstone); // can i avoid a concurrent modification via breaks?
                break;
            }
        }

        if(!eventHappened) {
            for (RoadEvent event in events) {
                if (await event.triggered(this)) {
                    eventHappened = true;
                    break;
                }
            }
        }
        //every ten seconds
        new Timer(new Duration(milliseconds: Game.instance.eventAmount), () => eventLoop());
    }

    Future<Null> diseaseLoop() async{
        //no more loop plz.
        if(plzStopKThnxBai) return;
        await window.animationFrame;
        List<LOMATNPC> copyOfParty = new List<LOMATNPC>.from(Game.instance.partyMembers);
        //no concurrent mod plz
        for(LOMATNPC npc in copyOfParty) {
            npc.diseaseTick(this);
        }
        //every ten seconds
        new Timer(new Duration(milliseconds: Game.instance.diseaseAmount), () => diseaseLoop());
    }


    @override
    String toString() {
        return "${sourceTown} to ${destinationTown} in ${travelTimeInMS} ms.";
    }

    void displayOption(PhysicalLocation prevLocation,Element parent,Element container) {
        Element div = new DivElement()..classes.add("dialogueSelectableItem");
        div.classes.add("travelOption");
        container.append(div);
        String before = "";
        if(destinationTown.firstTime == true) before = "[NEW!!!]";
        div.setInnerHtml("> $destinationTown (Estimated Cost: ${((travelTimeInMS/Game.instance.travelAmount)* Game.instance.costPerTravelTick).round()} funds for ${Game.instance.partyMembers.length} gulls) $before");

        div.onClick.listen((Event t) {
            container.remove();
            prevLocation.teardown();
            SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
            new TrailLocation(this,prevLocation)..displayOnScreen(parent);
        });
    }

    static void shitGoBack(Element container) {
        Element div = new DivElement()..classes.add("dialogueSelectableItem");
        div.classes.add("travelOption");
        container.append(div);
        String before = "";
        div.setInnerHtml("Wait, Shit, Go Back.");

        div.onClick.listen((Event t) {
            container.remove();
            SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
        });
    }

    static Future<List<Road>> spawnRandomRoadsForTown(Town town) async {
        Random rand = new Random(Town.nextTownSeed);
        List<Town> towns = await Town.makeAdjacentTowns(rand,town);
        List<Road> ret = new List<Road>();
        towns.forEach((Town destinationTown) {
            ret.add(new Road(sourceTown: town, destinationTown: destinationTown, travelTimeInMS: DelayEffect.measureUnitInMS *rand.nextIntRange(minTimeInS,maxTimeInS)));
        });
        return ret;
    }

}