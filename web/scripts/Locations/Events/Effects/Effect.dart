import '../../../NPCs/LOMATNPC.dart';
import '../../Road.dart';
import 'dart:html';

abstract class Effect {
    String name = "abstractEffect";
    int amount;
    //means only one event on screen at a time
    ImageElement image = new ImageElement(src: "images/EventIcons/raidho.png");
    LOMATNPC target;
    String get flavorText =>  "Nothing happens, but $amount big anyways.";
    //your road will handle this
    Future<Null> apply(Road road);
    String targetName;
    //override this if there are some situations it doens't make sense for you to happen
    //such as it not making sense to target a party member if you don't HAVE a party
    bool isValid(Road road) {
        return true;
    }
}