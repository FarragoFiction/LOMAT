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
    static String NAMETAG = "<<NAME>>";
    static String CODTAG = "<<COD>>";
    List<TombstoneContentCategory> content;

    //if this is null its probably from online
    LOMATNPC npc;
    String imageLoc = "TODO";
    //the rest is procedural.
    String epilogue = "Here lies $NAMETAG. They died of $CODTAG.";

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

    void drawText(CanvasElement canvas) {
        print("drawing text of $epilogue");
        wrap_text(canvas.context2D, "$epilogue\n TODO: CHOSEN TEXT",100,100,15,800,"center");
    }

    static int wrap_text(CanvasRenderingContext2D ctx, String text, num x, num y, num lineHeight, int maxWidth, String textAlign) {
        if (textAlign == null) textAlign = 'center';
        ctx.textAlign = textAlign;
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
        num offsetY = 0.0;
        num offsetX = 0;
        if (textAlign == 'center') offsetX = maxWidth ~/ 2;
        for (int i = 0; i < lines.length; i++) {
            ctx.fillText(lines[i], x + offsetX, y + offsetY);
            offsetY = offsetY + lineHeight;
        }
        //need to return how many lines i created so that whatever called me knows where to put ITS next line.;
        return lines.length;
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

//a category has a list of things inside it which might be sublists or might be end phrases
class TombstoneContentCategory {
    String displayText;
    List<TombstoneContentCategory> content = new List<TombstoneContentCategory>();

    static List<TombstoneContentCategory> topLevel() {

    }
}

//when chosen modifies the Tombstone it blongs to
 class  TombstonePhrase extends TombstoneContentCategory{
}