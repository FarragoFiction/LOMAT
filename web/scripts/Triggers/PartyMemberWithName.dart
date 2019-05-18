import '../NPCs/LOMATNPC.dart';
import 'Trigger.dart';

//TODO form shit
class PartyMemberWithName extends Trigger {

    @override
    String label = "PartyMemberWithName";

    @override
    String importantWordLabel = "Has Party Member With Name:";

  @override
  bool isTriggeredRaw() {
    return game.partyMembers.any((LOMATNPC npc) => npc.name == importantWord);
  }

}