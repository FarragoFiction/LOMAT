import '../../Road.dart';

abstract class Effect {
    String name = "abstractEffect";
    int amount;
    String get flavorText =>  "Nothing happens, but $amount big anyways.";
    //your road will handle this
    void apply(Road road);
}