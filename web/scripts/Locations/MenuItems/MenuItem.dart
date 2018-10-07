import 'MenuHolder.dart';
import 'dart:html';

abstract class MenuItem {
    String name = "";
    Element container;
    MenuHolder holder;

    MenuItem(String this.name, MenuHolder this.holder) {
        init();
    }

    void init() {
        //print("init");
        container = new DivElement();
        holder.container.append(container);
        //print("I appended it to the menu holder with children ${holder.container.children.length}");
        container.classes.add("menuItem");
        container.text = name;
        container.onClick.listen((Event e) => onClick());
    }

    void onClick();
}