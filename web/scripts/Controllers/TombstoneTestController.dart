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
    GullAnimation gull = new GullAnimation("pimp");
    div.append(gull.element);

    GullAnimation gull2 = new GullAnimation("pimp");
    div.append(gull2.element);

    Tombstone t = new Tombstone();
    t.drawSelf(div);


}