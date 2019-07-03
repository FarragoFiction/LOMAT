import 'dart:html';

class TalkyItemBuilder {
    DivElement container = new DivElement()..id = "containerBuilder";
    void display(Element parent) {
        print("i'm trying to display, but what is happening?");
        parent.append(container);
    }
}