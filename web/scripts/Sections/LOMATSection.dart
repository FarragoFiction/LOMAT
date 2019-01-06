import 'dart:html';

abstract class LOMATSection {
    int width = 800;
    int height = 600;
    Element parent;
    Element myContainer;

    //TODO use this for bg details
    Location location;

    LOMATSection(Element this.parent) {
        myContainer = new DivElement()..classes.add("screen");
        parent.append(myContainer);
        init();
    }

    void init();

    void teardown() {
        myContainer.remove();
    }
}