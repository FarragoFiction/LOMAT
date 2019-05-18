import 'Trigger.dart';

//TODO form shit
class PartyNumberTrigger extends Trigger {
    @override
    String label = "NumberParty";
    String importantIntLabel = "Party Members Greater Than:";

  @override
  bool isTriggeredRaw() {
    return game.partyMembers.length > importantInt;
  }

}