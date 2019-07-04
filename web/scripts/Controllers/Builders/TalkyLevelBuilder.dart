
import 'dart:convert';
import 'dart:html';

import 'package:CommonLib/Utility.dart';

import '../../NPCs/TalkyItem.dart';
import '../../NPCs/TalkyLevel.dart';
import 'GenericBuilder.dart';

class TalkyLevelBuilder extends GenericBuilder {
  TalkyLevel level;
  Element itemContainer = new DivElement();

  @override
  void init() {
      container.text = "TODO: tALKY QUESTIONS";
      initDataElement();
      container.append(itemContainer);
      spawnItem(null);
  }

  void spawnItem(TalkyItem item) {
      DivElement div = new DivElement()..classes.add("formSection");
      TextAreaElement inputElement = new TextAreaElement()..cols = 100;
      LabelElement dataLabel = new LabelElement()..text = "Talky Item JSON:";
      div.append(dataLabel);
      div.append(inputElement);
      inputElement.onInput.listen((Event e){
         if(inputElement.value.isEmpty && item != null) {
             //remove existing (and self)
             level.talkyItems.remove(item);
             inputElement.remove();
         }else if(inputElement.value.isNotEmpty && item != null) {
             //overwrite my value to new value

         }else if(inputElement.value.isNotEmpty && item == null) {
             //spawn a new talky item and add it to the level and make sure you set it here so i can get it next time
         }


      });

      itemContainer.append(div);
  }


  @override
  void syncFormToLevel(){
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