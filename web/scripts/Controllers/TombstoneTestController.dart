import '../Locations/HuntingGrounds.dart';
import '../NPCs/Tombstone.dart';
import 'dart:html';

DivElement div = querySelector('#output');
void main() {
    Tombstone t = new Tombstone();
    t.drawSelf(div);
    ButtonElement button = new ButtonElement()..text = "Draw";
    button.onClick.listen((Event e) {
        t.drawSelf(div);
    });
    div.append(button);
}