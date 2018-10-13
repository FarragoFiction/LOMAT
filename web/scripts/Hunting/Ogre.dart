import '../Locations/PhysicalLocation.dart';
import 'Enemy.dart';

class Ogre extends Enemy {

    static List<String> enemyLocations = <String>["30frames.gif","bugbear.gif"];
    @override
    int speed = 2;
    @override
    int gristDropped = 130;

    Ogre(int x, int y, int height, String imageLocation, double direction, PhysicalLocation location) : super(x, y, height, imageLocation, direction, location);

}