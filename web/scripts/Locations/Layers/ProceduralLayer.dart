import '../PhysicalLocation.dart';
import 'StaticLayer.dart';
import 'dart:html';
//doesn't move but also isn't forced to be at 0,0


class ProceduralLayer extends StaticLayer {
    int x = 0;
    int y = 0;
  ProceduralLayer(int this.x, int this.y, String imageLocation, PhysicalLocation parent, int zIndexOrSpeed) : super(imageLocation, parent, zIndexOrSpeed);

  void init() {
      image = new ImageElement(src: imageLocation);
      image.style.zIndex = "$zIndexOrSpeed"; //auto sorts things by speed
      image.style.left = "${x}px";
      image.style.top = "${y}px";
      image.classes.add("parallaxLayer");
      parent.container.append(image);
  }

}