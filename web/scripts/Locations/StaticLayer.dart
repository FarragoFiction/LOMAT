import 'PhysicalLocation.dart';
import 'dart:html';

class StaticLayer {
    String imageLocation;
    ImageElement image;
    PhysicalLocation parent;
    int zIndexOrSpeed;


    StaticLayer(String this.imageLocation, PhysicalLocation this.parent, int this.zIndexOrSpeed) {
        init();
    }

    void init() {
        image = new ImageElement(src: imageLocation);
        image.style.zIndex = "$zIndexOrSpeed"; //auto sorts things by speed
        image.style.left = "0px";
        image.classes.add("parallaxLayer");
        parent.container.append(image);
    }
}