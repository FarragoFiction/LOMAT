import '../Locations/PhysicalLocation.dart';
import 'dart:html';

class Bullet {
    ImageElement image;
    int x = 400;
    int y = 510;
    int speed = 13;
    PhysicalLocation location;
    int goalX = 0;
    int goalY = 0;

    Bullet(String imageLocation, PhysicalLocation this.location, int this.goalX, int this.goalY) {
        image = new ImageElement(src: imageLocation);
        image.classes.add('bullet');
        image.style.zIndex = "4037"; //auto sorts things by speed
        location.container.append(image);
        image.classes.add("parallaxLayer");
        //TODO animate traveling to goal location

    }
}