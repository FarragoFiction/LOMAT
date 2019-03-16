import '../../../Game.dart';
import '../../../NPCs/Disease.dart';
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

    //so i can refer to them in flavor text.
    String diseaseName;
    String diseaseEffect;

    @override
    String get flavorText =>  "$targetName gets $diseaseName. $diseaseEffect";

    DiseaseEffect();

    //pick a random npc
  @override
  Future<Null> apply(Road road) async {
    print("applying disease effect.");
    Game game = Game.instance;
    target = new Random().pickFrom(game.partyMembers);
    targetName = target.name;
    Disease disease = await Disease.generateProcedural(Disease.convertWordToNumber(road.sourceTown.name));
    diseaseName = disease.name;
    diseaseEffect = disease.description;
    target.addDisease(disease);
  }

  @override
    bool isValid(Road road) {
        Game game = Game.instance;
       return game.partyMembers.isNotEmpty;
    }
}