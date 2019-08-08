import '../PhysicalLocation.dart';
import 'dart:html';

class StaticLayer {
    String imageLocation;
    ImageElement image;
    PhysicalLocation parent;
    int zIndex;
    int speed;



    StaticLayer(String this.imageLocation, PhysicalLocation this.parent, int this.zIndex) {
        init();
    }

    StaticLayer.fromImage(ImageElement this.image, PhysicalLocation this.parent, int this.zIndex) {
        init();
    }

    void init() {
        print("initializing $this with image $image");
        if(image == null) {
            print("i reset image to have imagelocation $imageLocation");
            image = new ImageElement(src: imageLocation);
        }else {
            print("i made a tombstone probably, i am $this");
        }
        image.style.zIndex = "$zIndex"; //auto sorts things by speed
        image.style.left = "0px";
        image.classes.add("parallaxLayer");
        parent.container.append(image);
    }

    static styleLikeStaticLayer(DivElement div, int zIndexOrSpeed, int width, int height, int x, int y) {
        div.style.zIndex = "$zIndexOrSpeed"; //auto sorts things by speed
        div.style.left = "${x}px";
        div.style.top = "${y}px";
        div.style.width = "${width} px";
        div.style.height="${height} px";

        div.classes.add("parallaxLayer");

    }
}