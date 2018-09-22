import 'dart:html';
//a physical location, what happens there is different for different locations
abstract class PhysicalLocation {

    Element parent;
    Element container;
    int width = 800;
    int height = 600;
    PhysicalLocation(Element this.parent) {
        container = new DivElement();
        container.classes.add("parallaxParent");
        print("class added, width is ${container.style.width}");
        parent.append(container);
        init();
    }
    void init();
}