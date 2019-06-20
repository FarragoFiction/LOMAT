import 'package:CommonLib/Compression.dart';
import 'package:CommonLib/Random.dart';

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../Locations/HuntingGrounds.dart';
import '../Locations/Town.dart';
import '../NPCs/Disease.dart';
import '../NPCs/LOMATNPC.dart';
import '../NPCs/NonGullLOMATNPC.dart';
import '../NPCs/Tombstone.dart';
import 'dart:html';

import '../Sections/TalkySection.dart';

DivElement div = querySelector('#output');
NPCBuilder builder;
void main()  async{
    print("hello world");
    NPCBuilder builder = new NPCBuilder();
    builder.display(div);
}

//later extend this to make a gull builder, which also has palette etc.
class NPCBuilder {
    LOMATNPC npc;
    InputElement nameElement = new InputElement();
    TextAreaElement dataStringElement = new TextAreaElement()..cols = 100;
    DivElement container = new DivElement()..id = "containerBuilder";

    NPCBuilder() {
        npc = NPCFactory.stimpyTigger();
        initDataElement();
        initNameElement();
        syncFormToNPC();
    }

    void syncFormToNPC() {
        nameElement.value = npc.name;
        dataStringElement.value = npc.toDataString();
    }

    void loadNPC() {
        npc  = LOMATNPC.loadFromDataString(dataStringElement.value);
        syncFormToNPC();
    }

    void syncNPCToForm() {
        npc.name = nameElement.value;
        print("I'm syncing the npc to the form, and its name should be ${npc.name}");
        dataStringElement.value = npc.toDataString();
    }

    void initDataElement() {
        DivElement div = new DivElement()..classes.add("formSection");
        LabelElement dataLabel = new LabelElement()..text = "DataString";
        div.append(dataLabel);
        div.append(dataStringElement);
        dataStringElement.onChange.listen((Event e) => loadNPC());
        container.append(div);
    }

    void initNameElement() {
        DivElement div = new DivElement()..classes.add("formSection");;
        LabelElement dataLabel = new LabelElement()..text = "Name:";
        div.append(dataLabel);
        div.append(nameElement);
        nameElement.onInput.listen((Event e) => syncNPCToForm());

        container.append(div);
    }


    void display(Element parent) {
        print("i'm trying to display, but what is happening?");
        parent.append(container);
    }
}
