import 'Town.dart';

class Road {
    Town town1;
    Town town2;
    //distance is voided at first
    int distance = 13;
    //TODO also has events

    Road(Town this.town1, Town this.town2, int this.distance);
}