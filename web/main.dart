import 'dart:html';
import 'scripts/Locations/Town.dart';
import 'scripts/Locations/Trail.dart';

Town town;
DivElement div = querySelector('#output');
void main() {
  town = new Town(div);
}
