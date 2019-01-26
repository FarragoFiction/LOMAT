//a tombstone knows where its png is
//a tombstone knows how to draw itself to the canvas using that rune-ish font
//a tombstone knows what its npc is
//a tombstone knows its cause of death (can you void it???) wait no the npc knows that don't worry about it.
//but yes , TODO if the cause of death is null the Tombstone tears itself down.
//TODO make page just for testing the builder in this

import 'LOMATNPC.dart';
import 'dart:async';
import 'dart:html';
import 'package:LoaderLib/Loader.dart';

/*
    TODO i want to have a builder where you have drop downs or something of words to pick for up to three words
    and then also three templates to pick from. look at how bloodborne does it maybe
    players can put any kind of word in each slot, whatever, go nuts
    but the words themselves are in labeled drop downs
    so i guess each drop down has a button tied to it for "set to word"  1,2,or 3

    i want to have a test page just for this builder, then i want to make sure travel stops when its time to make one of  these in a popup

    i also want an already built tombstone to be able to be passed by (just like a tree). if you click on it time pauses
     and you can read the big version of it

     TODO make a template an object that has three words attached to it maybe? otherwise WORD1 is gonna get repeated a LOT.


 */
class Tombstone {
    static String NAMETAG = "#NAME#";
    static String CODTAG = "#COD#";
    //a tombstone has one piece of content for each "fridge magnet" attached to it.
    //can have up to 8?
    //each magent has everything possible inside it (don't drill too deep yo)
    List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();

    //if this is null its probably from online
    LOMATNPC npc;
    String imageLoc = "TODO";
    //the rest is procedural.
    String epilogue = "They died of $CODTAG.";

    Tombstone() {
        makeTestContent();
    }

    Future<Null> drawSelf(Element container) async {
        DivElement me = new DivElement();
        container.append(me);
        CanvasElement canvas = await makeCanvas();
        drawText(canvas);
        me.append(canvas);
        //TODO have canvas be cached so it can be drawn to.
        //TODO have builder draw itself
        makeBuilder();
    }

    void makeTestContent() {
        //these have no children so test that first
        //TODO have at least one with children, test it drills down right
        content.add(new TombstoneFridgeMagnet("peperony", []));
        content.add(new TombstoneFridgeMagnet("peperony and chease", []));
        content.add(new TombstoneFridgeMagnet("smash", []));
        content.add(new TombstoneFridgeMagnet("is this a", []));


    }


    String get npcName {
        if(npc != null) {
            return npc.name;
        }else {
            return "WWWWWWWW";
        }
    }

    String get npcCOD {
        if(npc != null) {
            return npc.causeOfDeath;
        }else {
            return "WWWWWWWW";
        }
    }

    //peperony and chease
    String get fullEpilogue {
        String ret = "$epilogue";
        ret = ret.replaceAll(NAMETAG, npcName);
        ret = ret.replaceAll(CODTAG, npcCOD);
        return ret;
    }

    //each line has a space i guess???
    String get fullCustomBullshit {
        String ret = "";
        for(TombstoneFridgeMagnet line in content) {
            ret = "$ret${line.getChosenRoot()}";
        }
        return ret;
    }

    void drawText(CanvasElement canvas) {
        print("drawing text of $epilogue");
        int fontSize = 20;
        int currentX = 275;
        int currentY = 200;
        int buffer = 15;
        canvas.context2D.font  ="${fontSize}px norse";
        canvas.context2D.fillStyle = "#5f5f7f";
        canvas.context2D.fillText(npcName.toUpperCase(), currentX,currentY);
        currentY= 250;
        currentX = 400;
        fontSize = 18;
        canvas.context2D.textAlign = "center";
        canvas.context2D.font  ="${fontSize}px norse";

        List<String> lines = wrap_text_lines(canvas.context2D, "$fullEpilogue".toUpperCase(),120,150);
        for(String line in lines) {
            canvas.context2D.fillText(line.toUpperCase(), currentX,currentY);
            currentY += buffer + fontSize;
        }

        currentY += buffer+fontSize;

        lines = wrap_text_lines(canvas.context2D, "$fullCustomBullshit".toUpperCase(),120,150);
        for(String line in lines) {
            canvas.context2D.fillText(line.toUpperCase(), currentX,currentY);
            currentY += buffer + fontSize;
        }


    }

    static List<String> wrap_text_lines(CanvasRenderingContext2D ctx, String text, num x, int maxWidth) {

        List<String> words = text.split(' ');
        List<String> lines = <String>[];
        int sliceFrom = 0;
        for (int i = 0; i < words.length; i++) {
            String chunk = words.sublist(sliceFrom, i).join(' ');
            bool last = i == words.length - 1;
            bool bigger = ctx
                .measureText(chunk)
                .width > maxWidth;
            if (bigger) {
                lines.add(words.sublist(sliceFrom, i).join(' '));
                sliceFrom = i;
            }
            if (last) {
                lines.add(words.sublist(sliceFrom, words.length).join(' '));
                sliceFrom = i;
            }
        }
        //need to return how many lines i created so that whatever called me knows where to put ITS next line.;
        return lines;
    }

    Future<CanvasElement> makeCanvas() async {
        CanvasElement canvas = new CanvasElement(width: 800, height: 600);
        ImageElement img = await Loader.getResource("images/tombstone.png");
        canvas.context2D.drawImage(img,0,0);
        //TODO draw epilogue
        return canvas;
    }

    Element makeBuilder() {
        throw ("TODO");
        //need to display one TombstoneContentCategory box, once its drilled down to a value it
        //pops up a new box (and displays current value into the canvas).
        //any box without a final value just doesn't show up on the tombstone
    }

    //don't get any of these from file or people can hax
    Future<List<String>> get nouns async {
        List<String> ret = <String>[];
        ret.add("bird");
        ret.add("ghost");
        ret.add("seagull");
        ret.add("party member");
        return ret;
    }

    Future<List<String>> get verbs async {
        List<String> ret = <String>[];
        ret.add("sqwawk");
        ret.add("chatter");
        ret.add("steal");
        ret.add("clack");
        return ret;
    }

    Future<List<String>> get adj async {
        List<String> ret = <String>[];
        ret.add("best");
        ret.add("most");
        ret.add("most average");
        ret.add("flavorful");
        return ret;
    }


}

//builds an epilogue up like making fridge magnet poetry
//one of these is an entire builder, shows all categories and subcategories
//when a user makes a selection that words itself is put in the tombstone
//and if its actually a category header it will drill down into (but not select anything in) its category

class TombstoneFridgeMagnet {
    String displayText;
    //so i can have compound words like play-ed
    bool spaceBefore;
    bool spaceAfter;
    TombstoneFridgeMagnet selection;
    List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();

    String get displayTextWithSpaces {
        String ret = "$displayText";
        if(spaceAfter) {
            ret = "$ret ";
        }

        if(spaceBefore) {
            ret = " $ret";
        }

        return ret;
    }

    TombstoneFridgeMagnet(String this.displayText, List<TombstoneFridgeMagnet> this.content, {this.spaceBefore: true, this.spaceAfter:true} );

    //recursive
    String getChosenRoot() {
        if(content.isEmpty || selection == null) {
            return displayTextWithSpaces;
        }else {
            return selection.getChosenRoot();
        }
    }
////////////////////////////////////////////////////////////////
    //NONE of these get loaded from file becaues this has to be hax proof

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
        content.add(new TombstoneFridgeMagnet("", []));
        content.add(new TombstoneFridgeMagnet("", []));
        content.add(new TombstoneFridgeMagnet("", []));




        return new TombstoneFridgeMagnet("phrase", content);
    }

    static List<TombstoneFridgeMagnet> topLevel() {

    }
}

