import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'scripts/Game.dart';
import 'scripts/Locations/Events/Effects/DelayEffect.dart';
import 'scripts/Locations/Events/RoadEvent.dart';
import 'scripts/Locations/Town.dart';
import 'scripts/Locations/TownGenome.dart';
import 'scripts/Locations/TrailLocation.dart';
import 'scripts/NPCs/LOMATNPC.dart';

Town town;
DivElement div = querySelector('#output');
Future<void> main() async{
  Game game = Game.instance;
  await game.initializeNPCS();
  await Town.initVoidTown();
  await game.setStartingTown();
  await game.initializeTowns();

  game.display(div);
}

