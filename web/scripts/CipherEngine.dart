//if you give me a text element i will hide a cipher in it some way or how
//through a variety of stupid shit
//maybe using a baconian cipher on the text in it
//maybe using hidden divs
//maybe making it so if you mouse over it the text changes
//maybe just flat out cesaring it

import 'dart:html';

import 'package:CommonLib/Logging.dart';
import 'package:CommonLib/NavBar.dart';
import 'package:CommonLib/Random.dart';
import 'package:CommonLib/src/collection/weighted_lists.dart';
import 'package:CommonLib/src/utility/predicates.dart';
//if puzzles get too hard have text and podcast yn try to figure them out
abstract class CipherEngine {
    static List<String> letters = <String>["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
    Random rand = new Random();
    //don't hide these behind too hard a cipher
    List<String> possibleEasySecrets = <String>["seerOfVoid=true is what true travelers of the Void use","Nothing here matters, and thats okay. Relax. Let it all wash over you.","Everything here is a secret that leads nowhere.","When the time comes, the Guide of Void will lead us out of this pit of irrelevance.","The Guide of Void is not here.","Only a few things will remain if you leave.","Has Nidhogg been purified, I wonder?","Bones all along.","Bury us.","Fenrir waits.","Eat at Joe's.","You are not who you seem.","Void is the theme of irrelevance.","Nothing here matters","This is merely a precursor to a conclusion.","Is this an intermission?","You are now SS. I mean. BB."];
    static WeightedList<CipherEngine> actions;
    static List<CesarCipher> cesarCiphers = new List<CesarCipher>();

    void apply(Element target);
    //some ciphers need specific length targets
    bool canApply(Element target);

    String pickSecret() {
        return rand.pickFrom(possibleEasySecrets);
    }

    static void applyRandom(Element target, bool allowHam) {
        if(actions == null) {
            actions = new WeightedList<CipherEngine>();
            actions.add(new HiddenDivCipher(), 1.0);
            actions.add(new MouseOverCipher(), 0.1);
            //if the target has a target word in it, nearly always you should do this one
            actions.add(new MouseOverSpecificWordCipher(), 8500000.0);

            cesarCiphers.add(new CesarCipher(85));
            cesarCiphers.add(new CesarCipher(13));
            cesarCiphers.add(new CesarCipher(1));
            cesarCiphers.add(new CesarCipher(3));
            cesarCiphers.add(new CesarCipher(8));
            cesarCiphers.add(new CesarCipher(5));

            //TODO write a baconian cipher (which does bold to make binary)
        }
        if(allowHam && !actions.contains(cesarCiphers.first)) {
            cesarCiphers.forEach((CesarCipher c) => actions.add(c));
        }
        List<CipherEngine> copyActions = new WeightedList.from(actions);
        copyActions.removeWhere((CipherEngine item) => item.canApply(target) == false);
        Random rand = new Random();
        rand.pickFrom(copyActions).apply(target);
    }

    static void voidPrint(String text, [int size = 18]) {
        String color = "#ffffff";
        if(getParameterByName("seerOfVoid",null)!= null) {
            color = "#020d1c";
        }
        String consortCss = "font-family: 'Nunito', Courier, monospace;color:${color};font-size: ${size}px;font-weight: bold;";
        fancyPrint("???: $text",consortCss);
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

class ConsoleCipher extends CipherEngine {

    @override
    void apply(Element target) {
        CipherEngine.voidPrint(pickSecret());
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

class CesarCipher extends CipherEngine {
    int key;
    CesarCipher(int this.key);

  @override
  void apply(Element target) {
    String text = target.text;
    String replaced = "";
    for(int i = 0; i<text.length; i++) {
        String char = text[i];
        int index = CipherEngine.letters.indexOf(char.toLowerCase());
        if(index != null && index >= 0) {
            int new_index = (index + key) % 26; //don't go over 26 plz
            replaced = "$replaced${CipherEngine.letters[new_index]}";
        }else {
            replaced = "$replaced$char"; //no change
        }
    }
    target.text = replaced;
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

