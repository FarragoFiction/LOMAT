import 'Tombstone.dart';
import 'dart:html';
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

    //if the parent is null i'm the top level
    Element makeBuilder(Tombstone tombstone, TombstoneFridgeMagnet parent) {
        //initial state is just a box with your display text in it
        //its only if you get clicked that things change
        print("making a builder for $displayText");
        DivElement me = new DivElement()..classes.add("tombstoneMagnet");

        if(content.isNotEmpty) {
            me.text = ">$displayText";
        }else {
            me.text = displayText;
        }
        DivElement myContentDiv = new DivElement();
        me.append(myContentDiv);
        bool expanded = false;
        //TODO when you click one of these it should add all its children to itself?
        //and also call draw on the tombstone???
        me.onClick.listen((Event e) {
            if(parent != null) {
                parent.selection = this;
            }
            tombstone.redraw();
            if(!expanded) {
                show(myContentDiv,tombstone);
                expanded = true;
            } else {
                //TODO when i click on a child technically i'm clicking on me too and i vanish
                expanded =false;
               hide(myContentDiv);
                e.stopPropagation();
            }
        });

        return me;
    }

    void show(Element div, Tombstone tombstone) {
        print("trying to show ${div.children.length} children");
        if(div.children.isEmpty) {
            content.forEach((TombstoneFridgeMagnet magnet) {
                div.append(magnet.makeBuilder(tombstone, this));
            });
        }
        div.style.display = "block";
    }

    void hide(Element div) {
        div.style.display = "none";
    }

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
        return new TombstoneFridgeMagnet("word", <TombstoneFridgeMagnet>[nouns, verbs, conjunctions, punctuation, phrases, suffix,bullshit]);

    }

    //todo sub this out into categories
    static TombstoneFridgeMagnet get nouns {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("it", []));
        content.add(animate_nouns);
        content.add(travel_nouns);
        return new TombstoneFridgeMagnet("noun", content);
    }

    static TombstoneFridgeMagnet get travel_nouns {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("boat", []));
        content.add(new TombstoneFridgeMagnet("wagon", []));
        content.add(new TombstoneFridgeMagnet("ice", []));
        content.add(new TombstoneFridgeMagnet("snow", []));
        content.add(new TombstoneFridgeMagnet("wheel", []));
        content.add(new TombstoneFridgeMagnet("trail", []));
        content.add(new TombstoneFridgeMagnet("mist", []));
        content.add(new TombstoneFridgeMagnet("land", []));
        content.add(new TombstoneFridgeMagnet("town", []));

        return new TombstoneFridgeMagnet("travel", content);
    }

    static TombstoneFridgeMagnet get animate_nouns {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("troll", []));
        content.add(new TombstoneFridgeMagnet("snake", []));
        content.add(new TombstoneFridgeMagnet("bird", []));
        content.add(new TombstoneFridgeMagnet("ghost", []));
        content.add(new TombstoneFridgeMagnet("it", []));
        content.add(new TombstoneFridgeMagnet("human", []));
        content.add(new TombstoneFridgeMagnet("wolf", []));
        content.add(new TombstoneFridgeMagnet("gull", []));
        content.add(new TombstoneFridgeMagnet("butterfly", []));
        content.add(new TombstoneFridgeMagnet("caterpillar", []));
        content.add(new TombstoneFridgeMagnet("bug", []));
        content.add(new TombstoneFridgeMagnet("bear", []));
        content.add(new TombstoneFridgeMagnet("duck", []));
        content.add(new TombstoneFridgeMagnet("ant", []));
        return new TombstoneFridgeMagnet("animate", content);
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

    static TombstoneFridgeMagnet get gigglesnort {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("ghosts", []));
        content.add(new TombstoneFridgeMagnet("bones", []));
        content.add(new TombstoneFridgeMagnet("birds", []));
        content.add(new TombstoneFridgeMagnet("fenrir", []));
        content.add(new TombstoneFridgeMagnet("void", []));
        content.add(new TombstoneFridgeMagnet("cipher", []));
        content.add(new TombstoneFridgeMagnet("loss", []));
        content.add(new TombstoneFridgeMagnet("null", []));
        content.add(new TombstoneFridgeMagnet("psychopomp", []));
        content.add(new TombstoneFridgeMagnet("yggdrasil", []));
        //can't say tree/ wood etc
        content.add(new TombstoneFridgeMagnet("hard brown plant material", []));
        return new TombstoneFridgeMagnet("?????", content);
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

    static TombstoneFridgeMagnet get bullshit {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("lemme smash", []));
        content.add(new TombstoneFridgeMagnet("pepperony and chease", []));
        content.add(new TombstoneFridgeMagnet("is this a", []));
        return new TombstoneFridgeMagnet("bullshit", content);
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

