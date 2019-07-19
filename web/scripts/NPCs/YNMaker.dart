//has -2 gnosis. this has...effects.
import 'dart:html';

import 'package:CommonLib/Random.dart';

import 'NonGullLOMATNPC.dart';
import 'TalkyItem.dart';
import 'TalkyLevel.dart';
import 'TalkyQuestion.dart';
import 'TalkyResponse.dart';

abstract class YNMaker {
    static List<int> emotions = <int>[TalkyItem.HAPPY, TalkyItem.NEUTRAL, TalkyItem.SAD];

    //every time you spawn yn, he is different
    static NonGullLOMATNPC spawnAYN(int seed) {
        print("yn is being spawned with seed $seed");
        Random rand = new Random(seed);
        TalkyLevel level = new TalkyLevel(new List<TalkyItem>(),null);
        NonGullLOMATNPC yn = new NonGullLOMATNPC("YN",level,new ImageElement(src: "images/Seagulls/dainsleif.png"));
        if(rand.nextBool()) {
            whoQuip(yn, level, rand);
        }else {
            whatQuip(yn, level, rand);
        }
        whatsGoingOn(yn, level, rand);
        fenrirQuip(yn, level, rand); //TODO lock to fenrir heard about
        treeQuip(yn, level, rand); //TODO lock to trees
        birdQuips(yn, level, rand);


        return yn;

    }

    static List<TalkyItem> getSubQuestions(NonGullLOMATNPC yn,Random rand ) {
        List<TalkyItem> ret = new List<TalkyItem>();
        int subquestions = rand.nextIntRange(0,5);
        for(int i = 0; i<subquestions; i++) {
            ret.add(miscQuip(yn, rand));
        }
        return ret;

    }

    static TalkyQuestion miscQuip(NonGullLOMATNPC yn,Random rand ) {
        List<String> quips = <String>["i'm still thinking about that dog. it's not that i want to live in it. but like... i COULD. that's a terrifying statement. imagine being able to do something at any time that was as wild as crawling into the mouth of a mutant dog. you know. just think about it.","everything's... gone. those bastards really DID it. holy shit... there's nothing- nothing LEFT. i'm scared. i'm scared i'm scared i'm scared FUCK.","being a messiah is hard. it's hard and nobody understands. do you know how much energy it takes to be right all the time? it's almost criminal. i am almost criminal... well no. i am a criminal. messiah criminal. same difference right?","god i have a massive headache. eating snow was such a big mistake. a TERRIBLE act of hubris. all my attempts to worship gods fall short to my denial to accept one of the baser ones... biology.","i never got the rune associated with fenrir. i kind of didn't do... well. but it's fine! i'm here now. i'll probably steal it while you aren't looking. don't try to stop me.","there's a future ahead of you. i wouldn't call it bright. if valhalla's what you're seeking then i can at least guarantee you that you'll find it. but is it what you want?","this right hither is mine páintsleif! t causes the death of a man every time tis bared. its strokes art at each moment fine. tis eke a very much VALOROUS brush just for painting. ","it’s weird. i keep walking around into any direction and i always just end up right back at this town but you seem to be able to travel just fine. you oughta teach me how to some time.","everyone has to be fine. right? they can’t all just be gone. i can’t be the only one left. i don’t want to think about being the only one left. if i am... i swear i’ll make you pay.","it's weird. do you remember what i say? sometimes i feel like i'm talking to you and it feels vacant. i hope you're doing okay yeah? i worry about that.","everything just keeps happening and i can't get my mind off it. what's happening? how did i get here? why are we here? how did the moon disappear? i'm really fixated on the moon part. ","it's strange. whenever i try remembering anything before this i can't. it's just... nothingness. do you remember anything? do you even remember yourself?","i thought i saw myself waving back at me from far away for a few seconds when i first got to this town. it might’ve been a hopeghost. or i’m actually losing my shit."];
        TalkyLevel level2 = new TalkyLevel(new List<TalkyItem>(),null);
        List<String> questions = <String>["Wait. What?","Uh...okay?", "Are you okay?","...","I. What?"];

        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        return new TalkyQuestion(rand.pickFrom(questions),tr,level2);
    }

    static String whoQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand ) {
        List<String> quips = <String>["why i'm whatever you think i am. that's not a satisfying answer. but reality rarely is satisfying.","well i'm yn. that's mostly what i go by these days... although there aren't that many people around to 'go by' anyway.","fuck. fuck fuck fuck. i'm... me? yeah i'm signing an i.o.u on that one. can't think right now.","i mean... does it matter? seriously. you're telling me that there's nothing in a five mile radius and you're worried about who i am? i assure you there are bigger things going on than that."];
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Who are you?",tr,level);
    }

    static String whatQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["well that's kind of a loaded question isn't it? what if some rando came to you and asked YOU that question? i don't know about you... but that'd slightly hurt my feelings.","presumably the same as you. right? just because you got a little sick during an apocalyptic what-do doesn't mean basic biology changes.","what are YOU? what is this? what happened to everyone?","well you have to be some new kinda species right? i'm a human. used to be around here before you... but the will of the gods presents itself in REAL interesting ways."];
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What are you?",tr,level);

    }

    static String whatsGoingOn(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["nothing. but also everything? gonna be real with you... i swallowed a bunch of snow and i am NOT feeling so good right now. that's your survival tip of the day-- just-- don't eat snow.","well not much that you don't probably know about. lots of snow. pretty cold. lots of seagulls squawking constantly. the usual.","does- does it look like i know? i don't. i really don't. i'm kind of scared about that.","a very good and deserved dose of divine retribution my friend. sometimes all you can do is just start everything from scratch."];
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What's going on?",tr,level);

    }


    static String fenrirQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["fenrir? oh man. you mean like the dog? yeah. god that dog is big. that dog's at least the size of a two-story house-- i could LIVE in that dog. you know. if i wanted.","fen...rir? sounds funny. is it a god? i think i'd know if it was a god.","oh. fenrir? there's plenty of cloth to cut there. the large abominal wolf who severed the hand of the god of order. chained underground for the safety of everyone. son of... the name escapes me... what was it? do you remember? eeeh. you probably don't.","feeeenrir. fenrir fenrir... what IS a fenrir? not literally. but more like... what ISN'T fenrir? anything can be fenrir if you squint."];
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Do you know about Fenrir?",tr,level);

    }

    static String birdQuips(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["well what do YOU know about birds? do you know what a bird is? you don't look like you know what a bird is. not TRULY. open your miiiiiiind.","well i know the birds around here could be looking better. have you SEEN them? scrawny like sticks. do you think they're sick? that probably explains the blankets.","birds... what? did something happen to them?... is there anything left?","i know plenty about birds. did you know birds tended to be seen as messengers of gods? sometimes they were symbols themselves but mostly they were scribes or record-keepers. i know you probably don't know a lot about this stuff. but that's what learning's for right?"];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What do you know about birds?",tr,level);
    }

    static String treeQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["oh there's plenty. there's at least as many as one. maybe even two... but mostly one.","i don't think so. i've looked around but... wait. what's a lomat?","oh definitely not. the lords have punished us for our hubris so we don't get those anymore. it was probably because of the christmas tree worshipping. that's MY theory anyway.,technically. if you think about it anything could be a lot of little trees. potatoes could be little trees. trees have a lot of little trees. food for thought."];
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Are there trees on LOMAT?",tr,level);
    }

}