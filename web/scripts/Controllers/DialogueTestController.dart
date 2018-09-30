import '../Locations/HuntingGrounds.dart';
import '../NPCs/LOMATNPC.dart';
import '../Screens/TalkyScreen.dart';
import 'dart:html';

TalkyScreen screen;
DivElement div = querySelector('#output');
void main() {
    LOMATNPC testNPC = new LOMATNPC();
    screen = new TalkyScreen(testNPC,div);
}