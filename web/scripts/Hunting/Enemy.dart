import '../Locations/Layers/ProceduralLayer.dart';
import '../Locations/PhysicalLocation.dart';
import '../SoundControl.dart';
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
    String deathSound = "85846__mwlandi__meat-slap-2";


    Enemy(this.x, int this.y,int this.height,String imageLocation, double this.direction,PhysicalLocation this.location) {
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
        if(removeMePlease) {
            location.enemies.remove(this);
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

    //TODO  explode into/reward grist etc
    //farther away they are, more grist they should be worth, this is a game, not oregon trail
    void die() {
        removeMePlease = true;
        image.remove();
    }

    void vanish() {
        removeMePlease = true;
        image.remove();
    }

    static SpawnData randomSpawnData(Random rand, int baseHeight) {
        int maxX = 800;
        int maxY = 290;
        int y = rand.nextInt(maxY);
        //what is this math again? obviously trying to scale it to be smaller if further away...
        int height = (baseHeight*((y/maxY))).ceil()+30;
        y += 300-height;
        List<double> directions = <double>[-1.0, 1.0];

        double chosenDirection = rand.pickFrom(directions);
        //if you spawn at zero you will pop in, the code that kills you when you're off screen checks for height
        int x = -1*height -1;
        if(chosenDirection < 0) x = maxX;
        return new SpawnData(x,y,height, chosenDirection);
    }

    String toString() {
        return("${runtimeType}: (x: $x, y: $y)");
    }


    static Enemy spawnImps(PhysicalLocation parent, int seed) {
        Random rand = new Random(seed);
        SpawnData spawn = randomSpawnData(rand,120);
        return new Imp(spawn.x, spawn.y,spawn.height, "images/Enemies/${rand.pickFrom(Imp.enemyLocations)}",spawn.chosenDirection, parent);
    }

    static Enemy spawnOgres(PhysicalLocation parent, int seed) {
        Random rand = new Random(seed);
        SpawnData spawn = randomSpawnData(rand,300);
        return new Ogre(spawn.x, spawn.y,spawn.height, "images/Enemies/${rand.pickFrom(Ogre.enemyLocations)}",spawn.chosenDirection, parent);
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