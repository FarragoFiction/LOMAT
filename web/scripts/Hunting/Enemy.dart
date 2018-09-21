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

    Enemy(this.x, int this.y,int this.height,String imageLocation,  int this.speed,double this.direction,PhysicalLocation this.location) {
        image = new ImageElement(src: imageLocation);
        image.classes.add('enemy');
        image.style.zIndex = "${ProceduralLayer.yToZIndex(y,height)}}"; //auto sorts things by speed

    }

    //sub classes override this to move a differnet way (such as at an angle
    void tick() {
        x += (speed*direction).ceil();
    }


    static Enemy spawnImps(PhysicalLocation parent, int seed) {
        int maxX = 800;
        int maxY = 290;
        int maxHeightModifier = 150;
        Random rand = new Random(seed);
        List<String> treeLocations = <String>["0.png","1.png","2.png","3.png","4.png","5.png"];
        int y = rand.nextInt(maxY);
        int height = rand.nextIntRange(10,maxHeightModifier)+y;
        y += 300-height;
        List<double> directions = <double>[-1.0, 1.0];
        return new Enemy(rand.nextInt(maxX), y,height, "images/BGs/Trees/${rand.pickFrom(treeLocations)}",13,rand.pickFrom(directions), parent);
    }



}