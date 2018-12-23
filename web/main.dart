import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'scripts/Locations/Events/Effects/DelayEffect.dart';
import 'scripts/Locations/Events/RoadEvent.dart';
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

//eventually load from JSON
TownGenome  startingGenome() {
  TownGenome ret = new TownGenome(new Random(13),null);
  ret.startText = "You arrive in beautiful INSERTNAMEHERE, the jewel of LOMAT.";
  ret.middleText = "Or at least that's what you'd think if it were in its finished state.  Sadly, it appears to have been shittly drawn by a WASTE or something, and everything in it is in test mode and half finished.";
  ret.endText = " well, beats looking at a blank white screen, you suppose.";
  ret.playList = <String>["Trails_Slice1","Trails_Slice2","Trails_Slice3","Trails_Slice4","Trails_Slice5","Trails_Slice6"];
  ret.foreground = "${TownGenome.foregroundBase}/2.png";
  ret.midGround = "${TownGenome.midgroundBase}/2.png";
  ret.ground = "${TownGenome.groundBase}/1.png";
  ret.background = "${TownGenome.backgroundBase}/1.png";
  DelayEffect smallDelay = new DelayEffect(1000);
  DelayEffect mediumEffect = new DelayEffect(5000);
  DelayEffect largeEffect = new DelayEffect(10000);
  ret.events = new List<RoadEvent>();
  ret.events.add(new RoadEvent("Road Work Being Done","You encounter a group of sqwawking 'ghosts' in the middle of the road. They refuse to move.", smallDelay, 0.5));
  ret.events.add(new RoadEvent("Get Homaged","One of your currently nonexistant party members gets dysentery or something.", mediumEffect, 0.25));
  ret.events.add(new RoadEvent("Absolutely Get Wrecked","BY ODINS LEFT VESTIGAL VENOM SACK, your wago...I mean SWEET VIKING LAND BOAT breaks down.", largeEffect, 0.05));

  return ret;
}
