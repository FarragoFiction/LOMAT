import 'package:TextEngine/TextEngine.dart';

import 'Events/Effects/DelayEffect.dart';
import 'Events/Effects/DiseaseEffect.dart';
import 'Events/Effects/Effect.dart';
import 'Events/Effects/InstaKillEffect.dart';
import 'Events/Effects/MoneyEffect.dart';
import 'Events/RoadEvent.dart';
import 'Layers/StaticLayer.dart';
import 'package:CommonLib/Random.dart';
import 'package:CommonLib/src/collection/weighted_lists.dart';

import 'Town.dart';

class TownGenome {
    //its a hash so i can do genetic combination of towns because what can i say i love genetic algorithms
    //the simplest genes are just strings
    Map<String, String> simpleGenes;
    String townName; //used for debugging purposes
    Random rand;
    //higher means more stable
    double genomeStability = .5;
    //TODO censor tree related words

    static String imagesLocationBase = "images/BGs/Towns/";
    static String backgroundBase = "${imagesLocationBase}/backgrounds/";
    static String groundBase = "${imagesLocationBase}/grounds/";
    static String midgroundBase = "${imagesLocationBase}/midgrounds/";
    static String foregroundBase = "${imagesLocationBase}/foregrounds/";
    static int maxBGs = 5;
    static int maxGs =4;
    static int maxMGs = 6;
    static int maxFGs = 4;
    //TODO what kinds of enemies can be hunted should also be a gene
    //TODO breed two towns together because i have problems and that problem is loving genetic algorithms
    //TODO add list of npc genomes
    //TODO add list of ENEMY genmoes (base and modifier)
    //ALSO TODO integrate with kr's new beartifly enemy
    //ALSO TODO make preset towns who combine to make towns
    //ALSO TODO have some prest towns not contribute genes and instead go in raw with a trigger (like kill 85 catapillars)
    //TODO genes where its things like NOUN or ADJATIVE to associate with text engine and flavor text.
    static String BGIMAGEKEY = "backgroundImgLoc";
    static String GROUNDKEY = "groundImgLoc";
    static String MIDGROUNDKEY = "midgroundImgLoc";
    static String FOREGROUNDKEY = "foregroundImgLoc";
    //JR NOTE: the text stuff should function like a template for PL's text engine, lets there be more randomness than the surface implies.
    static String STARTTEXT = "starttext";
    static String MIDDLETEXT = "middletext";
    static String ENDTEXT = "foregroundtext";
    //JR NOTE from 12/10/18: i can't remember why there is start middle end x2 combob??? i know i wanted 60 seconds total... why did
    //i name them that way tho???
    static String STARTSONG1 = "startSong1";
    static String MIDDLESONG1 = "middlesong1";
    static String ENDSONG1 = "endsong1";
    static String STARTSONG2 = "startsong2";
    static String MIDDLESONG2 = "middlesong2";
    static String ENDSONG2 = "endsong2";

    String get startText => simpleGenes[STARTTEXT];
    String get middleText => simpleGenes[MIDDLETEXT];
    String get endText => simpleGenes[ENDTEXT];
    List<String> get playList => <String>[simpleGenes[STARTSONG1],simpleGenes[MIDDLESONG1],simpleGenes[ENDSONG1],simpleGenes[STARTSONG2],simpleGenes[MIDDLESONG2],simpleGenes[ENDSONG2]];
    int get playListLength => playList.length;
    String get background => simpleGenes[BGIMAGEKEY];
    String get ground => simpleGenes[GROUNDKEY];
    String get midGround => simpleGenes[MIDGROUNDKEY];
    String get foreground => simpleGenes[FOREGROUNDKEY];

     set background(String content) => simpleGenes[BGIMAGEKEY]=content;
     set ground(String content) => simpleGenes[GROUNDKEY]=content;
     set midGround(String content) => simpleGenes[MIDGROUNDKEY]=content;
     set foreground(String content) => simpleGenes[FOREGROUNDKEY]=content;
     set startText(String content) => simpleGenes[STARTTEXT]=content;
     set middleText(String content) => simpleGenes[MIDDLETEXT]=content;
     set endText(String content) => simpleGenes[ENDTEXT]=content;

     set startSong1(String content) => simpleGenes[STARTSONG1]=content;
     set middleSong1(String content) => simpleGenes[MIDDLESONG1]=content;
     set endSong1(String content) => simpleGenes[ENDSONG1]=content;
     set startSong2(String content) => simpleGenes[STARTSONG2]=content;
     set middleSong2(String content) => simpleGenes[MIDDLESONG2]=content;
     set endSong2(String content) => simpleGenes[ENDSONG2]=content;

     //not part of normal genes but still a thing inherited
    //wow why wasn't this a weighted list
     WeightedList<RoadEvent> events = new WeightedList<RoadEvent>();

     set playList(List<String> songs) {
         if(songs.length != playListLength) {
            throw "ERROR: NOT ENOUGH SONGS IN PLAYLIST, WAS EXPECTING ${playListLength}";
         }
         startSong1 = songs[0];
         middleSong1 = songs[1];
         endSong1 = songs[2];
         startSong2 = songs[3];
         middleSong2 = songs[4];
         endSong2 = songs[5];
     }

    //lets you take in a list of genes for premade towns
    //TODO let towns breed plz
    TownGenome(String this.townName, Random this.rand,Map<String, String> this.simpleGenes) {
        if(rand == null) rand = new Random();
        if(simpleGenes == null) init("constructor");
    }

    Future<Null> init(String reason) async{
        simpleGenes = new Map<String, String>();
        TextEngine textEngine = new TextEngine(rand.nextInt());
        //TODO: have things like industry or whatever for towns to consistently reference
        //that way i can have description words around said industry
        await textEngine.loadList("townDescriptions");
        simpleGenes[BGIMAGEKEY] = randomBackground(rand);
        simpleGenes[GROUNDKEY] = randomGround(rand);
        simpleGenes[MIDGROUNDKEY] = randomMidground(rand);
        simpleGenes[FOREGROUNDKEY] = randomForeground(rand);
        simpleGenes[STARTTEXT] = await randomStartText(textEngine);
        simpleGenes[MIDDLETEXT] = await randomMiddleText(textEngine);
        simpleGenes[ENDTEXT] = await randomEndText(textEngine);
        simpleGenes[STARTSONG1] = randomSong(rand);
        simpleGenes[STARTSONG2] = randomSong(rand);
        simpleGenes[MIDDLESONG1] = randomSong(rand);
        simpleGenes[MIDDLESONG2] = randomSong(rand);
        simpleGenes[ENDSONG1] = randomSong(rand);
        simpleGenes[ENDSONG2] = randomSong(rand);
        //three events
        events.add(randomEvent(rand));
        events.add(randomEvent(rand));
        events.add(randomEvent(rand));
        //TODO should there be any mist??? animated gif??? ask artists
         print("intro debug end: initing $townName because $reason, after bg was ${simpleGenes[MIDGROUNDKEY]}");

    }

    Future<TownGenome> breed(TownGenome coparent, Random rand) async{
         //child will have random values so to get mutations just don't over ride
         TownGenome child = new TownGenome("unnamed child",rand,null);
         await child.init("bred child init");
         //take each key and pick either parent or coparent or mutate (3% chance)
        for(String key in simpleGenes.keys) {
            if(rand.nextDouble() < genomeStability) {
                if (coparent != null && coparent.simpleGenes.keys.contains(key) && rand.nextBool()) {
                    child.simpleGenes[key] = coparent.simpleGenes[key];
                }else {
                    child.simpleGenes[key] = simpleGenes[key];
                }
            }
        }
        child.events = breedEvents(coparent.events, child.events);
        return child;
    }

    //for each event in list pick either mine, coparents or make a MUTATION.
    WeightedList<RoadEvent> breedEvents(WeightedList<RoadEvent> coParentEvents, WeightedList<RoadEvent> childMutations) {
         //it does mean that the number of events will be the "first" parents amount.
         WeightedList<RoadEvent> ret = new WeightedList<RoadEvent>();
        for(int i = 0; i<events.length; i++) {
            if(rand.nextDouble() < genomeStability) {
                if (coParentEvents != null &&  i <coParentEvents.length && rand.nextBool()) {
                    ret.add(coParentEvents[i]); //TODO ask pl how to get the weight for this item out
                }else {
                   ret.add(events[i]);
                }
            }else {
                if(childMutations.length>i) {
                    ret.add(childMutations[i]);
                }
            }
        }
        return ret;
    }


    //to draw: village, farm, train station, carnival, mine, port, logging station (with no trees), stonehenge???
    //premade towns: null town, consequenceville, glacier town
    //later towns have sail decorations cuz they alchemized the hive
    static String randomBackground(Random rand) {
        int fileNumber = rand.nextIntRange(1,maxBGs);
        return "$backgroundBase$fileNumber.png";
    }

    //TODO have this integrate with TEXTENGINE
    static Future<String> randomStartText(TextEngine textEngine)  async{
        return textEngine.phrase("TownStart");
    }

    static Future<String> randomMiddleText(TextEngine textEngine) async {
        return textEngine.phrase("TownMiddle");
    }

    static String randomSong(Random rand) {
        String songBaseName = "Trails_Slice";
        String ret = "$songBaseName${rand.nextIntRange(1,7)}";
        //confirm the code is right
        //print("song chosen was $ret");
        return ret;
    }

    static Future<String> randomEndText(TextEngine textEngine) async {
        return textEngine.phrase("TownEnd");
    }

    static String randomGround(Random rand) {
        int fileNumber =  rand.nextIntRange(1,maxGs);
        return "$groundBase$fileNumber.png";
    }

    static String randomMidground(Random rand) {
         print("trying to get random midground");
        int fileNumber =  rand.nextIntRange(1,maxMGs);
        return "$midgroundBase$fileNumber.png";
    }

    static String randomForeground(Random rand) {
        //can be zero
        int fileNumber =  rand.nextInt(maxFGs);;
        return "$foregroundBase$fileNumber.png";
    }

    //most events will be carefully crafted. but mutations....mutations are fair game for my aesthetic
    static RoadEvent randomEvent(Random rand) {
        WeightedList<Effect> effects = new WeightedList<Effect>();
        //TODO while these are weighted, the bred towns aren't, so need to ask pl about how to get an items weight
        //effects.add(new DelayEffect(1), 0.5);
        //effects.add(new DelayEffect(2), 0.5);
        //effects.add(new DelayEffect(3), 0.5);
        //effects.add(new DelayEffect(-1), 1);
        //effects.add(new DelayEffect(-2), 1);
        //effects.add(new DelayEffect(-3), 1);
        effects.add( new InstaKillEffect("act of RNGsus"), 0.001);
        effects.add( new InstaKillEffect("choked on Stolen Dorito"), 0.03);
        effects.add( new DiseaseEffect(), 3);
        effects.add(new MoneyEffect(13), 4440.95);


            //TODO make them better at being random. use text engine and shit. these are for mutations.
        List<String> shittyNouns = <String> ["Vikings","Bears","Pirates","Ninjas","Bandits","Ghosts","Exorcists"];
        List<String> shittyAdj = <String> ["Screaming","Wailing","Pious","Angry","Hungry","Greedy","Shitty","Berserk"];
        List<String> shittyFlavor = <String>["attack you out of nowhere.","block the path for hours.","ask you never ending questions.","ask you to sign a petition.","tell you knock knock jokes for hours.","steal your wheels.","insult your favorite kind of bird.","mock your horns."];
        String noun = rand.pickFrom(shittyNouns);
        String adj = rand.pickFrom(shittyAdj);
        String flavor = rand.pickFrom(shittyFlavor);
        return (new RoadEvent("$adj $noun","$adj $noun $flavor", rand.pickFrom(effects), 0.5));

    }

}
