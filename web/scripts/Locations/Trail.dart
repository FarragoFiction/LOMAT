import 'ParallaxLayers.dart';
import 'PhysicalLocation.dart';
import 'dart:async';
import 'dart:html';

//eventually subclasses will have events and shit hwatever, not doing now
class Trail extends PhysicalLocation {
    List<ParallaxLayer> paralaxLayers = new List<ParallaxLayer>();

  Trail(Element container) : super(container);

  @override
  void init() {
      //TODO make trees/wind procedural
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/bg0.png", this, 1));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/bg1.png", this, 5));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/bg2.png", this, 8));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/bg3.png", this, 12));
      paralaxLayers.add(new ParallaxLayerLooping("images/BGs/bg4.png", this, 16));

  }
}
