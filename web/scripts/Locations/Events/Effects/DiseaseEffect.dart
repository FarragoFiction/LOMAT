import '../../../Game.dart';
import '../../../NPCs/Disease.dart';
import '../../../NPCs/LOMATNPC.dart';
import '../../Road.dart';
import '../RoadEvent.dart';
import 'Effect.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class DiseaseEffect extends Effect {
    ImageElement image = new ImageElement(src: "images/EventIcons/sick.png");

    @override
    String name = "DiseaseEffect";
    @override
    int amount;
    Disease disease;


    //so i can refer to them in flavor text.
    String diseaseName;
    String diseaseEffect;

    @override
    String get flavorText =>  "${RoadEvent.PARTYMEMBER} gets $diseaseName. $diseaseEffect";

    DiseaseEffect([Disease disease]);

    //pick a random npc
  @override
  Future<Null> apply(Road road) async {
    print("applying disease effect.");
    Game game = Game.instance;
    target = new Random().pickFrom(game.partyMembers);
    targetName = target.name;
    if(disease == null) {
        disease = await Disease.generateProcedural(
            Disease.convertWordToNumber(road.sourceTown.name));
    }
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