import '../Locations/HuntingGrounds.dart';
import 'dart:html';

HuntingGrounds grounds;
DivElement div = querySelector('#output');
void main() {
    grounds = new HuntingGrounds(div);
}