import '../../Road.dart';
import 'Effect.dart';
import 'dart:html';

class ArriveEffect extends Effect {
    @override
    String name = "ArriveEffect";
    @override
    int amount;

    @override
    String get flavorText =>  "You somehow slip in the cracks of reality and arrive immediatly at your destination.";

    ArriveEffect(int this.amount);

  @override
  Future<Null> apply(Road road) async {
    print("applying arrive effect.");
    road.applyArriveEffect();
  }
}