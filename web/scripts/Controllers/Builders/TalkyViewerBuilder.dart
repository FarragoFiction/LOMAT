import 'dart:html';

import '../../NPCs/LOMATNPC.dart';
import '../../Sections/TalkySection.dart';
import 'GenericBuilder.dart';

class TalkyViewerBuilder extends GenericBuilder {
    LOMATNPC npc;
    DivElement talkyView = new DivElement();
    TalkySection talkySection;

    TalkyViewerBuilder() {
        init();
    }

  @override
  void init() {
      container.setInnerHtml("<h1>Talky Level Builder</h1>");
      container.append(talkyView);
      initDataElement();
  }

  @override
    void load() {
        npc  = LOMATNPC.loadFromDataString(dataStringElement.value);
        print("loaded ${npc.toJSON()}");
        if(talkySection != null) {
            talkySection.teardown();
        }
        talkySection = new TalkySection(npc, talkyView);
  }


}