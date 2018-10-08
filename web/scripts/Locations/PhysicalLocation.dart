import '../Hunting/Bullet.dart';
import '../Hunting/Enemy.dart';
import 'MenuItems/MenuHolder.dart';
import 'dart:html';
//a physical location, what happens there is different for different locations
abstract class PhysicalLocation {

    Element parent;
    Element container;
    List<Bullet> bullets = new List<Bullet>();
    List<Enemy> enemies = new List<Enemy>();
    PhysicalLocation prevLocation;
    //TODO list secrets to shoot too
    int width = 800;
    int height = 600;
    MenuHolder menu;

    PhysicalLocation(Element this.parent, PhysicalLocation this.prevLocation) {
        setup();

    }

    void shitGoBack() {
        if(prevLocation != null) {
            teardown();
            menu.teardown();
            prevLocation.setup();
        }else {
            window.alert("ERROR there is no where to go back TO");
        }
    }

    //used both for setting up the first time, and for reiniting if any screen needs to come back here
    void setup() {
        container = new DivElement();
        container.classes.add("parallaxParent");
        print("class added, width is ${container.style.width}");
        parent.append(container);
        init();
    }

    void teardown() {
        container.remove();
    }

    void init();

    void doTalky() {
        window.alert("ERROR: This Screen Does Not Support Talk");
    }

    void doHunt() {
        window.alert("ERROR: This Screen Does Not Support Hunt");
    }

    void doTravel() {
        window.alert("ERROR: This Screen Does Not Support Travel");
    }
}