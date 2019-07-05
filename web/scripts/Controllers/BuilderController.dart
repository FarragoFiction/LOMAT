import 'dart:async';

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Compression.dart';
import 'package:CommonLib/Random.dart';

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../Locations/HuntingGrounds.dart';
import '../Locations/Town.dart';
import '../NPCs/Disease.dart';
import '../NPCs/LOMATNPC.dart';
import '../NPCs/NonGullLOMATNPC.dart';
import '../NPCs/PassPhraseHandler.dart';
import '../NPCs/Tombstone.dart';
import 'dart:html';

import '../Sections/TalkySection.dart';
import 'Builders/GenericBuilder.dart';
import 'Builders/NPCBuilder.dart';
import 'Builders/TalkyItemBuilder.dart';
import 'Builders/TalkyLevelBuilder.dart';
import 'Builders/TalkyViewerBuilder.dart';

DivElement div = querySelector('#output');
Map<String, GenericBuilder> navigation = new Map<String, GenericBuilder>();
void main()  async{

    navigation["gull"] = new GullBuilder();
    navigation["nongull"] = new NonGullBuilder();
    navigation["talkyLevel"] = new TalkyLevelBuilder();
    navigation["talkyQuestion"] = new TalkyQuestionBuilder();
    navigation["talkyResponse"] = new TalkyResponseBuilder();
    navigation["talkyRecruit"] = new TalkyRecruitBuilder();
    navigation["talkyViewer"] = new TalkyViewerBuilder(); //todo

    handleNavigation();

    print("hello world");
    //TODO have button to switch between them
    String formType= Uri.base.queryParameters['formType'];
    GenericBuilder builder = navigation[formType];
    if(builder == null) builder = navigation["gull"];
    builder.display(div);
    //PassPhraseHandler.storeTape("fakeafd");
    //LOMATNPC npc = await LOMATNPC.generateRandomNPC(13);
    //div.appendHtml(npc.toDataString());
    //div.append(npc.animation.element);
}

void handleNavigation() {
    DivElement nav = new DivElement()..classes.add("navbar");
    div.append(nav);
    for(String linkText in navigation.keys) {
        AnchorElement a = new AnchorElement(href: "builder.html?formType=$linkText")..text = "$linkText"..classes.add("navitem");
        nav.append(a);
    }
}