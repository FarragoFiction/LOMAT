import 'Layers/StaticLayer.dart';
import 'package:CommonLib/Random.dart';

class TownGenome {
    //its a hash so i can do genetic combination of towns because what can i say i love genetic algorithms
    //TODO if it turns out all the values are strings just make 'em strings
    Map<String, dynamic> genes;
    Random rand;




    static String imagesLocationBase = "images/BGs/Towns/";
    static String backgroundBase = "${imagesLocationBase}/backgrounds/";
    static String groundBase = "${imagesLocationBase}/grounds/";
    static String midgroundBase = "${imagesLocationBase}/midgrounds/";
    static String foregroundBase = "${imagesLocationBase}/foregrounds/";
    static int maxBGs = 3;
    static int maxGs =2;
    static int maxMGs = 2;
    static int maxFGs = 2;
    //TODO breed two towns together because i have problems and that problem is loving genetic algorithms
    //TODO add list of npc genomes
    //TODO add list of ENEMY genmoes (base and modifier)
    //ALSO TODO integrate with kr's new beartifly enemy
    //ALSO TODO make preset towns who combine to make towns
    //ALSO TODO have some prest towns not contribute genes and instead go in raw with a trigger (like kill 85 catapillars)
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

    String get startText => genes[STARTTEXT];
    String get middleText => genes[MIDDLETEXT];
    String get endText => genes[ENDTEXT];
    List<String> get playList => <String>[genes[STARTSONG1],genes[MIDDLESONG1],genes[ENDSONG1],genes[STARTSONG2],genes[MIDDLESONG2],genes[ENDSONG2]];
    int get playListLength => playList.length;

    //lets you take in a list of genes for premade towns
    //TODO let towns breed plz
    TownGenome(Random this.rand,Map<String, dynamic> this.genes) {
        if(rand == null) rand = new Random();
        if(genes == null) init();
    }

    void init() {
        genes = new Map<String, dynamic>();
        genes[BGIMAGEKEY] = randomBackground(rand);
        genes[GROUNDKEY] = randomGround(rand);
        genes[MIDGROUNDKEY] = randomMidground(rand);
        genes[FOREGROUNDKEY] = randomForeground(rand);
        genes[STARTTEXT] = randomStartText(rand);
        genes[MIDDLETEXT] = randomMiddleText(rand);
        genes[ENDTEXT] = randomEndText(rand);
        genes[STARTSONG1] = randomSong(rand);
        genes[STARTSONG2] = randomSong(rand);
        genes[MIDDLESONG1] = randomSong(rand);
        genes[MIDDLESONG2] = randomSong(rand);
        genes[ENDSONG1] = randomSong(rand);
        genes[ENDSONG2] = randomSong(rand);


        //TODO should there be any mist??? animated gif??? ask artists
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
        print("song chosen was $ret");
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
}
