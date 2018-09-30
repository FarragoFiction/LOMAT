import 'dart:html';

class LOMATScreen {
    int width = 800;
    int height = 600;
    Element parent;
    Element myContainer;

    //TODO use this for bg details
    Location location;

    LOMATScreen(Element this.parent) {
        myContainer = new DivElement()..classes.add("screen");
        parent.append(myContainer);

    }

}