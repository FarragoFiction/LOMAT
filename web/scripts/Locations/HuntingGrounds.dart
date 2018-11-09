import '../Hunting/Bullet.dart';
import '../Hunting/Enemy.dart';
import 'Layers/ParallaxLayers.dart';
import 'Layers/ProceduralLayer.dart';
import 'MenuItems/MenuHolder.dart';
import 'PhysicalLocation.dart';
import 'Layers/StaticLayer.dart';
import 'dart:async';
import 'dart:html';
import "package:CommonLib/Colours.dart";
import 'package:CommonLib/Random.dart';
//eventually subclasses will have events and shit hwatever, not doing now
class HuntingGrounds extends PhysicalLocation {
    int numTrees = 8;
    Random rand = new Random();
    Colour groundColor = new Colour.fromStyleString("#6aa7de");
    List<StaticLayer> layers = new List<StaticLayer>();


    HuntingGrounds(PhysicalLocation prev) : super(prev);

    @override
    void init() {
        //TODO make trees/wind procedural
        //TODO eventually which 0 bg is used is based on nearest location
        layers.add(new StaticLayer("images/BGs/SimpleLomatBackground.png", this, 1));
        container.onClick.listen((MouseEvent event){
           // window.alert("clicked");
            Bullet bullet = new Bullet("images/Bullets/bullet.png",this, event.page.x-container.offset.left, event.page.y-container.offset.top);
            bullets.add(bullet);
        });
        //layers.add(new StaticLayer("images/BGs/bg1.png", this, 5));
        DivElement ground = new DivElement()..style.backgroundColor = groundColor.toStyleString();
        container.append(ground);
        //StaticLayer.styleLikeStaticLayer(ground,5,800,300,0,300);
        //TODO eventually how wooded an area will be will be determined by location
        numTrees = rand.nextIntRange(1,13);
        ground.classes.add("huntingGround");
        for(int i = 0; i<numTrees; i++) {
            ProceduralLayer.spawnTree(this,rand.nextInt());
        }

        impLoop();
        ogreLoop();
        menu = new MenuHolder(parent,this);
        createMenuItems();

    }

    void createMenuItems() {
        if(prevLocation != null) {
            menu.addBack();
        }
    }

    Future<Null> impLoop() async{
        enemies.add(Enemy.spawnImps(this, rand.nextInt()));
        await window.animationFrame;
        int duartion = new Random().nextIntRange(2000,4000);
        new Timer(new Duration(milliseconds: duartion), () => impLoop());
    }

    Future<Null> ogreLoop() async{
        enemies.add(Enemy.spawnOgres(this, rand.nextInt()));
        await window.animationFrame;
        int duartion = new Random().nextIntRange(3000,10000);
        new Timer(new Duration(milliseconds: duartion), () => ogreLoop());
    }
}
