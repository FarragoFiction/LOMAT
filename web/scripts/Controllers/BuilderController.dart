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
import 'Builders/NPCBuilder.dart';
import 'Builders/TalkyItemBuilder.dart';

DivElement div = querySelector('#output');
void main()  async{
    print("hello world");
    //TODO have button to switch between them
    String formType= Uri.base.queryParameters['formType'];
    if(formType == "gull") {
        GullBuilder builder = new GullBuilder();
        builder.display(div);
    }else if(formType == "nongull") {
        NonGullBuilder builder = new NonGullBuilder();
        builder.display(div);
    }else if(formType == "talkyLevel") {
       window.alert("todo");
    }else if(formType == "talkyQuestion") {
        TalkyItemBuilder builder = new TalkyQuestionBuilder();
        builder.display(div);
    }else if(formType == "talkyResponse") {
        TalkyItemBuilder builder = new TalkyResponseBuilder();
        builder.display(div);
    }else if(formType == "talkyRecruit") {
        TalkyItemBuilder builder = new TalkyRecruitBuilder();
        builder.display(div);
    }else {
        GullBuilder builder = new GullBuilder();
        builder.display(div);
    }
    //PassPhraseHandler.storeTape("fakeafd");
    //LOMATNPC npc = await LOMATNPC.generateRandomNPC(13);
    //div.appendHtml(npc.toDataString());
    //div.append(npc.animation.element);
}
