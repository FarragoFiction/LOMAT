import '../Wagon.dart';
import 'Layers/ParallaxLayers.dart';
import 'PhysicalLocation.dart';
import 'dart:async';
import 'dart:html';

//eventually subclasses will have events and shit hwatever, not doing now
class Trail extends PhysicalLocation {
    List<ParallaxLayer> paralaxLayers = new List<ParallaxLayer>();
    Wagon wagon;

  Trail(Element container) : super(container);

  @override
  void init() {
      //TODO make trees/wind procedural
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/SimpleLomatBackground.png", this, 1));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/bg1.png", this, 5));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist0.png", this, 8));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist1.png", this, 12));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/mist2.png", this, 16));
      wagon = new Wagon(this.container);

  }
}
