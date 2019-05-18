import 'Trigger.dart';

//TODO form shit
class GravesNumberTrigger extends Trigger {
    @override
    String label = "NumberGraves";
    String importantIntLabel = "Graves Greater Than:";

  @override
  bool isTriggeredRaw() {
    return game.graves.length > importantInt;
  }

}