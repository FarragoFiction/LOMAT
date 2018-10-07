import '../Hunting/Bullet.dart';
import '../Hunting/Enemy.dart';
import 'dart:html';
//a physical location, what happens there is different for different locations
abstract class PhysicalLocation {

    Element parent;
    Element container;
    List<Bullet> bullets = new List<Bullet>();
    List<Enemy> enemies = new List<Enemy>();
    //TODO list secrets to shoot too
    int width = 800;
    int height = 600;
    PhysicalLocation(Element this.parent) {
        container = new DivElement();
        container.classes.add("parallaxParent");
        print("class added, width is ${container.style.width}");
        parent.append(container);
        init();
    }
    void init();

    void doTalky() {
        window.alert("ERROR: This Screen Does Not Support Talk");
    }
}