import '../Locations/PhysicalLocation.dart';
import 'Enemy.dart';
import 'package:CommonLib/Random.dart';

//TODO make them move around randomly and flutteringly but fast
class Butterfly extends Enemy {

    static List<String> enemyLocations = <String>["Bearterfly_fast.gif"];
    @override
    int speed = 13;
    @override
    int gristDropped = 130;

    int lifespan = 1000;
    int ticks = 0;

    Butterfly(int x, int y, int height, String imageLocation,double direction, PhysicalLocation location) : super(x, y, height, imageLocation, direction, location) {
        //they face opposite everyone else
        if(direction <0) image.style.transform = "scaleX(-1)";
    }

    @override
    void move() {
        ticks ++;
        Random rand = new Random();
        //WHIMSY
        if(rand.nextDouble() > 0.3){
            x += (speed*direction*rand.nextDouble()*2+0.5).ceil();
        }else {
            x += (speed*-1*direction*rand.nextDouble()*2+0.5).ceil();
        }

        if(rand.nextDouble() > 0.5){
            y += (speed*direction*rand.nextDouble()*1.5+0.5).ceil();
        }else {
            y += (speed*-1*direction*rand.nextDouble()*1.5+0.5).ceil();
        }
        //won't vanish if it goes off screen up or down because thats how tehy roll
        if(x > location.width || x < height*-1) {
            vanish();
        }

        if(y > location.height || y < 0) {
            vanish();
        }

        //don't let them stay 'on screen' (or worse, off it but up or down) forever
        if(ticks > lifespan) {
            vanish();
        }
        syncLocation();
    }

}