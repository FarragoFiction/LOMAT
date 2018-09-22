import 'dart:html';
//a physical location, what happens there is different for different locations
abstract class PhysicalLocation {
    int get width {
        return int.parse(container.style.width);
    }

    int get height {
        return int.parse(container.style.height);
    }

    Element parent;
    Element container;
    //int width = 800;
    PhysicalLocation(Element this.parent) {
        container = new DivElement();
        container.classes.add("parallaxParent");
        print("class added, width is ${container.style.width}");
        parent.append(container);
        init();
    }
    void init();
}