import 'dart:html';
import 'scripts/Locations/Town.dart';
import 'scripts/Locations/Trail.dart';
import 'scripts/NPCs/LOMATNPC.dart';

Town town;
DivElement div = querySelector('#output');
void main() {
  String flavorTown = "You arrive in beautiful CITY2, the jewel of LOMAT. <br><Br>Or at least that's what you'd think if it were in its finished state. Sadly, it appears to have been shittly drawn by a WASTE or something, and everything in it is in test mode and half finished. <br><Br>Oh well, beats looking at a blank white screen, you suppose.";
  town = new Town("city2",flavorTown,div, <LOMATNPC>[LOMATNPC.generateRandomNPC(),LOMATNPC.generateRandomNPC(),LOMATNPC.generateRandomNPC()],null);
}
