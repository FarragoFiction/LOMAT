import '../Locations/PhysicalLocation.dart';
import 'Enemy.dart';

class Imp extends Enemy {

    static List<String> enemyLocations = <String>["unprototyped_ant.gif","bearant.gif","duckant.gif"];
    @override
    int speed = 13;
    @override
    int gristDropped = 2;

  Imp(int x, int y, int height, String imageLocation,double direction, PhysicalLocation location) : super(x, y, height, imageLocation, direction, location);

}