import 'Layers/ParallaxLayers.dart';
import 'PhysicalLocation.dart';
import 'Layers/StaticLayer.dart';
import 'dart:async';
import 'dart:html';
import "package:CommonLib/Colours.dart";
//eventually subclasses will have events and shit hwatever, not doing now
class HuntingGrounds extends PhysicalLocation {
    Colour groundColor = new Colour.fromStyleString("#6aa7de");
    List<StaticLayer> layers = new List<StaticLayer>();

    HuntingGrounds(Element container) : super(container);

    @override
    void init() {
        //TODO make trees/wind procedural
        //TODO eventually which 0 bg is used is based on nearest location
        layers.add(new StaticLayer("images/BGs/bg0.png", this, 1));
        //layers.add(new StaticLayer("images/BGs/bg1.png", this, 5));
        DivElement ground = new DivElement()..style.backgroundColor = groundColor.toStyleString();
        container.append(ground);
        //StaticLayer.styleLikeStaticLayer(ground,5,800,300,0,300);
        ground.classes.add("ground");
        //layers.add(new ParallaxLayerLooping("images/BGs/bg2.png", this, 8));
        //layers.add(new ParallaxLayerLooping("images/BGs/bg3.png", this, 12));
        //layers.add(new ParallaxLayerLooping("images/BGs/bg4.png", this, 16));

    }
}
