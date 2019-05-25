import 'Trigger.dart';

//TODO form shit
class FundsTrigger extends Trigger {
    @override
    String label = "AmountFunds";
    @override
    String importantIntLabel = "Funds Greater Than:";

  @override
  bool isTriggeredRaw() {
    return game.funds > importantInt;
  }



}