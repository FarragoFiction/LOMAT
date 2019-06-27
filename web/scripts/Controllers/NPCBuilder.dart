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
    Map<String,InputElement> colorList = new Map<String,InputElement>();

    TextAreaElement dataStringElement = new TextAreaElement()..cols = 100;
    DivElement container = new DivElement()..id = "containerBuilder";

    NPCBuilder() {
        npc = NPCFactory.stimpyTigger();
        initNPCView();
        initDataElement();
        initNameElement();
        initHatElement();
        initBodyElement();
        initPaletteElement();
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
        print("syncing animation for ${npc.name}");
        npc.animation.keepLooping = false; //makes sure it only goes once
        npc.animation.layers.clear();
        npc.animation.init();
        CanvasElement canvas = npc.animation.element; //create it if necessary
        await npc.animation.renderLoop();
        print("I'm about to render npc ${npc.name}");
        canvas = npc.animation.element;
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

    void initPaletteElement() {
        for(String s in npc.animation.palette.names) {
            InputElement e = new InputElement()..type = "color";
            e.value = npc.animation.palette[s].toStyleString();
            colorList[s]  = e;
            container.append(e);
        }
    }

    void syncColorsToGull() {
        for(String s in npc.animation.palette.names) {
            colorList[s].value = npc.animation.palette[s].toStyleString();
        }
    }

    void syncGullToColors() {
        for(String s in npc.animation.palette.names) {
            npc.animation.palette.add(s, new Colour.fromStyleString(colorList[s].value), true);
        }
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
