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
        List<String> quips = <String>["Test"];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),"Who are you?", 3,null);
        new TalkyQuestion(rand.pickFrom(quips),tr,level);
    }

    static String whatQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["Test"];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),"What are you?", 3,null);
        new TalkyQuestion(rand.pickFrom(quips),tr,level);

    }

    static String whatsGoingOn(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["Test"];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),"What's going on?'", 3,null);
        new TalkyQuestion(rand.pickFrom(quips),tr,level);

    }


    static String fenrirQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>[""];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),"Do you know about Fenrir?", 3,null);
        new TalkyQuestion(rand.pickFrom(quips),tr,level);

    }

    static String birdQuips(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["Test"];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),"Are there trees on LOMAT?", 3,null);
        new TalkyQuestion(rand.pickFrom(quips),tr,level);
    }

    static String treeQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["Test"];
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),"What do you know about birds?", 3,null);
        new TalkyQuestion(rand.pickFrom(quips),tr,level);
    }

}