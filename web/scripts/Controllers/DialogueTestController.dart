import '../Locations/HuntingGrounds.dart';
import '../Screens/DialogueScreen.dart';
import 'dart:html';

DialogueScreen grounds;
DivElement div = querySelector('#output');
void main() {
    grounds = new DialogueScreen(div);
}