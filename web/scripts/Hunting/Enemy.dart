import '../Locations/Layers/ProceduralLayer.dart';
import '../Locations/PhysicalLocation.dart';
import 'Imp.dart';
import 'Ogre.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';

/*
    enemies have an image and have an ai
 */
abstract class Enemy {
    ImageElement image;
    int x = 0;
    int y = 0;
    int speed = 5;
    int gristDropped = 13;
    PhysicalLocation location;
    double direction = 0.0; //mostly they'll just go forwards and backwards but whatever, could need diff directions in a sub class
    int height;
    bool removeMePlease = false;
    int frameRate = (1000/30).round();


    Enemy(this.x, int this.y,int this.height,String imageLocation,  int this.speed,double this.direction,PhysicalLocation this.location) {
        image = new ImageElement(src: imageLocation);
        image.classes.add('enemy');
        int z = ProceduralLayer.yToZIndex(y,height);
        image.id = "zShouldBe$z";
        image.style.zIndex = "$z"; //auto sorts things by speed
        location.container.append(image);
        image.classes.add("parallaxLayer");
        image.height = height;
        if(direction >0)           image.style.transform = "scaleX(-1)";

        syncLocation();
        tick();
    }

    void syncLocation() {
        image.style.left = "${x}px";
        image.style.top = "${y}px";

    }

    //sub classes override this to move a differnet way (such as at an angle
    Future<Null> tick() async {
        print("ticking imp");
        if(removeMePlease) {
            return;
        }
        move();
        await window.animationFrame;
        new Timer(new Duration(milliseconds: frameRate), () => tick());

    }

    void move() {
        x += (speed*direction).ceil();
        if(x > location.width || x < height*-1) {
            vanish();
        }

        if(y > location.height || y < 0) {
            vanish();
        }
        syncLocation();
    }

    //TODO play sound effect, explode into/reward grist etc
    void die() {
        removeMePlease = true;
        image.remove();
    }

    void vanish() {
        removeMePlease = true;
        image.remove();
    }

    static SpawnData randomSpawnData(Random rand, int baseHeight) {
        print("doing imp)");
        int maxX = 800;
        int maxY = 290;
        int y = rand.nextInt(maxY);
        int height = (baseHeight*((y/maxY*2))).ceil()+30;
        y += 300-height;
        List<double> directions = <double>[-1.0, 1.0];

        double chosenDirection = rand.pickFrom(directions);
        int x = 0;
        if(chosenDirection < 0) x = maxX;
        return new SpawnData(x,y,height, chosenDirection);
    }


    static Enemy spawnImps(PhysicalLocation parent, int seed) {
        Random rand = new Random(seed);
        SpawnData spawn = randomSpawnData(rand,60);
        return new Imp(spawn.x, spawn.y,spawn.height, "images/Enemies/${rand.pickFrom(Imp.enemyLocations)}",13,spawn.chosenDirection, parent);
    }

    static Enemy spawnOgres(PhysicalLocation parent, int seed) {
        Random rand = new Random(seed);
        SpawnData spawn = randomSpawnData(rand,100);
        return new Ogre(spawn.x, spawn.y,spawn.height, "images/Enemies/${rand.pickFrom(Imp.enemyLocations)}",13,spawn.chosenDirection, parent);
    }



}

class SpawnData
{
    int x;
    int y;
    int height;
    double chosenDirection;
    SpawnData(int this.x, int this.y, int this.height, double this.chosenDirection);
}