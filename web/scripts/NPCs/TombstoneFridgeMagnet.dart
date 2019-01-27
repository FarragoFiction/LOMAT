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
    Element me;
    TombstoneFridgeMagnet parent;
    List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();

    bool get isRoot => content.isEmpty;

    String get displayTextWithSpaces {
        //print("getting display text for $displayText and before is $spaceBefore and after is");
        String ret = "$displayText";
        if(spaceBefore) {
            ret = " $ret";
        }
        //print("returning ret of ~~~$ret~~~");
        return ret;
    }

    TombstoneFridgeMagnet(String this.displayText, List<TombstoneFridgeMagnet> this.content, {this.spaceBefore: true} );

    //if the parent is null i'm the top level
    Element makeBuilder(Tombstone tombstone, TombstoneFridgeMagnet parent) {
        //initial state is just a box with your display text in it
        //its only if you get clicked that things change
        this.parent =parent;
        //print("making a builder for $displayText");
        me = new DivElement()..classes.add("tombstoneMagnet");

        if(content.isNotEmpty) {
            me.text = ">$displayText";
        }else {
            if(displayText.isEmpty) {
                me.text = "BLANK";
            }else {
                me.text = displayText;
            }
        }
        DivElement myContentDiv = new DivElement();
        me.append(myContentDiv);
        bool expanded = false;
        //first level is opened
        if(parent == null) {
            show(myContentDiv, tombstone);
        }
        me.onClick.listen((Event e) {
            e.stopPropagation();
            if(parent != null) {
                parent.selection = this;
                //makes sure sibling are no longer selected
                parent.unselect();
            }
            //will make sure parents are selected up the chain.
            print("time to select");
            select();
            me.classes.add("tombstoneMagnetSuperSelected");


            tombstone.redraw();
            if(!expanded) {
                show(myContentDiv,tombstone);
                expanded = true;
            } else {
                //TODO when i click on a child technically i'm clicking on me too and i vanish
               // expanded =false;
               //hide(myContentDiv);
                //e.stopPropagation();
            }
        });

        return me;
    }

    //unselect my children too
    void unselect() {
        print("trying to unselect $displayText");
        if(me != null) {
            me.classes.remove("tombstoneMagnetSelected");
            me.classes.remove("tombstoneMagnetSuperSelected");
        }
        content.forEach((TombstoneFridgeMagnet child) {
            child.unselect();
        });
    }

    //select my parent too (who will select their parent etc)
    void select() {
        print("trying to select $displayText");
        if(me != null) {
            me.classes.add("tombstoneMagnetSelected");
        }
        if(parent != null) {
            parent.select();
        }
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
        return new TombstoneFridgeMagnet("word", <TombstoneFridgeMagnet>[nouns, verbs, suffix, preposition,conjunctions, interjection, punctuation, phrases,bullshit, blank]);

    }

    //todo sub this out into categories
    static TombstoneFridgeMagnet get nouns {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("it", []));
        content.add(animate_nouns);
        content.add(travel_nouns);
        content.add(concepts);
        return new TombstoneFridgeMagnet("noun", content);
    }

    static TombstoneFridgeMagnet get blank {
        return new TombstoneFridgeMagnet("", []);
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

    static TombstoneFridgeMagnet get concepts {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("secret", []));
        content.add(new TombstoneFridgeMagnet("gigglesnort", []));
        content.add(new TombstoneFridgeMagnet("myserty", []));
        content.add(new TombstoneFridgeMagnet("mystery", []));
        content.add(new TombstoneFridgeMagnet("[REDACTED]", []));
        content.add(new TombstoneFridgeMagnet("life", []));
        content.add(new TombstoneFridgeMagnet("void", []));
        content.add(new TombstoneFridgeMagnet("time", []));
        content.add(new TombstoneFridgeMagnet("light", []));
        content.add(new TombstoneFridgeMagnet("space", []));
        content.add(new TombstoneFridgeMagnet("doom", []));
        content.add(new TombstoneFridgeMagnet("rage", []));
        content.add(new TombstoneFridgeMagnet("blood", []));
        content.add(new TombstoneFridgeMagnet("nowhere", []));

        return new TombstoneFridgeMagnet("concept", content);
    }

    static TombstoneFridgeMagnet get preposition  {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("like", []));
        content.add(new TombstoneFridgeMagnet("to", []));
        content.add(new TombstoneFridgeMagnet("after", []));
        content.add(new TombstoneFridgeMagnet("before", []));
        content.add(new TombstoneFridgeMagnet("in", []));
        content.add(new TombstoneFridgeMagnet("under", []));
        content.add(new TombstoneFridgeMagnet("around", []));
        content.add(new TombstoneFridgeMagnet("by", []));
        content.add(new TombstoneFridgeMagnet("near", []));

        return new TombstoneFridgeMagnet("preposition", content);
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

    static TombstoneFridgeMagnet get interjection {
        List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
        content.add(new TombstoneFridgeMagnet("wow", []));
        content.add(new TombstoneFridgeMagnet("oh", []));
        content.add(new TombstoneFridgeMagnet("now", []));
        content.add(new TombstoneFridgeMagnet("hey", []));
        content.add(new TombstoneFridgeMagnet("hmmm", []));
        content.add(new TombstoneFridgeMagnet("interesting", []));
        content.add(new TombstoneFridgeMagnet("yes", []));
        content.add(new TombstoneFridgeMagnet("god", []));
        content.add(new TombstoneFridgeMagnet("shit", []));
        content.add(new TombstoneFridgeMagnet("damn", []));
        content.add(new TombstoneFridgeMagnet("bluh", []));
        content.add(new TombstoneFridgeMagnet("shhhh", []));
        content.add(new TombstoneFridgeMagnet("worm", []));
        content.add(new TombstoneFridgeMagnet("psst", []));
        return new TombstoneFridgeMagnet("interjection", content);
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
        content.add(new TombstoneFridgeMagnet("ly", [], spaceBefore: false));

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
        content.add(new TombstoneFridgeMagnet(")", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("(", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("=", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("D", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet("P", [], spaceBefore: false));
        content.add(new TombstoneFridgeMagnet(">", [], spaceBefore: false));

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

