import 'PhysicalLocation.dart';
import 'dart:async';
import 'dart:html';

//for things that are just procedurally generated parts of the background
//always moves to the left
class ParallaxLayer {
    String imageLocation;
    ImageElement image;
    int speed;
    int frameRate = 100;
    PhysicalLocation parent;
    int width;
    bool removeMePlease = false;

    ParallaxLayer(String this.imageLocation, PhysicalLocation this.parent, int this.speed) {
        init();
        animate();
    }

    void init() {
      image = new ImageElement(src: imageLocation);
      image.style.zIndex = "$speed"; //auto sorts things by speed
      image.style.left = "0px";
      image.classes.add("parallaxLayer");
      parent.container.append(image);
    }

    Future<Null> animate() async{
        if(removeMePlease) return;
        move();
        await window.animationFrame;
        new Timer(new Duration(milliseconds: frameRate), () => animate());
    }


    void move() {
        print("moving");
        int x = int.parse(image.style.left.replaceAll("px", ""));
        x = x - speed;
        //if i am less than -0, no longer on screen, go away
        if(x<0){
            image.remove();
            removeMePlease = true;
            return;
        }
        image.style.left = "${x}px";
    }
}

//for things that are the entire background
//handles auto scrolling through css
//only half is displayed at once
class ParallaxLayerLooping extends ParallaxLayer{
    ImageElement image2;

    ParallaxLayerLooping(String imageLocation, PhysicalLocation parent, int speed) : super(imageLocation, parent, speed);


    void init() {
        super.init();
        image2 = new ImageElement(src: imageLocation);
        image2.style.zIndex = "$speed"; //auto sorts things by speed
        image2.style.left = "1600px"; //at the right side
        image2.classes.add("parallaxLayer");
        parent.container.append(image2);
    }

    @override
    void move() {
        int x = int.parse(image.style.left.replaceAll("px", ""));
        x = x - speed;
        //if i am less than double width (i.e. my own width), go back to start
        int max = -2* parent.width;
        if(x<max) {
            print("resetting x");
            x = 1600-speed;
        }

        int x2 = int.parse(image2.style.left.replaceAll("px", ""));
        x2 = x2 - speed;
        if(x2<max) {
            print("resetting x2");
            x2 = 1600-speed;
        }
        image.style.left = "${x}px";
        image2.style.left = "${x2}px";
    }
}


