import '../Game.dart';
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

//if this were magical girl sim it would just be like, a Screen. past jr was bad at desginign
    PhysicalLocation(PhysicalLocation this.prevLocation) {
    }

    String get bg;

    void shitGoBack() {
        if(prevLocation != null) {
            teardown();
            menu.teardown();
            prevLocation.displayOnScreen(null);
        }else {
            window.alert("ERROR there is no where to go back TO");
        }
    }

    //used both for setting up the first time, and for reiniting if any screen needs to come back here
    void displayOnScreen(Element div) {
        if(div != null) parent = div;
        if(Game.instance.currentLocation != null) {
            //it probably tore itself down already but if it DIDN'T...well, you gotta do something.
            Game.instance.currentLocation.teardown();
        }
        container = new DivElement();
        container.classes.add("parallaxParent");
        //sprint("class added, width is ${container.style.width}");
        parent.append(container);
        Game.instance.currentLocation = this;
        init();
    }

    void teardown() {
        if(container != null) {
            container.remove();
        }
        if(menu != null) {
            menu.teardown();
        }
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