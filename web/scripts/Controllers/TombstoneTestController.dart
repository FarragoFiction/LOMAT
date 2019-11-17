import 'dart:convert';

import 'package:CommonLib/Compression.dart';
import 'package:CommonLib/Random.dart';
import 'package:CommonLib/Utility.dart';

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../Game.dart';
import '../Locations/Events/Effects/ArriveEffect.dart';
import '../Locations/Events/Effects/DelayEffect.dart';
import '../Locations/Events/Effects/DiseaseEffect.dart';
import '../Locations/Events/Effects/Effect.dart';
import '../Locations/Events/Effects/InstaKillEffect.dart';
import '../Locations/Events/Effects/MoneyEffect.dart';
import '../Locations/Events/RoadEvent.dart';
import '../Locations/Fenrir.dart';
import '../Locations/HuntingGrounds.dart';
import '../Locations/Town.dart';
import '../NPCs/Disease.dart';
import '../NPCs/LOMATNPC.dart';
import '../NPCs/NonGullLOMATNPC.dart';
import '../NPCs/Tombstone.dart';
import 'dart:html';

import '../PassPhrases/PassPhraseHandler.dart';
import '../PassPhrases/PassPhraseObject.dart';
import '../Sections/TalkySection.dart';

DivElement div = querySelector('#output');
void main()  async{
    /*
    for(int i = 0; i<3; i++) {
        await testDisease();
    }
    for(int i = 0; i<10; i++) {
        await testTown();
    }*/
    //testPhrases();
    testAmagalmationMode();
    //testEnding();
    //testEvents();
   // testYN();
    //testCiphers();
    //loadGulls();
    //loadGull();

    //testAnimation();
    //testTombstone();
}

void testAmagalmationMode() {
    Fenrir.amaglamationMode(div);
}

void testEnding() {
    div.appendHtml("HI WRANGLERS, BELOW IS THE *STORY* FORM OF THE ENDING, WITH ALL THREE TIMELINES VISIBLE SO YOU CAN GIVE FEEDBACK. BELOW *THAT* WILL BE SCRAMBLED *PUZZLE* FORM<BR><BR>");
    DivElement next = new DivElement();
    next.style.backgroundColor = "white";
    next.appendHtml("Three Versions:");
    String ft = LZString.decompressFromEncodedURIComponent(Fenrir.friendText);
    String ot = LZString.decompressFromEncodedURIComponent(Fenrir.observerText);
    String ht = LZString.decompressFromEncodedURIComponent(Fenrir.inheritanceText);
    String gt = LZString.decompressFromEncodedURIComponent(Fenrir.gigglesnortText);
    DivElement friend = new DivElement()..setInnerHtml("<h1>Friend</h1>$ft");
    DivElement observer = new DivElement()..setInnerHtml("<h1>Observer</h1>$ot");
    DivElement heir = new DivElement()..setInnerHtml("<h1>Inheritance</h1>$ht");
    next.append(friend);
    next.append(observer);
    next.append(heir);
    div.append(next);
    Fenrir.printText(next);

}

void testYN() {
    NonGullLOMATNPC yn = NPCFactory.yn(new Random());
    TalkySection talkySection = new TalkySection(yn, div);
    div.appendHtml("${yn.toDataString()}");
}

void testEvents() {
    Effect largeEffect = new MoneyEffect(-3);
    DelayEffect largeEffectBackwards = new DelayEffect(13)..image.src = "images/EventIcons/raidho.png";
    LOMATNPC ebony = NPCFactory.ebony();
    RoadEvent event = new RoadEvent("Test", "Don't worry about it. It's probably fine.", largeEffect,1);
    event.popup(div);
}

void testPhrases() {
    //PassPhraseObject.displayArt(PassPhraseObject.load(), div);
    print("leaking passphrase");
    PassPhraseHandler.leak();
}

void loadGulls() {
    List<LOMATNPC> npcs = List<LOMATNPC>();
    npcs.add(NPCFactory.halja());
    //i can confirm that right before returning, ebony has the right color
    //and that right AFTER roger is returning ebony has the wrong one.
    //do they somehow share the same palette reference?
    //....VOID PALETTE
    for(LOMATNPC npc in npcs) {
        if(npc is NonGullLOMATNPC) {
            div.append((npc as NonGullLOMATNPC).avatar);
        }else {
            div.append(npc.animation.element);
        }
    }

}

Future<Null> testDisease() async {
    Element otherTest = new DivElement()..text = "TODO: some disease shit";
    Disease disease = await Disease.generateProcedural(new Random().nextInt());
    otherTest.text = "${disease.name}. ${disease.description}";
    div.append(otherTest);

}

Future<Null> testTown() async {
    Element otherTest = new DivElement()..text = "TODO: some disease shit";
    String name = await Town.generateProceduralName(new Random().nextInt());
    Town town = await Town.generateProceduralTown(new Random());
    otherTest.text = "${name}<Br>or${town.name} with description ${town.introductionText}";
    div.append(otherTest);

}

void testCiphers() {
    Element otherTest = new DivElement()..text = "it is not the Titan, nor the Reaper.";
    div.append(otherTest);
    CipherEngine.applyRandom(otherTest);
}

void testAnimation() {
    print("testing animation");
    List<int> options = <int> [1,2,3,4,5];
    Random rand = new Random();
    for(int i = 0; i<5; i++) {
        GullAnimation gull = new GullAnimation(rand.pickFrom(options),rand.pickFrom(options), GullAnimation.randomPalette);
        gull.frameRateInMS = 20*i+20;
        div.append(gull.element);
    }

}

Future<void> testTombstone() async{
    Tombstone t = new Tombstone.withoutNPC("JRTest", "JRBurg","getting wasted");
    t.setID(13);
    div.appendHtml("${t.toJSON()}");
    t.drawSelf(div,null, true);
    Tombstone.loadFromTIMEHOLE();
    ImageElement waitedImage = await t.image;
    div.append(waitedImage);
    queryTimehole();
}

Future<void> queryTimehole() async{

    await Tombstone.loadFromTIMEHOLE();
    List<Tombstone> graves = Game.instance.graves;
    for(Tombstone t in graves) {
        ImageElement waitedImage = await t.image;
        div.append(waitedImage);
    }

}