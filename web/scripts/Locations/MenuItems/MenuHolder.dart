import '../PhysicalLocation.dart';
import 'Hunt.dart';
import 'MenuItem.dart';
import 'Talk.dart';
import 'Trade.dart';
import 'Travel.dart';
import 'dart:html';

class MenuHolder {
    List<MenuItem> _items = new List<MenuItem>();
    Element container;
    PhysicalLocation location;

    MenuHolder(Element parent, PhysicalLocation this.location) {
        container = new DivElement();
        parent.append(container);
        container.classes.add("menuHolder");
    }

    void addTalk() {
        _items.add(new Talk(this));
    }

    void addTrade() {
        _items.add(new Trade(this));
    }

    void addTravel() {
        _items.add(new Travel(this));
    }

    void addHunt() {
        _items.add(new Hunt(this));
    }



}