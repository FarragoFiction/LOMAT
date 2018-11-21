import 'Layers/StaticLayer.dart';

class TownGenome {
    //its a hash so i can do genetic combination of towns because what can i say i love genetic algorithms
    //TODO if it turns out all the values are strings just make 'em strings
    Map<String, dynamic> genes;
    static String imagesLocationBase = "images/BGs/Towns/";
    static String backgroundBase = "${imagesLocationBase}/backgrounds/";
    static String groundBase = "${imagesLocationBase}/grounds/";
    static String midgroundBase = "${imagesLocationBase}/midgrounds/";
    static String foregroundBase = "${imagesLocationBase}/foregrounds/";
    static int maxBGs = 3;
    static int maxGs =2;
    static int maxMGs = 2;
    static int maxFGs = 2;
    static String BGIMAGEKEY = "backgroundImgLoc";
    static String GROUNDKEY = "groundImgLoc";
    static String MIDGROUNDKEY = "midgroundImgLoc";
    static String FOREGROUNDKEY = "foregroundImgLoc";


    //lets you take in a list of genes for premade towns
    TownGenome(Map<String, dynamic> this.genes) {
        if(genes == null) init();
    }

    void init() {
        genes = new Map<String, dynamic>();
        genes[BGIMAGEKEY] = randomBackground();
        genes[GROUNDKEY] = randomGround();
        genes[MIDGROUNDKEY] = randomMidground();
        genes[FOREGROUNDKEY] = randomForeground();
        //TODO should there be any mist??? animated gif??? ask artists
    }

    //to draw: village, farm, train station, carnival, mine, port, logging station (with no trees), stonehenge???
    //later towns have sail decorations cuz they alchemized the hive
    static String randomBackground() {
        //can be zero
        int fileNumber = 1;
        return "$backgroundBase$fileNumber.png";
    }

    static String randomGround() {
        int fileNumber = 1;
        return "$backgroundBase$fileNumber.png";
    }

    static String randomMidground() {
        int fileNumber = 1;
        return "$backgroundBase$fileNumber.png";
    }

    static String randomForeground() {
        //can be zero
        int fileNumber = 1;
        return "$backgroundBase$fileNumber.png";
    }
}
