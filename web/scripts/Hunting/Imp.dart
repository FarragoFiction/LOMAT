import '../Locations/PhysicalLocation.dart';
import 'Enemy.dart';

class Imp extends Enemy {

    static List<String> enemyLocations = <String>["0.png"];
    @override
    int speed = 13;
    @override
    int gristDropped = 13;

  Imp(int x, int y, int height, String imageLocation,double direction, PhysicalLocation location) : super(x, y, height, imageLocation, direction, location);

}