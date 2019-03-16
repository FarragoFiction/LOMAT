import '../../Road.dart';
import 'Effect.dart';
import 'dart:html';

class DelayEffect extends Effect {
    //manic says things should stop at measure marks which are 3.43 seconds for music reasons
    static int measureUnitInMS = 3430;
    @override
    String name = "DelayEffect";
    @override
    int amount;

    @override
    String get flavorText =>  "It will take $amount more milliseconds of travel time to arrive now.";

    DelayEffect(int numUnits) {
        amount = numUnits * measureUnitInMS;
    }

  @override
  Future<Null> apply(Road road) async {
    print("applying delay effect.");
    road.addDelay(amount);
  }
}