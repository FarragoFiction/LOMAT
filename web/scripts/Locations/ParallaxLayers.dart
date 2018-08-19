import 'PhysicalLocation.dart';
import 'dart:async';
import 'dart:html';

//for things that are just procedurally generated parts of the background
//always moves to the left
class ParallaxLayer {
    String imageLocation;
    ImageElement image;
    int speed;
    int frameRate = 77;
    PhysicalLocation parent;
    int width;
    bool removeMePlease = false;

    ParallaxLayer(String this.imageLocation, PhysicalLocation parent, int this.speed) {
        image = new ImageElement(src: imageLocation);
        image.style.zIndex = "$speed px"; //auto sorts things by speed
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
        int x = int.parse(image.style.left);
        x = x - speed;
        //if i am less than -0, no longer on screen, go away
        if(x<0){
            image.remove();
            removeMePlease = true;
            return;
        }
        image.style.left = "$x px";
    }
}

//for things that are the entire background
//handles auto scrolling through css
//only half is displayed at once
class ParallaxLayerLooping extends ParallaxLayer{
  ParallaxLayerLooping(String imageLocation, PhysicalLocation parent, int speed) : super(imageLocation, parent, speed);

    @override
    void move() {
        int x = int.parse(image.style.left);
        x = x - speed;
        //if i am less than -width/2, go back to start
        if(x<parent.width/2*-1) x = 0;
        image.style.left = "$x px";
    }
}


