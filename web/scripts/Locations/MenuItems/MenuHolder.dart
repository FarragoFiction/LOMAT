import '../PhysicalLocation.dart';
import 'Back.dart';
import 'CreditsButton.dart';
import 'Hunt.dart';
import 'MenuItem.dart';
import 'Talk.dart';
import 'Trade.dart';
import 'Travel.dart';
import 'GuideBotButton.dart';
import 'dart:html';

import 'Void.dart';

class MenuHolder {
    List<MenuItem> _items = new List<MenuItem>();
    Element container;
    PhysicalLocation location;

    MenuHolder(Element parent, PhysicalLocation this.location) {
        container = new DivElement();
        parent.append(container);
        container.classes.add("menuHolder");
    }

    void teardown() {
        container.remove();
    }

    void addTalk() {
        _items.add(new Talk(this));
    }

    void addTrade() {
        _items.add(new Trade(this));
    }

    void addBotButton() {
        _items.add(new GuideBotButton(this));
    }

    void addCreditsButton() {
        _items.add(new CreditsButton(this));
    }

    void addTravel() {
        _items.add(new Travel(this));
    }

    void addHunt() {
        _items.add(new Hunt(this));
    }

    void addVoidTravel() {
        _items.add(new VoidTravel(this));
    }

    void addBack() {
        _items.add(new Back(this));
    }



}