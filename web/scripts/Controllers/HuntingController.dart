import '../Game.dart';
import '../Locations/HuntingGrounds.dart';
import 'dart:html';

HuntingGrounds grounds;
DivElement div = querySelector('#output');
void main() {
    grounds = new EchidnaHuntingGrounds(null);
    Game game = Game.instance;
    game.currentLocation = grounds;
    game.display(div);
    print("hello world");
}