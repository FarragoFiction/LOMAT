import '../PhysicalLocation.dart';
import 'StaticLayer.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';
import "dart:math" as Math;
//doesn't move but also isn't forced to be at 0,0


class ProceduralLayer extends StaticLayer {
    static int viewportHeight = 600;
    int x = 0;
    int y = 0;
    int width = 0;
    int height = 0;
    bool turnways = false;
    ProceduralLayer(int this.x, int this.y, int this.height,bool this.turnways, String imageLocation, PhysicalLocation parent) : super(imageLocation, parent, 5);
    ProceduralLayer.fromImage(int this.x, int this.y, int this.height,bool this.turnways, ImageElement image, PhysicalLocation parent) : super.fromImage(image, parent, 5);

  void init() {
      zIndex = yToZIndex(y,height);
      image = new ImageElement(src: imageLocation);
      image.style.height = "$height px";
      image.height = height;
      image.style.zIndex = "$zIndex"; //auto sorts things by speed
      image.style.left = "${x}px";
      //bottom gets ignored for dumb reasons
      image.style.top = "${y}px";
      if(turnways) {
          image.style.transform = "scaleX(-1)";
      }
      image.classes.add("parallaxLayer");
      parent.container.append(image);

  }

  //every so often it doesn't look quite right, especially for short trees, what should math be???
    //discord is down so i can't ramble my thoughts there.
  static int yToZIndex(int y, int height) {
      return ((y+height)/10).floor();
  }

  static ProceduralLayer spawnTree(PhysicalLocation parent, int seed) {
      int maxX = 800;
      int maxY = 290;
      int maxHeightModifier = 150;
      Random rand = new Random(seed);
      List<String> treeLocations = <String>["0.png","1.png","2.png","3.png","4.png","5.png"];
      int y = rand.nextInt(maxY);
      int height = rand.nextIntRange(10,maxHeightModifier)+y;
      y += maxY - 10 -height;
      return new ProceduralLayer(rand.nextInt(maxX), y,height,rand.nextBool(), "images/BGs/Trees/${rand.pickFrom(treeLocations)}", parent);
  }

}