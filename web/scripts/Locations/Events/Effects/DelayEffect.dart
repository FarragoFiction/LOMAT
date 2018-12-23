import '../../Road.dart';
import 'Effect.dart';

class DelayEffect extends Effect {
    @override
    String name = "DelayEffect";
    @override
    int amount;

    @override
    String get flavorText =>  "It will take $amount more milliseconds of travel time to arrive now.";

    DelayEffect(int this.amount);

  @override
  void apply(Road road) {
    print("applying delay effect.");
    road.addDelay(amount);
  }
}