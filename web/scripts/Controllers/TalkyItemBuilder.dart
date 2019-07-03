import 'dart:convert';
import 'dart:html';

import '../NPCs/TalkyItem.dart';
import '../NPCs/TalkyQuestion.dart';
import '../NPCs/TalkyRecruit.dart';
import '../NPCs/TalkyResponse.dart';

abstract class TalkyItemBuilder {
    DivElement container = new DivElement()..id = "containerBuilder";
    TalkyItem item;
    InputElement textElement = new InputElement();


    TextAreaElement dataStringElement = new TextAreaElement()..cols = 100;

    TalkyItemBuilder() {
    }

    void display(Element parent) {
        print("i'm trying to display $this, but what is happening?");
        parent.append(container);
    }

    void init();

    void syncItemToForm() {
        item.displayText = textElement.value;
        dataStringElement.value = jsonEncode(item.toJSON());
    }

    void loadItem() {
        //here's hoping a null gull is fine
        item  = TalkyItem.loadFromJSON(null,jsonDecode(dataStringElement.value),null);
        if(!(item is TalkyQuestion) && !(this is TalkyQuestionBuilder)){
            window.alert(" WARNING: you are using the wrong builder, this is a question, and this builder is $this");
        }else if(!(item is TalkyResponse) && !(this is TalkyResponseBuilder)) {
            window.alert(" WARNING: you are using the wrong builder, this is a question, and this builder is $this");
        }else if(!(item is TalkyRecruit) && !(this is TalkyRecruitBuilder)) {
            window.alert(" WARNING: you are using the wrong builder, this is a question, and this builder is $this");
        };
        print("loaded ${item.toJSON()}");
        syncFormToItem();
    }

    void syncFormToItem(){
        print("item is $item");
        textElement.value = item.displayText;
        dataStringElement.value = jsonEncode(item.toJSON());
    }


    void initDataElement() {
        DivElement div = new DivElement()..classes.add("formSection");
        LabelElement dataLabel = new LabelElement()..text = "DataString";
        div.append(dataLabel);
        div.append(dataStringElement);
        dataStringElement.onChange.listen((Event e) => loadItem());
        container.append(div);
    }

    void initDisplayTextElement() {
        DivElement div = new DivElement()..classes.add("formSection");;
        LabelElement dataLabel = new LabelElement()..text = "Display Text:";
        div.append(dataLabel);
        div.append(textElement);
        textElement.onInput.listen((Event e) => syncItemToForm());

        container.append(div);
    }

}

class TalkyQuestionBuilder extends TalkyItemBuilder {

    TalkyQuestionBuilder():super() {
        //item = new TalkyQuestion("Question Text");
    }
  @override
  void init() {
    container.text = "TODO: tALKY QUESTIONS";
    initDataElement();
    initDisplayTextElement();
    syncFormToItem();
  }

}

class TalkyResponseBuilder extends TalkyItemBuilder {
    //todo array (list 5) of responses, associated emotion
    TalkyResponseBuilder() {
        item = new TalkyResponse(null,[],"Response Text",0, null);
        init();
    }

    @override
    void init() {
        container.text = "TODO: tALKY responses";
        initDataElement();
        initDisplayTextElement();
        syncFormToItem();
    }
}

class TalkyRecruitBuilder extends TalkyItemBuilder {
    @override
    void init() {
        container.text = "TODO: tALKY recruit whatevers";
        initDataElement();
        initDisplayTextElement();
        syncFormToItem();
    }
}