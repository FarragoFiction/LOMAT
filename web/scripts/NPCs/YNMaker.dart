//has -2 gnosis. this has...effects.
import 'dart:html';

import 'package:CommonLib/Random.dart';

import 'LOMATNPC.dart';
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
        //TODO add road events for these yns.
        //TODO future jr, this is a shitty hack, but makes it so whatever bug get fixed
        //TODO the bug is that if you go into sub questions for yn, you can never leave them
        yn = LOMATNPC.loadFromDataString(yn.toDataString());
        return yn;

    }

    static List<TalkyItem> getSubQuestions(NonGullLOMATNPC yn,Random rand ) {
        List<TalkyItem> ret = new List<TalkyItem>();
        int subquestions = rand.nextIntRange(0,4);
        for(int i = 0; i<subquestions; i++) {
            ret.add(miscQuip(yn, rand));
        }
        return ret;

    }

    static TalkyQuestion miscQuip(NonGullLOMATNPC yn,Random rand ) {
        List<String> quips = <String>["this revolution was completely worth it. yes. even the part where everyone seems to be dead. totally worth it. snow is a perfectly valid substitute for food.","i'm still thinking about that dog. it's not that i want to live in it. but like... i COULD. that's a terrifying statement. imagine being able to do something at any time that was as wild as crawling into the mouth of a mutant dog. you know. just think about it.","everything's... gone. those bastards really DID it. holy shit... there's nothing- nothing LEFT. i'm scared. i'm scared i'm scared i'm scared FUCK.","being a messiah is hard. it's hard and nobody understands. do you know how much energy it takes to be right all the time? it's almost criminal. i am almost criminal... well no. i am a criminal. messiah criminal. same difference right?","god i have a massive headache. eating snow was such a big mistake. a TERRIBLE act of hubris. all my attempts to worship gods fall short to my denial to accept one of the baser ones... biology.","i never got the rune associated with fenrir. i kind of didn't do... well. but it's fine! i'm here now. i'll probably steal it while you aren't looking. don't try to stop me.","there's a future ahead of you. i wouldn't call it bright. if valhalla's what you're seeking then i can at least guarantee you that you'll find it. but is it what you want?","this right hither is mine páintsleif! t causes the death of a man every time tis bared. its strokes art at each moment fine. tis eke a very much VALOROUS brush just for painting. ","it’s weird. i keep walking around into any direction and i always just end up right back at this town but you seem to be able to travel just fine. you oughta teach me how to some time.","everyone has to be fine. right? they can’t all just be gone. i can’t be the only one left. i don’t want to think about being the only one left. if i am... i swear i’ll make you pay.","it's weird. do you remember what i say? sometimes i feel like i'm talking to you and it feels vacant. i hope you're doing okay yeah? i worry about that.","everything just keeps happening and i can't get my mind off it. what's happening? how did i get here? why are we here? how did the moon disappear? i'm really fixated on the moon part. ","it's strange. whenever i try remembering anything before this i can't. it's just... nothingness. do you remember anything? do you even remember yourself?","i thought i saw myself waving back at me from far away for a few seconds when i first got to this town. it might’ve been a hopeghost. or i’m actually losing my shit."];
        quips.addAll(<String>["zzzzzzzzzzzzz...","is there really a point to eating when you're dead? i don't think so. i stopped eating and i don't feel hungry. which checks out. do you have to eat? you look... weird.","you know what they say about hope? they say hope is a dangerous thing. hope can kill a man. well. i know for a fact hope can kill SEVERAL mans. but i don't think they were talking about the aspect... or were they?"]);
        TalkyLevel level2 = new TalkyLevel(new List<TalkyItem>(),null);
        List<String> questions = <String>["Wait. What?","Uh...okay?", "Are you okay?","...","I. What?","Tell me more.","Care to elaborate?","Interesting..."];

        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        return new TalkyQuestion(rand.pickFrom(questions),tr,level2);
    }

    static String whoQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand ) {
        List<String> quips = <String>["dunno. can't remember any names i went by. probably many though. that's just the breaks.","hrm... five more minutes...","names are irrelevant when you're dead. but hey! i'm sure they matter. i don't remember mine though.","well shit dude. i'm me. there's not much else to that.","ah! comrade! name’s yearnfulnode. i see you have stopped in this town. yes?","names yn. i steal things and pass them around. i promise i've not taken anything important-- honest!","you want to know who i am? well that's pretty funny. how do you know i'm not blatantly lying to you? but i can tell you one thing... my favorite color is blue.","doesn't matt'r! a nameth can only beest truly did earn in gl'rious spar and battle!","would you laugh if i told you i didn't know? my memory's kind of blurry right now. i'll make sure to answer you some other time though.","what are you. some kind of government cronie? that’s none of your business thank you very much.","you forgot about me? that's... no. i get that. name's yn. i'm mostly here doing what i can to survive.","oh hold on. who are YOU? why do you have HORNS?","i'm yn. yearnfulnode? i've been-- have you seen my little like... recording thingies? i lost a couple of them.","i’m just called yearnfulnode. i used to go by an actual name. it hardly matters anymore.","why i'm whatever you think i am. that's not a satisfying answer. but reality rarely is satisfying.","well i'm yn. that's mostly what i go by these days... although there aren't that many people around to 'go by' anyway.","fuck. fuck fuck fuck. i'm... me? yeah i'm signing an i.o.u on that one. can't think right now.","i mean... does it matter? seriously. you're telling me that there's nothing in a five mile radius and you're worried about who i am? i assure you there are bigger things going on than that."];
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Who are you?",tr,level);
    }

    static String whatQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["a player. duh. come on dude. did you just come out of a rock?","i'm trying to sleep... ask again later...","oh? well i'm dead. i must be dead. right? you're probably dead too. there's no way for ANYTHING to be able to live in this place.","now THAT'S an interesting question. what am i? i could be you but in an alien costume. or you could be ME but in an alien costume. maybe we're BOTH dressed as each other and neither of us are real. food for thought?","the very power of the proletariat my friend! the sheer condensed STEEL of the dreams of the people! if there were... any... people left.","why a sacred rebel obviously. don't you see my robes? i thought that'd be self explanatory.","a friend. trust me.","well i am a viking! i've cometh to gather the spoils of holy battle hither in... uh... whither art we again? ","well from what i know... i'm another species entirely. but pretty similar it seems. i like your horns. can i touch your horns or-- oh. okay. yeah sorry.","well i’m a human. duh. just because there‘s literally no one else around doesn’t mean my kind stopped existing. ","uh... i've told you about this... but sure. i'm a human. kind of like you but less... uh... you?","woah woah. i think there are way more important questions. let's start with where the fuck did the MOON go?! it's an ORB! in the SKY! where the fuck IS IT?","i'm... human? i think? i'm not sure anymore. at this point anything could be possible.","something like you. but less gray and made out of real flesh. that’s surprisingly lacking these days.","well that's kind of a loaded question isn't it? what if some rando came to you and asked YOU that question? i don't know about you... but that'd slightly hurt my feelings.","presumably the same as you. right? just because you got a little sick during an apocalyptic what-do doesn't mean basic biology changes.","what are YOU? what is this? what happened to everyone?","well you have to be some new kinda species right? i'm a human. used to be around here before you... but the will of the gods presents itself in REAL interesting ways."];
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What are you?",tr,level);

    }

    static String whatsGoingOn(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["not much man. what's going on with you?","if everything goes like it should then you won't need to know the answer to that. but right now? birdwatching.","right now...  less sparring than i wanted actually.  hey.  doth thou wot how to wield a sword? thou look like thou wot how to wield a sword.","locally? not much. in a cosmological scale? so much. all the time. always.","you tell me lizard horns. what are you hiding? i’m not gonna rat anyone out.","well right now? nothing that i haven't told you about before. mostly nothing. a lot of snow. the usual.","does it look like i KNOW? frigg help me-- where did all the houses go? how do you get rid of a whole CITY?","my logs got lost. i carry them with me everywhere... you haven't seen them have you? i don't like my personal stuff just out there for anyone to find.","something beyond our understanding. at this point from my experience? you’re better off not asking questions. either escape while you can or sit back and enjoy the ride.","nothing. but also everything? gonna be real with you... i swallowed a bunch of snow and i am NOT feeling so good right now. that's your survival tip of the day-- just-- don't eat snow.","well not much that you don't probably know about. lots of snow. pretty cold. lots of seagulls squawking constantly. the usual.","does- does it look like i know? i don't. i really don't. i'm kind of scared about that.","a very good and deserved dose of divine retribution my friend. sometimes all you can do is just start everything from scratch."];
        quips.addAll(<String>["shh. shut up for a minute. i am SURE that if i just get in the RIGHT POSITION i'll noclip through this floor. just gotta find the right joint.","zzz... man... i am so totally unconscious right now...","well this is valhalla. welcome to the afterlife buddy. there is certainly less eternal battle than i expected... but death is death huh? decomposing is pretty boring though.","well if you ask ME i think someone... stole the sun. that makes sense right? there's no sun and i mean if the sun had EXPLODED you'd think we'd know. who would  want to STEAL a sun? probably horses. i don't trust them.","the sweet fruits of the revolution! well. there would be fruits but everyone’s dead. so... that’s all there is to say on the matter."]);
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What's going on?",tr,level);

    }


    static String fenrirQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["big old dog! yes. i've been wanting to pet him but i'm not sure if it'd be heretical. what do you think?","not much. did you know that gods of hunt tend to be represented as dogs? what do you think they're hunting?","ah aye! the fen-dweller! i hath seen a mighty beast that doth remind me of it aye. hath thee cometh to slay it? ","not really no. i know the general mythology about him but... yeah no dice. sorry.","what? is that one of your government names? some secret illuminati shit? codenames? i’ll figure it out eventually.","ooh right. i was telling you about that... it's this dog in mythology. really big. he was restrained for everyone's safety because a prophecy said he was dangerous-- and he's really REALLY angry about that.","shhh shhh shh. why are dogs BIG now? dogs are big now. why are they BIG.","i know about fenrir yes. he's one of the 85 gods who survived the apocalypse... i keep hearing about a titan too. you think that's related?","the titan awaits yes. if things haven’t gone to hell you’ll best him. but where’s the heroism in beating up a lonely dog?","fenrir? oh man. you mean like the dog? yeah. god that dog is big. that dog's at least the size of a two-story house-- i could LIVE in that dog. you know. if i wanted.","fen...rir? sounds funny. is it a god? i think i'd know if it was a god.","oh. fenrir? there's plenty of cloth to cut there. the large abominal wolf who severed the hand of the god of order. chained underground for the safety of everyone. son of... the name escapes me... what was it? do you remember? eeeh. you probably don't.","feeeenrir. fenrir fenrir... what IS a fenrir? not literally. but more like... what ISN'T fenrir? anything can be fenrir if you squint."];
        quips.addAll(<String>["oh yeah. i'm assuming that guy's your business. i didn't tamper with him. honest. okay MAYBE a little but you don't get to pat a lot of dogs in this cycle.","zzz... dogs... woof woof...","the dog? yeah that's the warden. he keeps you in here. with us. that's just what being dead is like. you're not supposed to go back.","do you think he could eat a sun? no. i think i'm thinking of another thing. but i'm SURE that he could probably eat a sun if he really wanted to. but why would he?","of course i know the iron dog! a tyrant with an iron maw! soon enough the people will RISE UP and end his reign forever."]);
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Do you know about Fenrir?",tr,level);

    }

    static String treeQuip(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["a tree you say? yeah... you could say that. they don't taste nice at all though so i don't know why you'd ask.","oh. not at all. you're better off not knowing what there actually IS here.","answer me this: is thither grass? is thither dirt? the answer is the question's irrelevant. trees or no trees we'll surely findeth our lodging in valhalla! ","uh... yeah? there’s one right over there. i don’t know what you’re on about. is this like a monk riddle?","not at all and YOU know it. look around. why would lizard people like you want trees? they’re all probably underground where us good folk can’t reach ‘em.","didn't we talk about this? i'm sure there aren't that many trees... i think there are a couple and the rest are lies. like... there are trees and there are fake trees. that's my theory anyway.","yeah that's a good place to start. what happened to LEAVES? are leaves cancelled? do we not get them anymore? are we stuck in eternal winter forever? what the fuck do you even eat??","i... the green hoodie person told me a bit about that. we got into a whole thing about trees... the answer just seems to be that trees aren't real? not PARTICULARLY. if that makes sense.","what’s around here can hardly be called a tree. something more visceral fits better. a sickness. a disease.","oh there's plenty. there's at least as many as one. maybe even two... but mostly one.","i don't think so. i've looked around but... wait. what's a lomat?","oh definitely not. the lords have punished us for our hubris so we don't get those anymore. it was probably because of the christmas tree worshipping. that's MY theory anyway.,technically. if you think about it anything could be a lot of little trees. potatoes could be little trees. trees have a lot of little trees. food for thought."];
        quips.addAll(<String>["oh? well not REAL trees. game trees. which look like real trees. but they're different.","hrm... trees... i miss trees.","i mean. do they have to be living trees? because if so no. haven't seen 'em.","trees are gone and anything that looks like a tree is someone cosplaying one. that is all.","of course not my friend! trees are a lie of the bourgeoisie. that's why we ate them all."]);
        TalkyResponse tr = new TalkyResponse(yn,getSubQuestions(yn,rand),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("Are there trees on LOMAT?",tr,level);
    }

    static String birdQuips(NonGullLOMATNPC yn, TalkyLevel level, Random rand) {
        List<String> quips = <String>["those birds really know how to cause a ruckus huh? you turn for one second and they're already squawking again. it's almost impressive how dedicated they are to noise-making.","the wind-witherer watches over all of us. whether you want it or not. these other birds are just a distraction.","birds? as much as i needeth! thither seemeth to beest an overabundance of seagulls... i wast expecting crows. but who am i to question the machinations of the gods? ","i love birds. these ones are some freaky birds though... they won’t eat no matter what i give them. keep saying they’re ghosts but i’m sure ghosts need to eat too.","yeah sure. look at these birds. they look SICK. are you trying to erradicate them too? if you make a move i can and will brandish my weapon.","birds... ohhh right. i was talking about them before. birds come in lots of colors... the ones around seem to do that by wearing blankets though. do you think it's because seagulls don't come in a lot of colors so this is how they compensate?","why can't. why can't birds fly anymore. why do they wear blankets? why is there a bird society? is this the alpha animal? i thought octopi would be the ones to take over the earth.","oh i've been thinking about this one. the birds right? do you think they're zombies? like a zombievirus of some kind took them over? everything's dead but also nothing's dead. that makes sense to me.","there’s nothing to know about birds. i’ve only seen ghosts around here. i have the feeling you’re also gonna be seeing plenty of those. ","well what do YOU know about birds? do you know what a bird is? you don't look like you know what a bird is. not TRULY. open your miiiiiiind.","well i know the birds around here could be looking better. have you SEEN them? scrawny like sticks. do you think they're sick? that probably explains the blankets.","birds... what? did something happen to them?... is there anything left?","i know plenty about birds. did you know birds tended to be seen as messengers of gods? sometimes they were symbols themselves but mostly they were scribes or record-keepers. i know you probably don't know a lot about this stuff. but that's what learning's for right?"];
        quips.addAll(<String>["birds? oh those don't REALLY exist. these are mostly impostors that look like birds. but they're nice enough. i'm sure you can attest to that.","zzz... bird... zombies... zzz...","oh those birds? they live here. they're ghosts too. i have no idea if they like... if they were humanoids who turned into THAT. is that going to happen to us? are we going to turn into birds?","oh birds are definitely not a thing. if you can see them they're faithghouls. sorry to drop the bomb on you like that.","ah yes! birds! i saw many of them back in the homeland. there seem to be just as many here."]);
        TalkyResponse tr = new TalkyResponse(yn,new List<TalkyItem>(),rand.pickFrom(quips), 3,null);
        new TalkyQuestion("What do you know about birds?",tr,level);
    }



}