import '../Game.dart';
import '../Locations/PhysicalLocation.dart';
import '../SoundControl.dart';
import 'Enemy.dart';
import 'dart:async';
import 'dart:html';
import "dart:math" as Math;

import 'package:CommonLib/Random.dart';

class Bullet {
    ImageElement image;
    int x = 400;
    int y = 590;
    int speed = 17;
    //TODO make sure you actually hook this up
    int costToFire = 1;
    PhysicalLocation location;
    int goalX = 0;
    int goalY = 0;
    bool  removeMePlease = false;
    int frameRate = (1000/30).round();
    static int gristCost = 1;

    double angle;


    Bullet(String imageLocation, PhysicalLocation this.location, int this.goalX, int this.goalY) {
        SoundControl.instance.playSoundEffect("392976__morganpurkis__supersonic-bullet-snap-11");
        image = new ImageElement(src: imageLocation);
        image.classes.add('bullet');
        image.style.zIndex = "4037"; //auto sorts things by speed
        location.container.append(image);
        image.classes.add("parallaxLayer");
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
        new Timer(new Duration(milliseconds: frameRate), () => tick());

    }

    //TODO keep asking your parent if you hit anything, if you did, vanish (or if you went off screen)
    //TODO this is slightly off sometimes from where i would expect it to hit
    void move() {
        //TODO move x and y to be closer to goal, i know i've done this math before but...what was it again?
        //oh right distance is the hypotenuse
        //so i need to calc x = cos and y = sing of the distance
        //which means i'll need to know the angel too. hrm

        int dx = goalX -x ;
        int dy = goalY -y;
        //only do it once or the bullets will stop moving when they get to wear you clicked
        //and its kinda adorable
        if(angle == null) {
            angle = Math.atan2(dy,dx);
        }

        //double angle = 91* 180/Math.PI;

        int newX = x + (speed * Math.cos(angle)).round();
        int newY = y + (speed * Math.sin(angle)).round();
       // print("moving to $newX, $newY, speed is $speed");
        if(newX > location.width || newX < 0) {
            die();
        }

        if(newY > location.height || newY < 0) {
            die();
        }

        x = newX;
        y = newY;
        syncLocation();
        checkHits();

    }

    void die() {
      removeMePlease = true;
      image.remove();
    }

    void checkHits() {
        for(Enemy enemy in location.enemies) {
            if(collision(enemy.image, image)){
                SoundControl.instance.playSoundEffect(enemy.deathSound);
                enemy.die();
                die();
                break;
                //window.alert("hit!!!");
            }
        }
    }


    static bool collision(Element div1, Element div2) {
        int x1 = div1.offset.left;
        int y1 = div1.offset.top;
        int h1 = div1.offsetHeight;
        int w1 = div1.offsetWidth;
        int b1 = y1 + h1;
        int r1 = x1 + w1;
        int x2 = div2.offset.left;
        int y2 = div2.offset.top;
        int h2 = div2.offsetHeight;
        int w2 = div2.offsetWidth;
        int b2 = y2 + h2;
        int r2 = x2 + w2;

        if (b1 < y2 || y1 > b2 || r1 < x2 || x1 > r2) return false;
        return true;
    }




}