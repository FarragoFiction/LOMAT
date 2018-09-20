import 'ParallaxLayers.dart';
import 'PhysicalLocation.dart';
import 'StaticLayer.dart';
import 'dart:async';
import 'dart:html';

//eventually subclasses will have events and shit hwatever, not doing now
class HuntingGrounds extends PhysicalLocation {
    List<StaticLayer> layers = new List<StaticLayer>();

    HuntingGrounds(Element container) : super(container);

    @override
    void init() {
        //TODO make trees/wind procedural
        //TODO eventually which 0 bg is used is based on nearest location
        layers.add(new StaticLayer("images/BGs/bg0.png", this, 1));
        layers.add(new StaticLayer("images/BGs/bg1.png", this, 5));
        layers.add(new ParallaxLayer("images/BGs/bg2.png", this, 8));
        layers.add(new ParallaxLayer("images/BGs/bg3.png", this, 12));
        layers.add(new ParallaxLayer("images/BGs/bg4.png", this, 16));

    }
}
