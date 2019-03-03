import '../../../Game.dart';
import '../../../NPCs/LOMATNPC.dart';
import '../../Road.dart';
import '../RoadEvent.dart';
import 'Effect.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class InstaKillEffect extends Effect {
    @override
    String name = "InstaKillEffect";
    @override
    int amount;
    String targetName;
    String causeOfDeath;

    @override
    String get flavorText =>  "$targetName dies.";

    InstaKillEffect(String this.causeOfDeath);

    //pick a random npc
  @override
  void apply(Road road, Element popup) {
    print("applying kill effect.");
    Game game = Game.instance;
    LOMATNPC target = new Random().pickFrom(game.partyMembers);
    popup.text.replaceAll("${RoadEvent.PARTYMEMBER}","${target.name}");
    targetName = target.name;
    target.die(causeOfDeath, road);
  }

  @override
    bool isValid(Road road) {
        Game game = Game.instance;
       return game.partyMembers.isNotEmpty;
    }
}