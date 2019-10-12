import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:CommonLib/Utility.dart';
import 'package:TextEngine/TextEngine.dart';
import 'package:recase/recase.dart';
import '../Locations/Road.dart';
import 'LOMATNPC.dart';

class Disease {

    String name;
    String description;
    int power;
    int remainingDuration;
    Disease(String this.name, String this.description,int this.power, int this.remainingDuration);

    //taking in a seed lets me play around with things like "this town always generates these diseases"
    //instead of it being whatever the current seed is wherever its based on the source town name converted to an int maybe
    //(where you got the disease from)
    static Future<Disease> generateProcedural(int seed)  async{
        Random rand = new Random(seed);
        //TODO hook up the text engine here okay (yes that means we need to update it);
        TextEngine textEngine = new TextEngine(seed);
        await textEngine.loadList("diseases");
        String name  = "${textEngine.phrase("Diseases")}";
        String desc  = "${textEngine.phrase("Descriptions")}";
        ReCase rc = new ReCase(name);
        name = rc.titleCase;

        return Future.delayed( Duration(seconds: 1), () =>  new Disease(name, desc,rand.nextInt(10+3),rand.nextInt(10)+3));
    }


    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = new Map<dynamic, dynamic>();
        ret["name"] = name;
        ret ["power"] = power;
        ret["description"]=description;
        ret["remainingDuration"] = remainingDuration;
        return ret;
    }

    static Disease loadFromJSON(JsonHandler json) {
        Disease ret = new Disease(json.getValue("name"),json.getValue("description"),json.getValue("power"),json.getValue("remainingDuration"));
        return ret;
    }

    //this should be called for each npc while traveling and traveling only
    void tick(LOMATNPC npc, Road road, double powerModifier, double healingModifier) {
        npc.hp = npc.hp - (power * powerModifier.floor()); //setting auto handles updating the ui
        remainingDuration += (-1 * healingModifier.floor());
        if(remainingDuration <= 0) {
            npc.removeDisease(this);
        }

        if(npc.hp <= 0) {
            //died of dyssentary
            npc.die(name, road);
        }
    }

    //useful for getting my seed
    static int convertWordToNumber(String sentence) {
        //print("converting sentence ${sentence}");
        int ret = 0;
        for(int s in sentence.codeUnits) {
            //print ("code unit ${new String.fromCharCode(s)}");
            ret += s;
        }
        return ret;
    }
}