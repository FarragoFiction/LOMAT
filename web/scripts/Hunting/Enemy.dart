import '../Locations/Layers/ProceduralLayer.dart';
import '../Locations/PhysicalLocation.dart';
import 'dart:html';

import 'package:CommonLib/Random.dart';

/*
    enemies have an image and have an ai
 */
class Enemy {
    ImageElement image;
    int x = 0;
    int y = 0;
    int speed = 13;
    int gristDropped = 13;
    PhysicalLocation location;
    double direction = 0.0; //mostly they'll just go forwards and backwards but whatever, could need diff directions in a sub class
    int height;
    bool removeMePlease = true;

    Enemy(this.x, int this.y,int this.height,String imageLocation,  int this.speed,double this.direction,PhysicalLocation this.location) {
        image = new ImageElement(src: imageLocation);
        image.classes.add('enemy');
        int z = ProceduralLayer.yToZIndex(y,height);
        image.id = "zShouldBe$z";
        image.style.zIndex = "$z"; //auto sorts things by speed
        location.container.append(image);
        image.classes.add("parallaxLayer");
        image.height = height;

        syncLocation();
    }

    void syncLocation() {
        image.style.left = "${x}px";
        image.style.top = "${y}px";

    }

    //sub classes override this to move a differnet way (such as at an angle
    void tick() {
        x += (speed*direction).ceil();
    }

    void die() {
        removeMePlease = true;
        image.remove();
    }


    static Enemy spawnImps(PhysicalLocation parent, int seed) {
        print("doing imp)");
        int maxX = 800;
        int maxY = 290;
        Random rand = new Random(seed);
        List<String> enemyLocations = <String>["0.png"];
        int y = rand.nextInt(maxY);
        int height = (60*((y/maxY*2))).ceil()+30;
        y += 300-height;
        List<double> directions = <double>[-1.0, 1.0];
        return new Enemy(rand.nextInt(maxX), y,height, "images/Enemies/${rand.pickFrom(enemyLocations)}",13,rand.pickFrom(directions), parent);
    }



}