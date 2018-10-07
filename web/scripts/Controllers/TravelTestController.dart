import '../Locations/Trail.dart';
import 'dart:html';

Trail trail;
DivElement div = querySelector('#output');
void main() {
    trail = new Trail(div);
}
