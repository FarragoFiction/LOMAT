import 'Events/Effects/DelayEffect.dart';
import 'Events/RoadEvent.dart';
import 'Layers/StaticLayer.dart';
import 'package:CommonLib/Random.dart';

class TownGenome {
    //its a hash so i can do genetic combination of towns because what can i say i love genetic algorithms
    //the simplest genes are just strings
    Map<String, String> simpleGenes;
    Random rand;
    //higher means more stable
    double genomeStability = .5;

    static String imagesLocationBase = "images/BGs/Towns/";
    static String backgroundBase = "${imagesLocationBase}/backgrounds/";
    static String groundBase = "${imagesLocationBase}/grounds/";
    static String midgroundBase = "${imagesLocationBase}/midgrounds/";
    static String foregroundBase = "${imagesLocationBase}/foregrounds/";
    static int maxBGs = 4;
    static int maxGs =2;
    static int maxMGs = 2;
    static int maxFGs = 3;
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
     List<RoadEvent> events = new List<RoadEvent>();

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
    TownGenome(Random this.rand,Map<String, String> this.simpleGenes) {
        if(rand == null) rand = new Random();
        if(simpleGenes == null) init();
    }

    void init() {
        simpleGenes = new Map<String, dynamic>();
        simpleGenes[BGIMAGEKEY] = randomBackground(rand);
        simpleGenes[GROUNDKEY] = randomGround(rand);
        simpleGenes[MIDGROUNDKEY] = randomMidground(rand);
        simpleGenes[FOREGROUNDKEY] = randomForeground(rand);
        simpleGenes[STARTTEXT] = randomStartText(rand);
        simpleGenes[MIDDLETEXT] = randomMiddleText(rand);
        simpleGenes[ENDTEXT] = randomEndText(rand);
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
    }

    TownGenome breed(TownGenome coparent, Random rand) {
         //child will have random values so to get mutations just don't over ride
         TownGenome child = new TownGenome(rand,null);
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
        print("the childs events are ${child.events.length} after breeding");
        return child;
    }

    //for each event in list pick either mine, coparents or make a MUTATION.
    List<RoadEvent> breedEvents(List<RoadEvent> coParentEvents, List<RoadEvent> childMutations) {
         print("attempting to breed events, my events are ${events.length} and your events are ${coParentEvents.length}");
         //it does mean that the number of events will be the "first" parents amount.
        List<RoadEvent> ret = new List<RoadEvent>();
        for(int i = 0; i<events.length; i++) {
            if(rand.nextDouble() < genomeStability) {
                if (coParentEvents != null && coParentEvents.length < i && rand.nextBool()) {
                    ret.add(coParentEvents[i]);
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

    //for mutations except i just realized i wouldn't need it i just don't need to over ride the child
    //oh well.
    static keyToRandomValue(String key, Random rand) {
        if(key == BGIMAGEKEY) return randomBackground(rand);
        if(key == GROUNDKEY) return randomGround(rand);
        if(key == MIDGROUNDKEY) return randomMidground(rand);
        if(key == FOREGROUNDKEY) return randomForeground(rand);
        if(key == STARTTEXT) return randomStartText(rand);
        if(key == MIDDLETEXT) return randomMiddleText(rand);
        if(key == ENDTEXT) return randomEndText(rand);
        if(key == STARTSONG1) return randomSong(rand);
        if(key == STARTSONG2) return randomSong(rand);
        if(key == MIDDLESONG1) return randomSong(rand);
        if(key == MIDDLESONG2) return randomSong(rand);
        if(key == ENDSONG1) return randomSong(rand);
        if(key == ENDSONG2) return randomSong(rand);
        return "??? UNKNOWN KEY ???";
    }

    //to draw: village, farm, train station, carnival, mine, port, logging station (with no trees), stonehenge???
    //premade towns: null town, consequenceville, glacier town
    //later towns have sail decorations cuz they alchemized the hive
    static String randomBackground(Random rand) {
        int fileNumber = rand.nextIntRange(1,maxBGs);
        print('bg number is $fileNumber');
        return "$backgroundBase$fileNumber.png";
    }

    //TODO have this integrate with TEXTENGINE
    static String randomStartText(Random rand) {
        List<String> bullshitNamesPLZReplaceWithTextEngine = <String>["You arrive in INSERTNAMEHERE.","Exhausted, you arrive in INSERTNAMEHERE.","You stroll into INSERTNAMEHERE."];
        return rand.pickFrom(bullshitNamesPLZReplaceWithTextEngine) ;
    }

    static String randomMiddleText(Random rand) {
        List<String> bullshitNamesPLZReplaceWithTextEngine = <String>["It's a procedural placeholder and is kinda bullshit.","It's really kind of lame.","There's nothing to do here."];
        return rand.pickFrom(bullshitNamesPLZReplaceWithTextEngine) ;
    }

    static String randomSong(Random rand) {
        String songBaseName = "Trails_Slice";
        String ret = "$songBaseName${rand.nextIntRange(1,7)}";
        //confirm the code is right
        //print("song chosen was $ret");
        return ret;
    }

    static String randomEndText(Random rand) {
        List<String> bullshitNamesPLZReplaceWithTextEngine = <String>["You don't know why you are here.","Its so boring.","You are already ready to leave."];
        return rand.pickFrom(bullshitNamesPLZReplaceWithTextEngine) ;
    }

    static String randomGround(Random rand) {
        int fileNumber =  rand.nextIntRange(1,maxGs);
        return "$groundBase$fileNumber.png";
    }

    static String randomMidground(Random rand) {
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
        List<DelayEffect> effects = [new DelayEffect(1000),new DelayEffect(5000), new DelayEffect(10000),new DelayEffect(-1000),new DelayEffect(-5000),new DelayEffect(-10000)];
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
