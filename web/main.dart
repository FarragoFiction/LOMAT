import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'scripts/Locations/Town.dart';
import 'scripts/Locations/TownGenome.dart';
import 'scripts/Locations/Trail.dart';
import 'scripts/NPCs/LOMATNPC.dart';

Town town;
DivElement div = querySelector('#output');
void main() {
  town = new Town("city2",<LOMATNPC>[LOMATNPC.generateRandomNPC(1),LOMATNPC.generateRandomNPC(2),LOMATNPC.generateRandomNPC(3)],null,startingGenome());
  town.displayOnScreen(div);
}

TownGenome  startingGenome() {
  TownGenome ret = new TownGenome(new Random(13),null);
  ret.startText = "You arrive in beautiful INSERTNAMEHERE, the jewel of LOMAT.";
  ret.middleText = "Or at least that's what you'd think if it were in its finished state.  Sadly, it appears to have been shittly drawn by a WASTE or something, and everything in it is in test mode and half finished.";
  ret.endText = " well, beats looking at a blank white screen, you suppose.";
  ret.playList = <String>["Trails_Slice1","Trails_Slice2","Trails_Slice3","Trails_Slice4","Trails_Slice5","Trails_Slice6"];
  ret.foreground = "${TownGenome.foregroundBase}/2.png";
  ret.midGround = "${TownGenome.midgroundBase}/2.png";
  ret.ground = "${TownGenome.groundBase}/1.png";
  ret.background = "${TownGenome.backgroundBase}/1.png";;
  return ret;
}
