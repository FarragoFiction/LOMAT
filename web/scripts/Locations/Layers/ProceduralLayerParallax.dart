import '../PhysicalLocation.dart';
import 'ProceduralLayer.dart';
import 'package:CommonLib/Random.dart';

class ProceduralLayerParallax extends ProceduralLayer {
  ProceduralLayerParallax(int x, int y, int height, bool turnways, String imageLocation, PhysicalLocation parent) : super(x, y, height, turnways, imageLocation, parent);


  static ProceduralLayerParallax spawnTree(PhysicalLocation parent, int seed) {
      int maxX = 800;
      int maxY = 290;
      int maxHeightModifier = 150;
      Random rand = new Random(seed);
      List<String> treeLocations = <String>["0.png","1.png","2.png","3.png","4.png","5.png"];
      int y = rand.nextInt(maxY);
      int height = rand.nextIntRange(10,maxHeightModifier)+y;
      y += 300-height;
      return new ProceduralLayerParallax(maxX*rand.nextInt(maxX), y,height,rand.nextBool(), "images/BGs/Trees/${rand.pickFrom(treeLocations)}", parent);
  }
}