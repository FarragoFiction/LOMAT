import 'package:CommonLib/Compression.dart';
import 'package:CommonLib/Random.dart';

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../Locations/HuntingGrounds.dart';
import '../Locations/Town.dart';
import '../NPCs/Disease.dart';
import '../NPCs/LOMATNPC.dart';
import '../NPCs/NonGullLOMATNPC.dart';
import '../NPCs/Tombstone.dart';
import 'dart:html';

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
    //testCiphers();
    loadGulls();
    //loadGull();
    testPhrases();

    //testAnimation();
    //testTombstone();
}

void testPhrases() {
    PassPhraseObject.displayArt(PassPhraseObject.load(), div);
}

void loadGulls() {
    List<LOMATNPC> npcs = List<LOMATNPC>();
    npcs.add(NPCFactory.skol());
    npcs.add(NPCFactory.rogerKoon());
    //i can confirm that right before returning, ebony has the right color
    //and that right AFTER roger is returning ebony has the wrong one.
    //do they somehow share the same palette reference?
    //....VOID PALETTE
    for(LOMATNPC npc in npcs) {
        div.append(npc.animation.element);    }

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

void testTombstone() {
    Tombstone t = new Tombstone();
    t.drawSelf(div,null, false);
}