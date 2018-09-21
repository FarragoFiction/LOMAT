import '../Wagon.dart';
import 'Layers/ParallaxLayers.dart';
import 'Layers/ProceduralLayer.dart';
import 'Layers/ProceduralLayerParallax.dart';
import 'PhysicalLocation.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';

//eventually subclasses will have events and shit hwatever, not doing now
class Trail extends PhysicalLocation {
    List<ParallaxLayer> paralaxLayers = new List<ParallaxLayer>();
    Wagon wagon;
    int numTrees = 8;
    Colour groundColor = new Colour.fromStyleString("#6aa7de");

  Trail(Element container) : super(container);

  @override
  void init() {
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/SimpleLomatBackground.png", this, 1,1));
      DivElement ground = new DivElement()..style.backgroundColor = groundColor.toStyleString();
      container.append(ground);
      //StaticLayer.styleLikeStaticLayer(ground,5,800,300,0,300);
      Random rand = new Random();
      //TODO eventually how wooded an area will be will be determined by location
      numTrees = rand.nextIntRange(1,13);
      ground.classes.add("ground");
      for(int i = 0; i<numTrees; i++) {
          ProceduralLayerParallax.spawnTree(this,rand.nextInt());
      }

      //TODO figure out the right speed for things its being weird
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist1.png", this, 5,5));

      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist0.png", this, 33,10));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist2.png", this, 1000,13));
      wagon = new Wagon(this.container);

  }
}
