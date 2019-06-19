//if you give me a text element i will hide a cipher in it some way or how
//through a variety of stupid shit
//maybe using a baconian cipher on the text in it
//maybe using hidden divs
//maybe making it so if you mouse over it the text changes
//maybe just flat out cesaring it

import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:CommonLib/src/collection/weighted_lists.dart';
import 'package:CommonLib/src/utility/predicates.dart';
//if puzzles get too hard have text and podcast yn try to figure them out
abstract class CipherEngine {
    Random rand = new Random();
    //don't hide these behind too hard a cipher
    List<String> possibleEasySecrets = <String>["Bones all along.","Bury us.","Fenrir waits.","Eat at Joe's."];
    static WeightedList<CipherEngine> actions;

    void apply(Element target);
    //some ciphers need specific length targets
    bool canApply(Element target);

    String pickSecret() {
        return rand.pickFrom(possibleEasySecrets);
    }

    static void applyRandom(Element target) {
        if(actions == null) {
            actions = new WeightedList<CipherEngine>();
            actions.add(new HiddenDivCipher(), 1.0);
            actions.add(new MouseOverCipher(), 0.1);
            //if the target has a target word in it, nearly always you should do this one
            actions.add(new MouseOverSpecificWordCipher(), 8500000.0);
            //TODO write a baconian cipher
        }
        List<CipherEngine> copyActions = new WeightedList.from(actions);
        copyActions.removeWhere((CipherEngine item) => item.canApply(target) == false);
        Random rand = new Random();
        rand.pickFrom(copyActions).apply(target);
    }

}

class HiddenDivCipher extends CipherEngine {

  @override
  void apply(Element target) {
    DivElement hidden = new DivElement()..text = pickSecret();
    hidden.style.display = "none";
    hidden.classes.add("OhGoshIHopeNoWasteFindsThis");
    target.append(hidden);
  }
  @override
  bool canApply(Element target) {
    return true;
  }
}

class MouseOverCipher extends CipherEngine {

  @override
  void apply(Element target) {
      print("applying mouse over");
    String originalText = target.text;
    String newText = pickSecret();
    target.onMouseEnter.listen((Event e)
    {
        target.text = newText;
    });

    target.onMouseLeave.listen((Event e)
    {
        target.text = originalText;
    });
  }

  @override
  bool canApply(Element target) {
    return true;
  }
}

//if the target has a specific word, that word is replaced with a span you can mouse over to get a secret
class MouseOverSpecificWordCipher extends CipherEngine {

    String chosenKey;
    //simple examples, all lower case okay?
    Map<String,String> maps = {"[redacted]":"tree","titan":"fenrir","reaper":"prince","soul":"bone", "The Kid":"Billy", "Halja":"Hel","Nut":"Ratatoskr","Ebony":"Ivory"};


    @override
    void apply(Element target) {
        String originalText = target.text;
        String newText = originalText.replaceAll(new RegExp("$chosenKey", caseSensitive: false),maps[chosenKey].toUpperCase());
        target.onMouseEnter.listen((Event e)
        {
            target.text = newText;
        });

        target.onMouseLeave.listen((Event e)
        {
            target.text = originalText;
        });
    }

    @override
    bool canApply(Element target) {
        String lowerTarget = target.text.toLowerCase();
        for(String key in maps.keys) {
            if(lowerTarget.contains(key)) {
                chosenKey = key;
                return true;
            }
        }
        return false;
    }
}

