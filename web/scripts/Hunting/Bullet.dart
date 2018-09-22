import '../Locations/PhysicalLocation.dart';
import 'dart:async';
import 'dart:html';
import "dart:math" as Math;

class Bullet {
    ImageElement image;
    int x = 400;
    int y = 590;
    int speed = 13;
    PhysicalLocation location;
    int goalX = 0;
    int goalY = 0;
    bool  removeMePlease = false;
    int frameRate = (1000/30).round();


    Bullet(String imageLocation, PhysicalLocation this.location, int this.goalX, int this.goalY) {
        image = new ImageElement(src: imageLocation);
        image.classes.add('bullet');
        image.style.zIndex = "4037"; //auto sorts things by speed
        location.container.append(image);
        image.classes.add("parallaxLayer");
        //TODO animate traveling to goal location
        syncLocation();
        tick();

    }

    void syncLocation() {
        image.style.left = "${x}px";
        image.style.top = "${y}px";
    }

    Future<Null> tick() async {
        if(removeMePlease) {
            return;
        }
        move();
        await window.animationFrame;
        new Timer(new Duration(milliseconds: frameRate), () => move());

    }

    //TODO keep asking your parent if you hit anything, if you did, vanish (or if you went off screen)
    void move() {
        //TODO move x and y to be closer to goal, i know i've done this math before but...what was it again?
        //oh right distance is the hypotenuse
        //so i need to calc x = cos and y = sing of the distance
        //which means i'll need to know the angel too. hrm

        double angle = 0.0;

        int newX = (speed * Math.cos(angle)).ceil();
        int newY = (speed * Math.sin(angle)).ceil();
        if(newX > location.width || newX < 0) {
            removeMePlease = true;
            image.remove();
        }

        if(newY > location.height || newY < 0) {
            removeMePlease = true;
            image.remove();
        }

        x = newX;
        y = newY;
        syncLocation();

    }


}