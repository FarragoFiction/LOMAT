import 'package:CommonLib/Random.dart';


//builds an epilogue up like making fridge magnet poetry
//one of these is an entire builder, shows all categories and subcategories
//when a user makes a selection that words itself is put in the tombstone
//and if its actually a category header it will drill down into (but not select anything in) its category

class TombstoneFridgeMagnet {
    String displayText;
    //so i can have compound words like play-ed
    bool spaceBefore;
    TombstoneFridgeMagnet selection;
    List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();

    bool get isRoot => content.isEmpty;

    String get displayTextWithSpaces {
        print("getting display text for $displayText and before is $spaceBefore and after is");
        String ret = "$displayText";
        if(spaceBefore) {
            ret = " $ret";
        }
        print("returning ret of ~~~$ret~~~");
        return ret;
    }

    TombstoneFridgeMagnet(String this.displayText, List<TombstoneFridgeMagnet> this.content, {this.spaceBefore: true} );

    //chooses shit randomly till it hits an end
    //recursive
    void randomChoice() {
        Random rand = new Random();
        selection = rand.pickFrom(content);
        if(selection != null) {
            selection.randomChoice();
        }
    }

    //recursive
    String getChosenRoot() {
        if(isRoot || selection == null) {
            return displayTextWithSpaces;
        }else {
            return selection.getChosenRoot();
        }
    }
////////////////////////////////////////////////////////////////
    //NONE of these get loaded from file becaues this has to be hax proof

    static TombstoneFridgeMagnet get topLevelMenu {
        return new TombstoneFridgeMagnet("???", <TombstoneFridgeMagnet>[nouns, verbs, conjunctions, punctuation, phrases, suffix]);

    }

    //todo sub this out into categories
    static TombstoneFridgeMagnet get nouns {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("cheese", []));
        content.add(new TombstoneFridgeMagnet("boat", []));
        content.add(new TombstoneFridgeMagnet("troll", []));
        content.add(new TombstoneFridgeMagnet("snake", []));
        content.add(new TombstoneFridgeMagnet("ghost", []));
        content.add(new TombstoneFridgeMagnet("bird", []));
        content.add(new TombstoneFridgeMagnet("wagon", []));
        content.add(new TombstoneFridgeMagnet("ice", []));
        content.add(new TombstoneFridgeMagnet("it", []));
        return new TombstoneFridgeMagnet("noun", content);

    }

    //TODO sub this out into things like travel/fight
    static TombstoneFridgeMagnet get verbs {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("kick", []));
        content.add(new TombstoneFridgeMagnet("kill", []));
        content.add(new TombstoneFridgeMagnet("punch", []));
        content.add(new TombstoneFridgeMagnet("yeet", []));
        content.add(new TombstoneFridgeMagnet("travel", []));
        content.add(new TombstoneFridgeMagnet("starve", []));
        content.add(new TombstoneFridgeMagnet("die", []));
        content.add(new TombstoneFridgeMagnet("give", []));
        content.add(new TombstoneFridgeMagnet("talk", []));
        content.add(new TombstoneFridgeMagnet("dominance", []));
        return new TombstoneFridgeMagnet("verb", content);
    }

    static TombstoneFridgeMagnet get conjunctions {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("for", []));
        content.add(new TombstoneFridgeMagnet("and", []));
        content.add(new TombstoneFridgeMagnet("nor", []));
        content.add(new TombstoneFridgeMagnet("xor", []));
        content.add(new TombstoneFridgeMagnet("but", []));
        content.add(new TombstoneFridgeMagnet("or", []));
        content.add(new TombstoneFridgeMagnet("yet", []));
        content.add(new TombstoneFridgeMagnet("so", []));
        return new TombstoneFridgeMagnet("conjunction", content);

    }

    static TombstoneFridgeMagnet get suffix {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("ed", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("ing", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("er", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("s", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("d", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("es", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("est", [], spaceBefore: false));
        return new TombstoneFridgeMagnet("suffix", content);
    }

    static TombstoneFridgeMagnet get punctuation {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet(".", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet(",", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("!", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("?", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet(":", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet(";", [], spaceBefore: false));
        return new TombstoneFridgeMagnet("punctuation", content);

    }

    static TombstoneFridgeMagnet get phrases {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("is this a", []));
        content.add(new TombstoneFridgeMagnet("and thats why they're", []));
        content.add(new TombstoneFridgeMagnet("the other guy", []));
        content.add(new TombstoneFridgeMagnet("dear, sweet, precious", []));
        content.add(new TombstoneFridgeMagnet("flip the **** out", []));
        content.add(new TombstoneFridgeMagnet("fondly regard", []));
        content.add(new TombstoneFridgeMagnet("in the snout to establish", []));
        content.add(new TombstoneFridgeMagnet("this is incredibly", []));
        content.add(new TombstoneFridgeMagnet("has been slain", []));
        content.add(new TombstoneFridgeMagnet("like a mechanical bull", []));
        content.add(new TombstoneFridgeMagnet("hell of a mystery", []));
        content.add(new TombstoneFridgeMagnet("all of them", []));
        content.add(new TombstoneFridgeMagnet("addiction is a powerful thing", []));
        content.add(new TombstoneFridgeMagnet("boggle vacantly", []));
        return new TombstoneFridgeMagnet("phrase", content);
    }
}

