/*
 fenrir needs to be able to write words to the screen. roughly at head height. similar to magical girl sim
 needs to be timed, for him to just say BORK at you. and then say more things
 maybe sounds that are audio libed?
 */
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';

import '../Game.dart';
import '../GameStats.dart';
import '../NPCs/Tombstone.dart';

class Fenrir {

    static String HAPPY="HAPPY";
    static String NEUTRAL="NEUTRAL";
    static String ANGRY ="ANGRY";

    static String get opinion {
        GameStats gs = Game.instance.gameStats;
        if(gs.theDead.isEmpty && gs.voidVisits < 2) {
            return NEUTRAL;
        }else if(gs.theDead.isEmpty) {
            return HAPPY;
        }else if(gs.theDead.length < 2) {
            return NEUTRAL;
        }else {
            return ANGRY;
        }
    }



    static List<String> happyHellos = <String>["BORK!!!!!","HI HI HI we are FRIENDS!!!!!","ITS YOU ITS YOU ITS YOU ITS YOU ITS YOU!!!!","treat????? TREAT!!!!!","you're so good!!!! way better than the REAL guide!!!!!"];
    static List<String> neutralHellos = <String>["BORK!!!!!","FRIEND?????","!!!!! a friend?????  A FRIEND!!!!!"];
    static List<String> angryHellos = <String>["BORK!!!!!","GRRRR!!!!!","go AWAY!!!!!"];
    //bork goes with everything, add things to these sections based on stats
    static List<String> _happyPhrases = <String>["BORK!!!!!","my WHOLE BODY is a big TAIL and I am WAGGING it for my FRIEND!!!!!","BEST FRIEND I WISH I HAD MORE THAN BUGS TO FEED YOU!!!!!","i wish i HADNT EATEN ALL THE NOT-BUGS so you could have some GOOD CRUNCH!!!!!"];
    static List<String> _neutralPhrases = <String>["BORK!!!!!","boy these CHAINS get REALLY REALLY REALLY REALLY REALLY cold here!!!!!"];
    static List<String> _angryPhrases = <String>["BORK!!!!!","GRRRR!!!!!","i HATE you!!!!!","you're BAD and UNIMPORTANT and FAKE and NO ONE LIKES YOU!!!!!","you can't just TAKE THEM AWAY FROM ME!!!!!","put them BACK!!!!! they aren't HAPPY in the GROUND!!!!!","You're just a FAKE GUIDE!!!!! You aren't IMPORTANT and you can't BEAT ME!!!!!","BORK BORK BORK BORK BORK!!!!!","you're FAKE and UNIMPORTANT and IRRELEVANT and NONE OF THIS EVEN MATTERS!!!!","you aren't a REAL player!!!!!"];

    //add specific things to this on the fly
    static List<String> get happyPhrases {
        GameStats gs = Game.instance.gameStats;
        List<String> ret = new List.from(_happyPhrases);
        if(gs.helplessBugsKilled > 13) {
            ret.add("CRUNCH CRUNCH CRUNCH CRUNCH CRUNCH goes bugs!!!!!");
            //ret.add("");
            ret.add("BEST FRIEND likes crunching BUGS too!!!!!");
            ret.add("BUGS are so CRUNCHY and BEST FRIEND gets it!!!!!");
            ret.add("give me the CRONCH and i'm yours forever!!!!!");
        }else {
            ret.add("BEST FRIEND BEST FRIEND you HAVE to try BUG CRUNCHING sometime!!!!!");
        }
        return ret;
    }

    //add specific things to this on the fly
    static List<String> get neutralPhrases {
        GameStats gs = Game.instance.gameStats;
        List<String> ret = new List.from(_neutralPhrases);
        if(gs.helplessBugsKilled <= 13) {
            ret.add("????? you don't like BUG CRUNCHING??????");
        }
        return ret;
    }

    //add specific things to this on the fly
    static List<String> get angryPhrases {
        GameStats gs = Game.instance.gameStats;
        List<String> ret = new List.from(_angryPhrases);
        if(gs.helplessBugsKilled == 0) {
            ret.add("MEANIE!!!!! you won't crunch stupid bugs but you WILL HURT MY FRIENDS?????");
        }
        for(Tombstone t in gs.theDead) {
            if(t.npcName.contains("Ebony")) ret.add("SPOOKY FRIEND was my FRIEND and she WANTED TO BE CRUNCHED!!!!!");
            if(t.npcName.contains("Skol")) ret.add("BORK FRIEND understood how TASTY BIRDS are!!!!!");
            if(t.npcName.contains("Roger")) ret.add("LAW FRIEND could tell you!!!!! I didn't break ANY laws!!!!!");
            if(t.npcName.contains("Halja")) ret.add("SMUG FRIEND was the ONLY ONE who UNDERSTOOD ME and you BURIED HER!!!!!");
            if(t.npcName.contains("Kid")) ret.add("COWBOY FRIEND knew I was a LITTLE DOGGY and you TOOK HIM FROM ME!!!!!");
        }

        if(gs.theDead.length >=5) {
            ret.add("they are MY friends not YOURS!!!!! I'm the one who brought them back!!!!!");
            ret.add("of COURSE they are my FRIENDS!!!!! I SAID I was SORRY!!!!!");
            ret.add("It's not my FAULT they looked TASTY!!!!! and I BROUGHT THEM BACK so they can't be ANGRY at me!!!!!");
        }
        return ret;
    }

    static void wakeUP(Element container) {
        sayHello(container);
        int time = new Random().nextIntRange(1000,10000);
        new Timer(new Duration(milliseconds: time), () =>
            beChatty(container));
    }

    static void beChatty(Element container) {
        chat(container);
        int time = new Random().nextIntRange(1000,10000);
        new Timer(new Duration(milliseconds: time), () =>
            beChatty(container));
    }

    static void chat(Element container) {
      List<String> choices;
      String op = opinion;
      if(op == HAPPY) choices = happyPhrases;
      if(op == NEUTRAL) choices = neutralPhrases;
      if(op == ANGRY) choices = angryPhrases;

      popup(new Random().pickFrom(choices), container, null,0,new Random().nextIntRange(50, 200), new Random().nextIntRange(50, 400));
    }

    static void sayHello(Element container) {
        List<String> choices;
        String op = opinion;
        if(op == HAPPY) choices = happyHellos;
        if(op == NEUTRAL) choices = neutralHellos;
        if(op == ANGRY) choices = angryHellos;
        popup(new Random().pickFrom(choices), container);
    }

    static Future<void> popup(String text, Element container,[DivElement currentPopup, int tick=0,int x =170, int y=80]) async {
        int maxTicks = 30;

        if(currentPopup != null && tick == 0) {
            currentPopup.remove();
            currentPopup = null;
        }

        if(currentPopup == null) {
            currentPopup = new DivElement()
                ..classes.add("fenrirPopup")
                ..text = text;
            container.append(currentPopup);
        }
        Random rand = new Random();
        rand.nextInt();
        if(rand.nextBool()) {
            currentPopup.style.left = "${x+rand.nextInt(15)}px";
        }else {
            currentPopup.style.left = "${x-rand.nextInt(15)}px";
        }
        if(rand.nextBool()) {
            currentPopup.style.top = "${y+rand.nextInt(15)}px";
        }else {
            currentPopup.style.top = "${y-rand.nextInt(15)}px";
        }
        if(tick == 1) {
            currentPopup.animate([{"opacity": 100},{"opacity": 0}], 6000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 200), () =>
                popup(text, container, currentPopup, tick+1,x,y));
        }else {
            currentPopup.remove();
        }

    }

}