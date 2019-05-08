import 'package:CommonLib/Random.dart';

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../Locations/HuntingGrounds.dart';
import '../Locations/Town.dart';
import '../NPCs/Disease.dart';
import '../NPCs/Tombstone.dart';
import 'dart:html';

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
    testAnimation();
    //testTombstone();
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
    for(int i = 0; i<2; i++) {
        GullAnimation gull = new GullAnimation("pimp");
        gull.frameRateInMS = 20*i+20;
        div.append(gull.element);
    }

}

void testTombstone() {
    Tombstone t = new Tombstone();
    t.drawSelf(div,null);
}