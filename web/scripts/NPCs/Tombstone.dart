//a tombstone knows where its png is
//a tombstone knows how to draw itself to the canvas using that rune-ish font
//a tombstone knows what its npc is
//a tombstone knows its cause of death (can you void it???) wait no the npc knows that don't worry about it.
//but yes , TODO if the cause of death is null the Tombstone tears itself down.
//TODO make page just for testing the builder in this

import 'LOMATNPC.dart';
import 'dart:async';
import 'dart:html';

/*
    TODO i want to have a builder where you have drop downs or something of words to pick for up to three words
    and then also three templates to pick from. look at how bloodborne does it maybe
    players can put any kind of word in each slot, whatever, go nuts
    but the words themselves are in labeled drop downs
    so i guess each drop down has a button tied to it for "set to word"  1,2,or 3

 */
class Tombstone {
    //
    static String NAMETAG = "<<NAME>>";
    static String CODTAG = "<<COD>>";
    static String WORD1 = "<<WORD1>>";
    static String WORD2 = "<<WORD2>>";
    static String WORD3 = "<<WORD3>>";


    LOMATNPC npc;
    String imageLoc = "TODO";
    //the rest is procedural.
    String epilogue = "Here lies $NAMETAG. They died of $CODTAG.";

    CanvasElement makeCanvas() {
        throw("TODO");
    }

    //TODO have this loaded from file async style so ppl can add stuff
    Future<List<String>> get templates async {
        List<String> ret = <String>[];
        //when a given template is on screen, auto fill in the values of the drop downs ???
        //can pick up to three templates at once?
        ret.add("They were the <<WORD1>> <<WORD2>>. It was them.");
        ret.add("They really did love <<WORD1>>ing.");
        ret.add("No one misses them.");
        ret.add("They are survived by their <<WORD1>>. ");
        return ret;
    }

    //todo load nouns from pl's text thingy
    Future<List<String>> get nouns async {
        List<String> ret = <String>[];
        ret.add("bird");
        ret.add("ghost");
        ret.add("seagull");
        ret.add("party member");
        return ret;
    }

    //todo load verbs from pl's text thingy
    Future<List<String>> get verbs async {
        List<String> ret = <String>[];
        ret.add("sqwawk");
        ret.add("chatter");
        ret.add("steal");
        ret.add("clack");
        return ret;
    }

    //todo load adj from pl's text thingy
    Future<List<String>> get adj async {
        List<String> ret = <String>[];
        ret.add("best");
        ret.add("most");
        ret.add("most average");
        ret.add("flavorful");
        return ret;
    }


}