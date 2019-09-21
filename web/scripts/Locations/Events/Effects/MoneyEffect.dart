import '../../Road.dart';
import 'Effect.dart';
import 'dart:html';

class MoneyEffect extends Effect {
    @override
    ImageElement image = new ImageElement(src: "images/EventIcons/more_dosh.png");
    @override
    String name = "MoneyEffect";
    @override
    int amount;

    @override
    String get flavorText =>  "You get $amount more funds for the party!";

    MoneyEffect(int this.amount) {
        if(amount < 0) {
            image.src = "images/EventIcons/less_dosh.png";
        }
    }

  @override
  Future<Null> apply(Road road) async {
    print("applying delay effect.");
    road.addDosh(amount);
  }
}