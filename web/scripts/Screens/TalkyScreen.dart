import '../NPCs/LOMATNPC.dart';
import 'LOMATScreen.dart';
import 'dart:html';

class TalkyScreen extends LOMATScreen {
  LOMATNPC npc;
  TalkyScreen(LOMATNPC this.npc,Element parent) : super(parent);

  @override
  void init() {
    // TODO: implement init
  }
}