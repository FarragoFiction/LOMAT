import 'package:CommonLib/Compression.dart';
import 'package:CommonLib/Random.dart';

import '../AnimationObject.dart';
import '../CipherEngine.dart';
import '../Locations/HuntingGrounds.dart';
import '../Locations/Town.dart';
import '../NPCs/Disease.dart';
import '../NPCs/LOMATNPC.dart';
import '../NPCs/NonGullLOMATNPC.dart';
import '../NPCs/Tombstone.dart';
import 'dart:html';

import '../PassPhrases/PassPhraseObject.dart';
import '../Sections/TalkySection.dart';

DivElement div = querySelector('#output');
void main()  async{
    /*
    for(int i = 0; i<3; i++) {
        await testDisease();
    }
    for(int i = 0; i<10; i++) {
        await testTown();
    }*/
    //testCiphers();
    loadGull();
    //loadGull();
    testPhrases();

    //testAnimation();
    //testTombstone();
}

void testPhrases() {
    PassPhraseObject.displayArt(PassPhraseObject.load(), div);
}

void loadGull() {
    //String dataString = "Stimpy Tigger:___ N4IgdghgtgpiBcIDKAXAllADgTwAQBU0BzImAJxABoQAbGCANzTCIFkYBnDiUhEAgPIARAbigQA1jFwcArmWn0AxgAtcAOQAKAYVwqIHXBFxLZHFAHsouOo2ZExnbqQB0VEEohmYAgGZD6FBU+CAAjDgsaWRQYGjwwCyD7dxVMBAAOAFZqFGxMOEQAcVkaGncAEzQOemqOBABtAF0ciBoJbAAZGAZYhFAUVvaASRioOvh60EqOTBoIbHwYAA8UPgB1fRQTCDBcbAtZXBjSxyNQg62kwyJoGAB+dxQyYlIycaacvIKQfEHsAEVZJx0BYwO4FDNQdU+iBprN5osVnx8AAJACiBCG+AAgupcEMkLhsbgAEpo7EdXAAKTRJIA0i5cEh-mtsWs6QBCLlcx7PEjkd7NEADNqdbq9eD9P4jGBjBqNAC+n3yyL+JM4mChcGoBgiSjQEBi5TRUESaFBCAAjAAGa0KpVTKrwhbLVaIDaG7a7faHY40U5hC5HFRVI4WADuYAeOT5r3eoDmoQlIGxptkYBQADF0+U6tQMJqyAMM2sLGRyggwCUaPmsGXiyghhmrbaFULcirEL9RYDgeawdQIZqwNDJbCnXMXUjEMzWezuVyCCiCYI1niV0h1AI1gBNShE9RCXAo7GEpACVgYlEAVUKGPwZLRhKG6-wbhjLwF8paoq6PTKY4isMoyCkqwpfKqorqpCI7aiAuoWPqhowMapogmC8A2naDrjjMk6Im6IBrBAaAoPuNBoFI+4+gA5AouDlPQ5TRsKsZfhMCZhMmqYHBm2ZgLm7gFvWOwoKW5aVtWtaFg2TZupaNptsq3zdu0vbmP24IalqMJwvhrp8LObKcguuA7k+jJogAGti2j4B0O64B0Qx0veJ5vviNGsLgQjkkI76sZ+bzfsKfx-hKUqijKcoTIqymQe00HDtCOpcIhBpGiaZoWvA6TYZQjp4QiBnuioeAQPRPoMRC1TlDYlHSMYRAqBY5gsU8QXxrQXEASmaZ8TmeYgMJRaieJFbwFWpTSSJGZyS2drthBXZ-Op6FaTBo6Fc6BGGSyxkLhynneVu+A+WSSBIGiR7Oa5RK4IUKICEg+D7kMRLecSj3PW+vKdSFQFiv+MKA9FXV6cV05ESRZH1VRewHHR0iMRAzF-fywUcd1Sa9Tx6ZZoNQl1qNJZlhNU01sNxOyc2mGKUtnY-KtQIaRag7abBukTpDhFGfOpnmUglk2XZDlOS5bnYh5QxeT5fkBR1GOCj+7ThQBkXAbKoHxStUEcyl8FpUhmVoZpuXYXF4GM6p2BJTpqV6hlKFZetmGtjhENToRHpbJ43oHEcsT+rAZxBrA7VsZjHxWypzN9mzIBDjpY6e7tiA7gI15EmSS4YpoJICJo6JIEM13HrSohrE9uBrEMHSUoU15DL5udOT9TKZx0hICJmS4rh0uJHvgoiomiQwkrgmYvhSpJPvgL6FLgmgD9oaIK5Hyuhb+4rq1vmsxU0YEdrHeubXBCHG87ps5ZaABM+XbfpUNCBYCOHOGolhrgABWFjMI4Ed-qxR1kzHsLN1rszPlzIqXt1idyPEMDkdwmT7X5tydGcYAZhR3iDaUIEGiPx5nwdUSgyCyFIoApWANlogDJNoEkTd574DRKwEAbYj40JtnbTmDt0rIVQtlDCeV7SWx2BgQ0ZtQCbHULIKASYKDwGyCAc45RsAyLkeQBAAAWagmBWgwBQDEPghRMAcEzgIKAawYAfw6PgHcZASTpAYOkNY4YiAAC8kAkRRBAdIKhrzpAsNoHx6Q0AhLCb4gAzAAWm-lSIgABeBJbCFRAA";
   // DivElement dataDebug = new DivElement()..text = LZString.decompressFromEncodedURIComponent(LOMATNPC.removeLabelFromString(dataString));
   // div.append(dataDebug);
    LOMATNPC npc = NPCFactory.yn(new Random());
    div.appendText("the loaded npc's name is ${npc.name} and i expected it to be yn");
    //dataDebug.appendText("the loaded npc's talky level is ${npc.talkyLevel.talkyItems.length} long.");

    TalkySection ts = new TalkySection(npc, div);

    //NonGullLOMATNPC nonGull = NPCFactory.lilscumbag();
    //div.appendText("the loaded npc's name is ${npc.name} and i expected it to be stimpy tigger");
    //div.append(nonGull.avatar);

}

Future<Null> testDisease() async {
    Element otherTest = new DivElement()..text = "TODO: some disease shit";
    Disease disease = await Disease.generateProcedural(new Random().nextInt());
    otherTest.text = "${disease.name}. ${disease.description}";
    div.append(otherTest);

}

Future<Null> testTown() async {
    Element otherTest = new DivElement()..text = "TODO: some disease shit";
    String name = await Town.generateProceduralName(new Random().nextInt());
    Town town = await Town.generateProceduralTown(new Random());
    otherTest.text = "${name}<Br>or${town.name} with description ${town.introductionText}";
    div.append(otherTest);

}

void testCiphers() {
    Element otherTest = new DivElement()..text = "it is not the Titan, nor the Reaper.";
    div.append(otherTest);
    CipherEngine.applyRandom(otherTest);
}

void testAnimation() {
    print("testing animation");
    List<int> options = <int> [1,2,3,4,5];
    Random rand = new Random();
    for(int i = 0; i<5; i++) {
        GullAnimation gull = new GullAnimation(rand.pickFrom(options),rand.pickFrom(options), GullAnimation.randomPalette);
        gull.frameRateInMS = 20*i+20;
        div.append(gull.element);
    }

}

void testTombstone() {
    Tombstone t = new Tombstone();
    t.drawSelf(div,null);
}