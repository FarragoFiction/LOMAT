import 'dart:convert';
import 'dart:html';

import 'package:CommonLib/Utility.dart';

import '../NPCs/TalkyItem.dart';
import '../NPCs/TalkyQuestion.dart';
import '../NPCs/TalkyRecruit.dart';
import '../NPCs/TalkyResponse.dart';

abstract class TalkyItemBuilder {
    DivElement container = new DivElement()..id = "containerBuilder";
    TalkyItem item;
    TextAreaElement textElement = new TextAreaElement()..cols = 50..rows = 13;


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
        item  = TalkyItem.loadFromJSON(null,new JsonHandler(jsonDecode(dataStringElement.value)),null);
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
    TextAreaElement responseElement = new TextAreaElement()..cols = 100;
    TalkyQuestion get question => item as TalkyQuestion;
    TalkyQuestionBuilder() {
        TalkyResponse tmp = new TalkyResponse(null,[],"Response Text",0, null);
        item = new TalkyQuestion("Question Text", tmp,null);
        init();
    }
  @override
  void init() {
    container.text = "TODO: tALKY QUESTIONS";
    initDataElement();
    initDisplayTextElement();
    initResponseElement();

    syncFormToItem();
  }

    void initResponseElement() {
        DivElement div = new DivElement()..classes.add("formSection");;
        LabelElement dataLabel = new LabelElement()..text = "Response JSON:";
        div.append(dataLabel);
        div.append(responseElement);
        responseElement.onInput.listen((Event e) => syncItemToForm());

        container.append(div);
    }


    void syncItemToForm() {
        item.displayText = textElement.value;
        question.response = TalkyResponse.loadFromJSON(null,new JsonHandler(jsonDecode(responseElement.value)), null);
        dataStringElement.value = jsonEncode(item.toJSON());
    }


    @override
    void syncFormToItem(){
        responseElement.value = jsonEncode(question.response.toJSON());
        super.syncFormToItem();
    }

}

class TalkyResponseBuilder extends TalkyItemBuilder {
    //todo array (list 5) of responses, associated emotion
    TalkyResponse get response => item as TalkyResponse;

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
    TalkyRecruit get recruit => item as TalkyRecruit;

    void init() {
        container.text = "TODO: tALKY recruit whatevers";
        initDataElement();
        initDisplayTextElement();
        syncFormToItem();
    }
}