import 'dart:html';
import 'scripts/Locations/Trail.dart';

Trail trail;
DivElement div = querySelector('#output');
void main() {
  trail = new Trail(div);
}
