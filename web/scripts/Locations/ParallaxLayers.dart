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
        image = new ImageElement(src: imageLocation);
        image.style.zIndex = "$speed"; //auto sorts things by speed
        image.style.left = "0px";
        image.classes.add("parallaxLayer");
        parent.container.append(image);
        animate();
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
  ParallaxLayerLooping(String imageLocation, PhysicalLocation parent, int speed) : super(imageLocation, parent, speed);

    @override
    void move() {
        int x = int.parse(image.style.left.replaceAll("px", ""));
        x = x - speed;
        //if i am less than -width/2, go back to start
        double max = -1* parent.width;
        if(x<max) {
            print("resetting");
            x = 0;
        }
        image.style.left = "${x}px";
    }
}


