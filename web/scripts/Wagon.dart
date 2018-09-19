import 'dart:html';

class Wagon {
    ImageElement imageElement;

    Wagon(Element container) {
        imageElement = new ImageElement(src: "images/Wagon/oooh.gif");
        imageElement.classes.add("wagon");
        container.append(imageElement);

    }
}