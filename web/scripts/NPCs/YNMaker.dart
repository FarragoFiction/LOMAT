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

    static String whoQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand ) {
        List<String> quips = <String>["why i'm whatever you think i am. that's not a satisfying answer. but reality rarely is satisfying.","well i'm yn. that's mostly what i go by these days... although there aren't that many people around to 'go by' anyway.","fuck. fuck fuck fuck. i'm... me? yeah i'm signing an i.o.u on that one. can't think right now.","i mean... does it matter? seriously. you're telling me that there's nothing in a five mile radius and you're worried about who i am? i assure you there are bigger things going on than that."];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Who are you?",tr,level);
    }

    static String whatQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["well that's kind of a loaded question isn't it? what if some rando came to you and asked YOU that question? i don't know about you... but that'd slightly hurt my feelings.","presumably the same as you. right? just because you got a little sick during an apocalyptic what-do doesn't mean basic biology changes.","what are YOU? what is this? what happened to everyone?","well you have to be some new kinda species right? i'm a human. used to be around here before you... but the will of the gods presents itself in REAL interesting ways."];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What are you?",tr,level);

    }

    static String whatsGoingOn(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["nothing. but also everything? gonna be real with you... i swallowed a bunch of snow and i am NOT feeling so good right now. that's your survival tip of the day-- just-- don't eat snow.","well not much that you don't probably know about. lots of snow. pretty cold. lots of seagulls squawking constantly. the usual.","does- does it look like i know? i don't. i really don't. i'm kind of scared about that.","a very good and deserved dose of divine retribution my friend. sometimes all you can do is just start everything from scratch."];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What's going on?",tr,level);

    }


    static String fenrirQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["fenrir? oh man. you mean like the dog? yeah. god that dog is big. that dog's at least the size of a two-story house-- i could LIVE in that dog. you know. if i wanted.","fen...rir? sounds funny. is it a god? i think i'd know if it was a god.","oh. fenrir? there's plenty of cloth to cut there. the large abominal wolf who severed the hand of the god of order. chained underground for the safety of everyone. son of... the name escapes me... what was it? do you remember? eeeh. you probably don't.","feeeenrir. fenrir fenrir... what IS a fenrir? not literally. but more like... what ISN'T fenrir? anything can be fenrir if you squint."];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Do you know about Fenrir?",tr,level);

    }

    static String birdQuips(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["well what do YOU know about birds? do you know what a bird is? you don't look like you know what a bird is. not TRULY. open your miiiiiiind.","well i know the birds around here could be looking better. have you SEEN them? scrawny like sticks. do you think they're sick? that probably explains the blankets.","birds... what? did something happen to them?... is there anything left?","i know plenty about birds. did you know birds tended to be seen as messengers of gods? sometimes they were symbols themselves but mostly they were scribes or record-keepers. i know you probably don't know a lot about this stuff. but that's what learning's for right?"];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What do you know about birds?",tr,level);
    }

    static String treeQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["oh there's plenty. there's at least as many as one. maybe even two... but mostly one.","i don't think so. i've looked around but... wait. what's a lomat?","oh definitely not. the lords have punished us for our hubris so we don't get those anymore. it was probably because of the christmas tree worshipping. that's MY theory anyway.,technically. if you think about it anything could be a lot of little trees. potatoes could be little trees. trees have a lot of little trees. food for thought."];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Are there trees on LOMAT?",tr,level);
    }

}