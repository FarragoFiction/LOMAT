import 'dart:html';

class Wagon {
    ImageElement imageElement;

    Wagon(Element container) {
        imageElement = new ImageElement(src: "images/Wagon/0.png");
        imageElement.classes.add("wagon");
        container.append(imageElement);

    }
}