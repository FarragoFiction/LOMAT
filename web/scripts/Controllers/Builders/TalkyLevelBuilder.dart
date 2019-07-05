
import 'dart:convert';
import 'dart:html';

import 'package:CommonLib/Utility.dart';

import '../../NPCs/TalkyItem.dart';
import '../../NPCs/TalkyLevel.dart';
import 'GenericBuilder.dart';

class TalkyLevelBuilder extends GenericBuilder {
  TalkyLevel level;
  Element itemContainer = new DivElement();

  TalkyLevelBuilder() {
      level = new TalkyLevel(<TalkyItem>[],null);
      init();
  }

  @override
  void init() {
      container.setInnerHtml("<h1>Talky Level Builder</h1>");
      initDataElement();
      container.append(itemContainer);
      spawnItem(null);
      syncFormToLevel();
  }

  void spawnItem(TalkyItem item) {
      DivElement div = new DivElement()..classes.add("formSection");
      TextAreaElement inputElement = new TextAreaElement()..cols = 100;
      if(item != null) inputElement.value = jsonEncode(item.toJSON());
      LabelElement dataLabel = new LabelElement()..text = "Talky Item JSON:";
      div.append(dataLabel);
      div.append(inputElement);
      inputElement.onInput.listen((Event e){
          print("noticed input");
         if(inputElement.value.isEmpty && item != null) {
             print("removed item");
             //remove existing (and self)
             level.talkyItems.remove(item);
             inputElement.remove();
             syncFormToLevel();
         }else if(inputElement.value.isNotEmpty && item != null) {
             //overwrite my value to new value
             print("changing item");
             syncFormToLevel();

         }else if(inputElement.value.isNotEmpty && item == null) {
             print("added item");
             //spawn a new talky item and add it to the level and make sure you set it here so i can get it next time
             item = TalkyItem.loadFromJSON(null, new JsonHandler(jsonDecode(inputElement.value)), null);
             level.talkyItems.add(item);
             syncFormToLevel();
         }


      });

      itemContainer.append(div);
  }


  @override
  void syncFormToLevel(){
      dataStringElement.value = jsonEncode(level.toJSON());
      for(Element child in itemContainer.children) {
          child.remove();
      }
      for(TalkyItem ti in level.talkyItems) {
        spawnItem(ti);
      }
      spawnItem(null); //for next item
  }


  void load() {
      //here's hoping a null gull is fine
      level  = TalkyLevel.loadFromJSON(null,new JsonHandler(jsonDecode(dataStringElement.value)));
      print("loaded ${level.toJSON()}");

      for(Element child in itemContainer.children) {
          child.remove();
      }
      syncFormToLevel();
  }

}