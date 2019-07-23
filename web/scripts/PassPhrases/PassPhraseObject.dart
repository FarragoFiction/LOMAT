import 'dart:html';

import 'package:LoaderLib/Loader.dart';

import 'PassPhraseHandler.dart';

class PassPhraseObject {
    String passPhrase;
    ImageElement art;
    String get artLoc => "http://www.farragnarok.com/PodCasts/$passPhrase.png";
    PassPhraseObject(String this.passPhrase);

    Future<ImageElement> loadArt() async{
        try {
            print("trying to load");
            art = await Loader.getResource(artLoc);
            print("$passPhrase had art.");
            return art;
        }on Exception{
            //oh well
            print("$passPhrase had no art.");
            return null;

        }
    }

    static List<PassPhraseObject> load() {
        List<String> phrases = PassPhraseHandler.foundPhrases;
        List<PassPhraseObject> ret = new List<PassPhraseObject>();
        phrases.forEach((String s) => ret.add(new PassPhraseObject(s)) );
        return ret;
    }

    static Future<void> displayArt(List<PassPhraseObject> phrases, Element element) async {
        print("checing ${phrases.length} phrases");
        for(PassPhraseObject phrase in phrases) {
            try {
                ImageElement art = await phrase.loadArt();
                if (art != null) {
                    //TODO fuck this shit up
                    element.append(art);
                }
            }on Exception {
                print("??? Exception");
            }
        }
    }

}