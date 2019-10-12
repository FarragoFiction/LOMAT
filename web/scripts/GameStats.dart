/*
    because this is a void land, most of what you do doesn't matter and gets reset each play through.
    but some things don't. mostly for fenrir's memory.
 */
import 'CipherEngine.dart';
import 'NPCs/Tombstone.dart';

//TODO please have a credit screen thanking contest winners and GhoulPen
class GameStats {
    int helplessBugsKilled = 0;
    List<Tombstone> theDead = new List<Tombstone>();
    int voidVisits = 0;
    bool lomatBeaten = false;

    static GameStats load() {
        GameStats stat = new GameStats();
        //TODO load from local storage
        return stat;
    }

    //only for your own personal gulls plz
    void mournTheDead(Tombstone dead) {
        theDead.add(dead);
        CipherEngine.voidPrint("rip ${dead.npcName}");
        CipherEngine.voidPrint("hopefully no asshole barking dog will wake you back up");
    }

    void killedAnInnocent() {
        helplessBugsKilled ++;
        CipherEngine.voidPrint("you aren't a Player dunkass, they aren't attacking you");
        CipherEngine.voidPrint("god you don't even need money. you're a VOID player.");
        CipherEngine.voidPrint("the mini game isn't even fun");
        CipherEngine.voidPrint("i just added it because thats what you do with oregon trail.");
        CipherEngine.voidPrint("plus, doc asked me to...");

    }

    //who's a good boi???
    void visitAGoodBoi() {
        voidVisits ++;
        CipherEngine.voidPrint("who's a good boi???");
        CipherEngine.voidPrint("is it fenrir???");
        CipherEngine.voidPrint("probably not.");
    }

    //oh god why
    void ohNoOhFuck() {
        lomatBeaten = true;
        CipherEngine.voidPrint("uh.");
        CipherEngine.voidPrint("BB?");
        CipherEngine.voidPrint("are you okay?");
        CipherEngine.voidPrint("why don't you go on break there, buddy");
    }

}