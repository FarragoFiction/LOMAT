import '../../../Game.dart';
import '../../../NPCs/LOMATNPC.dart';
import '../../Road.dart';
import '../RoadEvent.dart';
import 'Effect.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class InstaKillEffect extends Effect {
    @override
    ImageElement image = new ImageElement(src: "images/EventIcons/instagib.png");

    @override
    String name = "InstaKillEffect";
    @override
    int amount;
    String targetName;
    String targetDestination;
    String causeOfDeath;

    @override
    String get flavorText =>  "$targetName dies. Now they will never get to ${targetDestination}";

    InstaKillEffect(String this.causeOfDeath);

    //pick a random npc
  @override
  Future<Null> apply(Road road) async{
    print("applying kill effect.");
    Game game = Game.instance;
    target = new Random().pickFrom(game.partyMembers);

    targetName = target.name;
    targetDestination = target.goalTownName;
    target.die(causeOfDeath, road);
  }

  @override
    bool isValid(Road road) {
        Game game = Game.instance;
       return game.partyMembers.isNotEmpty;
    }
}