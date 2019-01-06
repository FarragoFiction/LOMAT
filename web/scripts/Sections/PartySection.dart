import '../NPCs/LOMATNPC.dart';
import 'LOMATSection.dart';
import 'dart:html';

//TODO
class PartySection extends LOMATSection {
  PartySection(Element parent) : super(parent);

  @override
  void init() {
    myContainer.classes.add("talkyScreen");
  }
}