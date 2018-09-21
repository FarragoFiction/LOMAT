import '../PhysicalLocation.dart';
import 'ProceduralLayer.dart';
import 'dart:async';
import 'dart:html';
import 'package:CommonLib/Random.dart';

class ProceduralLayerParallax extends ProceduralLayer {
    int frameRate = (1000/30).round();
    bool removeMePlease = false;

  ProceduralLayerParallax(int x, int y, int height, bool turnways, String imageLocation, PhysicalLocation parent) : super(x, y, height, turnways, imageLocation, parent) {
      animate();
  }

  Future<Null> animate() async{
      //todo when i go off screen spawn a new tree
      if(removeMePlease) return;
      move();
      await window.animationFrame;
      new Timer(new Duration(milliseconds: frameRate), () => animate());
  }


  void move() {
      print("moving");
      int x = int.parse(image.style.left.replaceAll("px", ""));
      //trees move WAY too fast
      x = x - ((zIndex/10).round());
      //if i am less than -0, no longer on screen, go away
      if(x<image.width*-1){
          image.remove();
          removeMePlease = true;
          spawnTreeOffScreen(parent, new Random().nextInt());
          return;
      }
      image.style.left = "${x}px";
  }

    static ProceduralLayerParallax spawnTreeOffScreen(PhysicalLocation parent, int seed) {
        int maxX = 800;
        int maxY = 290;
        int maxHeightModifier = 300;
        Random rand = new Random(seed);
        List<String> treeLocations = <String>["0.png","1.png","2.png","3.png","4.png","5.png"];
        int y = rand.nextInt(maxY);
        int height = rand.nextIntRange(10,maxHeightModifier)+y;
        y += 300-height;
        return new ProceduralLayerParallax(maxX +rand.nextInt(maxX), y,height,rand.nextBool(), "images/BGs/Trees/${rand.pickFrom(treeLocations)}", parent);
    }


  static ProceduralLayerParallax spawnTree(PhysicalLocation parent, int seed) {
      int maxX = 800;
      int maxY = 290;
      int maxHeightModifier = 200;
      Random rand = new Random(seed);
      List<String> treeLocations = <String>["0.png","1.png","2.png","3.png","4.png","5.png"];
      int y = rand.nextInt(maxY);
      int height = rand.nextIntRange(10,maxHeightModifier)+y;
      y += 300-height;
      return new ProceduralLayerParallax(rand.nextInt(maxX), y,height,rand.nextBool(), "images/BGs/Trees/${rand.pickFrom(treeLocations)}", parent);
  }
}