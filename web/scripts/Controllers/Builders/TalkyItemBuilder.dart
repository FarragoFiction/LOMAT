import 'dart:convert';
import 'dart:html';

import 'package:CommonLib/Utility.dart';

import '../../NPCs/TalkyItem.dart';
import '../../NPCs/TalkyLevel.dart';
import '../../NPCs/TalkyQuestion.dart';
import '../../NPCs/TalkyRecruit.dart';
import '../../NPCs/TalkyResponse.dart';
import 'GenericBuilder.dart';


abstract class TalkyItemBuilder extends GenericBuilder {
    TalkyItem item;
    TextAreaElement textElement = new TextAreaElement()..cols = 50..rows = 13;

    TalkyItemBuilder() {
    }


    void syncItemToForm() {
        item.displayText = textElement.value;
        dataStringElement.value = jsonEncode(item.toJSON());
    }

    void load() {
        //here's hoping a null gull is fine
        item  = TalkyItem.loadFromJSON(null,new JsonHandler(jsonDecode(dataStringElement.value)),null);
        if((item is TalkyQuestion) && !(this is TalkyQuestionBuilder)){
            window.alert(" WARNING: you are using the wrong builder, this is a question, and this builder is $this");
        }else if((item is TalkyResponse) && !(this is TalkyResponseBuilder)) {
            window.alert(" WARNING: you are using the wrong builder, this is a question, and this builder is $this");
        }else if((item is TalkyRecruit) && !(this is TalkyRecruitBuilder)) {
            window.alert(" WARNING: you are using the wrong builder, this is a question, and this builder is $this");
        };
        print("loaded ${item.toJSON()} and text is ${item.displayText}");
        syncFormToItem();
    }

    void syncFormToItem(){
        print("item is $item");
        textElement.value = item.displayText;
        dataStringElement.value = jsonEncode(item.toJSON());
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


    @override
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
    //TODO ability to take in a single talky level
    TalkyResponse get response => item as TalkyResponse;
    SelectElement emotionElement = new SelectElement();
    TextAreaElement talkyLevelElement = new TextAreaElement()..cols = 100;

    TalkyResponseBuilder() {
        item = new TalkyResponse(null,[],"Response Text",0, null);
        response.associatedEmotion = TalkyItem.NEUTRAL;
        init();
    }

    @override
    void init() {
        container.text = "TODO: tALKY responses (item, sub questions)";
        initDataElement();
        initDisplayTextElement();
        initEmotionElement();
        initLevelElement();
        syncFormToItem();
    }

    @override
    void syncItemToForm() {
        response.associatedEmotion = int.parse(emotionElement.options[emotionElement.selectedIndex].value);
        response.talkyLevel = TalkyLevel.loadFromJSON(null,new JsonHandler(jsonDecode(talkyLevelElement.value)));
        super.syncItemToForm();
    }

    @override
    void syncFormToItem() {
        for(OptionElement option in emotionElement.options) {
            if(int.parse(option.value) == response.associatedEmotion) {
                option.selected = true;
            }
        }
        talkyLevelElement.value = jsonEncode(response.talkyLevel.toJSON());
        super.syncFormToItem();
    }

    void initLevelElement() {
        DivElement div = new DivElement()..classes.add("formSection");;
        LabelElement dataLabel = new LabelElement()..text = "SubQuestions (level) JSON:";
        div.append(dataLabel);
        div.append(talkyLevelElement);
        talkyLevelElement.onInput.listen((Event e) => syncItemToForm());

        container.append(div);
    }

    void initEmotionElement() {
        Map<String, int> emotions = new Map<String, int>();
        emotions["HAPPY"] = TalkyItem.HAPPY;
        emotions["NEUTRAL"] = TalkyItem.NEUTRAL;
        emotions["SAD"] = TalkyItem.SAD;
        for(String emotion in emotions.keys) {
            OptionElement option = new OptionElement();
            option.value = "${emotions[emotion]}";
            option.label = emotion;
            if(emotions[emotion] == response.associatedEmotion) {
                option.selected = true;
            }
            emotionElement.append(option);
        }
        LabelElement dataLabel = new LabelElement()..text = "Associated Emotion:";
        container.append(dataLabel);
        container.append(emotionElement);
        emotionElement.onInput.listen((Event e) => syncItemToForm());

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