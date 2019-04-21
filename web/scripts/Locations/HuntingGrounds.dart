import '../Game.dart';
import '../Hunting/Bullet.dart';
import '../Hunting/Enemy.dart';
import '../SoundControl.dart';
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
        layers.add(new StaticLayer(prevLocation.bg, this, 1));
        SoundControl.instance.playMusic("Shooting_Gallery");
        container.onClick.listen((MouseEvent event){
           // window.alert("clicked");
            if(Game.instance.funds >= Bullet.gristCost) {
                Game.instance.removeFunds(Bullet.gristCost);
                Bullet bullet = new Bullet("images/Bullets/bullet.png",this, event.page.x-container.offset.left, event.page.y-container.offset.top);
                bullets.add(bullet);
            }else {
                SoundControl.instance.playSoundEffect("254286__jagadamba__mechanical-switch");
            }

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
        butterflyLoop();
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

    //fairly rare
    Future<Null> butterflyLoop() async{
        enemies.add(Enemy.spawnButterflies(this, rand.nextInt()));
        await window.animationFrame;
        int duartion = new Random().nextIntRange(1000,6000);
        new Timer(new Duration(milliseconds: duartion), () => butterflyLoop());
    }

    Future<Null> ogreLoop() async{
        enemies.add(Enemy.spawnOgres(this, rand.nextInt()));
        await window.animationFrame;
        int duartion = new Random().nextIntRange(3000,10000);
        new Timer(new Duration(milliseconds: duartion), () => ogreLoop());
    }
  // TODO: implement bg
  @override
  String get bg => layers.first.imageLocation;
}


class EchidnaHuntingGrounds extends HuntingGrounds {
  EchidnaHuntingGrounds(PhysicalLocation prev) : super(prev);

  @override
  void init() {
      //TODO make trees/wind procedural
      //TODO eventually which 0 bg is used is based on nearest location

      container.onClick.listen((MouseEvent event){
          if(!SoundControl.instance.musicPlaying) {
              SoundControl.instance.playMusic("Im_sorry_Hunters_mix");
          }
          // window.alert("clicked");
          Bullet bullet = new Bullet("images/Bullets/85.png",this, event.page.x-container.offset.left, event.page.y-container.offset.top);
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

      echidnaLoop();
      menu = new MenuHolder(parent,this);
      createMenuItems();

  }

  Future<Null> echidnaLoop() async{
      enemies.add(Enemy.spawnEchidnas(this, rand.nextInt()));
      await window.animationFrame;
      int duartion = new Random().nextIntRange(500,1000);
      new Timer(new Duration(milliseconds: duartion), () => echidnaLoop());
  }
}