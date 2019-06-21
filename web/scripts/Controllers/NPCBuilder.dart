import 'dart:async';

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
    CanvasElement npcView =new CanvasElement();
    InputElement nameElement = new InputElement();
    InputElement hatElement = new InputElement();
    InputElement bodyElement = new InputElement();

    TextAreaElement dataStringElement = new TextAreaElement()..cols = 100;
    DivElement container = new DivElement()..id = "containerBuilder";

    NPCBuilder() {
        npc = NPCFactory.stimpyTigger();
        initNPCView();
        initDataElement();
        initNameElement();
        initHatElement();
        initBodyElement();

        syncFormToNPC();
    }

    Future<void> syncFormToNPC(){
        nameElement.value = npc.name;
        hatElement.value = "${npc.animation.hatNumber}";
        bodyElement.value = "${npc.animation.bodyNumber}";

        dataStringElement.value = npc.toDataString();
        syncAnimation();

    }

    void syncAnimation() async  {
        npc.animation.keepLooping = false; //makes sure it only goes once
        npc.animation.layers.clear();
        npc.animation.init();
        await npc.animation.renderLoop();
        CanvasElement canvas = npc.animation.element;
        npcView.context2D.clearRect(0,0, npcView.width, npcView.height);
        npcView.context2D.drawImage(canvas,0,0);
    }

    void loadNPC() {
        npc  = LOMATNPC.loadFromDataString(dataStringElement.value);
        syncFormToNPC();
    }

    void syncNPCToForm() {
        npc.name = nameElement.value;
        syncNPCAnimationToForm();
        print("I'm syncing the npc to the form, and its name should be ${npc.name}");
        dataStringElement.value = npc.toDataString();
    }

    void syncNPCAnimationToForm() async{
        try {
            npc.animation.bodyNumber = int.parse(bodyElement.value);
            npc.animation.hatNumber = int.parse(hatElement.value);
            syncAnimation();

        } on Exception {
            window.alert("Thats not a valid body or hat Number");
        }
    }

    void initNPCView() {
        CanvasElement canvas = npc.animation.element;
        npcView.width = canvas.width;
        npcView.height = canvas.height;
        container.append(canvas);
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

    void initHatElement() {
        DivElement div = new DivElement()..classes.add("formSection");;
        LabelElement dataLabel = new LabelElement()..text = "Hat Number:";
        div.append(dataLabel);
        div.append(hatElement);
        hatElement.onChange.listen((Event e) => syncNPCToForm());

        container.append(div);
    }

    void initBodyElement() {
        DivElement div = new DivElement()..classes.add("formSection");;
        LabelElement dataLabel = new LabelElement()..text = "Body Number:";
        div.append(dataLabel);
        div.append(bodyElement);
        bodyElement.onChange.listen((Event e) => syncNPCToForm());

        container.append(div);
    }


    void display(Element parent) {
        print("i'm trying to display, but what is happening?");
        parent.append(container);
    }
}
