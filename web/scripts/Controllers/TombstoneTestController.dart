import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../Locations/HuntingGrounds.dart';
import '../NPCs/Tombstone.dart';
import 'dart:html';

DivElement div = querySelector('#output');
void main() {
    Element otherTest = new DivElement()..text = "it is not the Titan, nor the Reaper.";
    div.append(otherTest);
    CipherEngine.applyRandom(otherTest);
    for(int i = 0; i<5; i++) {
        GullAnimation gull = new GullAnimation("pimp");
        gull.frameRateInMS = 20*i+20;
        div.append(gull.element);
    }

    Tombstone t = new Tombstone();
    t.drawSelf(div,null);


}