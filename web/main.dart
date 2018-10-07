import 'dart:html';
import 'scripts/Locations/Town.dart';
import 'scripts/Locations/Trail.dart';
import 'scripts/NPCs/LOMATNPC.dart';

Town town;
DivElement div = querySelector('#output');
void main() {
  town = new Town("city2",div, <LOMATNPC>[LOMATNPC.generateRandomNPC()]);
}
