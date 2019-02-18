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
    for(int i = 0; i<13; i++) {
        GullAnimation gull = new GullAnimation("pimp");
        div.append(gull.element);
    }

    Tombstone t = new Tombstone();
    t.drawSelf(div);


}