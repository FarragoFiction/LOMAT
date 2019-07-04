import 'dart:html';

abstract class GenericBuilder {
    TextAreaElement dataStringElement = new TextAreaElement()..cols = 100;
    DivElement container = new DivElement()..id = "containerBuilder";

    void display(Element parent) {
        print("i'm trying to display $this, but what is happening?");
        parent.append(container);
    }

    void init();

    void load();


    void initDataElement() {
        DivElement div = new DivElement()..classes.add("formSection");
        LabelElement dataLabel = new LabelElement()..text = "DataString";
        div.append(dataLabel);
        div.append(dataStringElement);
        dataStringElement.onChange.listen((Event e) => load());
        container.append(div);
    }

}