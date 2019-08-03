import '../Locations/Trail.dart';
import 'dart:html';

TrailLocation trail;
DivElement div = querySelector('#output');
void main() {
    trail = new TrailLocation(null,null);
    trail.displayOnScreen(div);
}
