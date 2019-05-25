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
    loadGull();
    //testAnimation();
    //testTombstone();
}

void loadGull() {
    LOMATNPC npc = NPCFactory.stimpyTigger();
    div.appendText("the loaded npc's name is ${npc.name} and i expected it to be stimpy tigger");
    TalkySection ts = new TalkySection(npc, div);

    NonGullLOMATNPC nonGull = NPCFactory.lilscumbag();
    div.appendText("the loaded npc's name is ${npc.name} and i expected it to be stimpy tigger");
    div.append(nonGull.avatar);

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
    t.drawSelf(div,null);
}