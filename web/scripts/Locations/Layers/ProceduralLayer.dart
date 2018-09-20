import '../PhysicalLocation.dart';
import 'StaticLayer.dart';
//doesn't move but also isn't forced to be at 0,0
class ProceduralLayer extends StaticLayer {
  ProceduralLayer(String imageLocation, PhysicalLocation parent, int zIndexOrSpeed) : super(imageLocation, parent, zIndexOrSpeed);

}