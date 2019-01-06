import '../SoundControl.dart';
import '../Wagon.dart';
import 'HuntingGrounds.dart';
import 'Layers/ParallaxLayers.dart';
import 'Layers/ProceduralLayer.dart';
import 'Layers/ProceduralLayerParallax.dart';
import 'MenuItems/MenuHolder.dart';
import 'PhysicalLocation.dart';
import 'Road.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';

//eventually subclasses will have events and shit hwatever, not doing now
class Trail extends PhysicalLocation {
    List<ParallaxLayer> paralaxLayers = new List<ParallaxLayer>();
    List<ProceduralLayerParallax> treeLayers = new List<ProceduralLayerParallax>();
    Wagon wagon;
    Element labelElement;
    int numTrees = 8;
    Colour groundColor = new Colour.fromStyleString("#6aa7de");
    //lets you know where you are going and how long it will take to get there and what events will be there.
    //JR NOTE: Its only 12/22/18 and i already don't remember why i decided a trail HAD a road instead of just
    //rolling road functionality into a trail. smdh.
    Road road;

  Trail(Road this.road,PhysicalLocation prev) : super(prev);



  @override
  void init() {
      //this is hte old way to do it before time remaining could be modified.
      //new Timer(new Duration(milliseconds: road.travelTimeInMS), () => arrive());
      paralaxLayers.add(new ParallaxLayerLooping(road.bg, this, 1,1));
      DivElement ground = new DivElement()..style.backgroundColor = groundColor.toStyleString();
      container.append(ground);
      //StaticLayer.styleLikeStaticLayer(ground,5,800,300,0,300);
      Random rand = new Random();
      //TODO eventually how wooded an area will be will be determined by location
      numTrees = rand.nextIntRange(1,13);
      ground.classes.add("ground");
      for(int i = 0; i<numTrees; i++) {
          treeLayers.add(ProceduralLayerParallax.spawnTree(this,rand.nextInt()));
      }

      //TODO figure out the right speed for things its being weird
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist1.png", this, 5,5));

      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist0.png", this, 33,10));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist2.png", this, 1000,13));
      wagon = new Wagon(this.container);

      menu = new MenuHolder(parent,this);
      createMenuItems();
      road.startLoops(this);

      labelElement = new DivElement()..text = "${road.label}}"..classes.add("townLable");
      container.append(labelElement);

  }

  void updateLabel() {
      labelElement.text = "${road.label}}";
  }


  void arrive() {
      SoundControl.instance.playSoundEffect("Dead_Jingle_light");
      paralaxLayers.forEach((ParallaxLayer layer) {
          layer.removeMePlease = true;
      });

      treeLayers.forEach((ProceduralLayerParallax layer) {
          layer.removeMePlease = true;
      });
      teardown();
      road.destinationTown.prevLocation = this;
      road.destinationTown.displayOnScreen(parent);

  }

  @override
  void teardown() {
      super.teardown();
      road.tearDown();
  }
    void doHunt() {
        teardown();
        //new screen
        //TODO save how much travel progress we've made
        //Or....don't? void is weird man.
        new HuntingGrounds(this)..displayOnScreen(parent);


    }


    void createMenuItems() {
        if(prevLocation != null) {
            menu.addHunt();
        }
    }
  @override
  String get bg => road.bg;
}
