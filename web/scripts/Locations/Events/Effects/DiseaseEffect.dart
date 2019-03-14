import '../../../Game.dart';
import '../../../NPCs/LOMATNPC.dart';
import '../../Road.dart';
import '../RoadEvent.dart';
import 'Effect.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class DiseaseEffect extends Effect {
    @override
    String name = "DiseaseEffect";
    @override
    int amount;
    String targetName;
    String causeOfDeath;

    @override
    String get flavorText =>  "$targetName gets a terrible disease.";

    DiseaseEffect(String this.causeOfDeath);

    //pick a random npc
  @override
  Future<Null> apply(Road road, Element popup) async {
    print("applying kill effect.");
    Game game = Game.instance;
    LOMATNPC target = new Random().pickFrom(game.partyMembers);
    if(popup != null) {
        popup.text.replaceAll("${RoadEvent.PARTYMEMBER}", "${target.name}");
    }
    targetName = target.name;
    target.die(causeOfDeath, road);
  }

  @override
    bool isValid(Road road) {
        Game game = Game.instance;
       return game.partyMembers.isNotEmpty;
    }
}