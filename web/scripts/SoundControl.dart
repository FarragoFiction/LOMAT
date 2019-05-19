import 'dart:async';
import 'dart:html';

import 'package:CommonLib/src/utility/predicates.dart';

class SoundControl { //to major tom

    static SoundControl _instance;
    //need to be able to unhook things on command
    List<StreamSubscription> subscribers = <StreamSubscription>[];

    static SoundControl get instance {
        if(_instance == null) {
            _instance = new SoundControl();
        }
        return _instance;
    }

    bool get  musicPlaying {
        return !bgMusic.paused;
    }


    AudioElement soundEffects = new AudioElement();
    AudioElement bgMusic = new AudioElement()..volume = 0.1;

    //manicInsomniac
    void playMusic(String locationWithoutExtension) {
        bgMusic.loop  = true;
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.ogg";
        bgMusic.play();
    }

    void cancelAllSubscriptions() {
        subscribers.forEach((StreamSubscription ss) {
            ss.cancel();
        });
    }

    //calback should be whatever handles setting up the next part of the song.
    //intial problems are the pause between songs, is it loading?
    void playMusicList(String locationWithoutExtension, Action callback) {
        bgMusic.loop  = false;
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.ogg";
        bgMusic.play();
        //WARNING TO FUTURE JR, IF I EVER WANT TO SUDDENLY CHANGE TEH MUSIC, THIS CALLBACK PROBABLY WILL STILL BE CALLED. WORRY ABOUT THIS.
        cancelAllSubscriptions(); //i'm the ONLY one you hear?
        StreamSubscription ss;
        ss = bgMusic.onEnded.listen((Event event) {
            //print("$locationWithoutExtension ended so doing a callback???");
            //if i don't cancel my listener after one use, then each new fragment of music will add listeners to it and the call back will
            //be called exponentially. this is BAD. and also clogs up hte console.
            ss.cancel();
            callback();
        });
        subscribers.add(ss);
    }

    void stopMusic() {
        print("stopping music");
        bgMusic.pause();
    }

    //https://freesound.org
    void playSoundEffect(String locationWithoutExtension) {
        if(soundEffects.canPlayType("audio/mpeg").isNotEmpty) soundEffects.src = "SoundFX/${locationWithoutExtension}.mp3";
        if(soundEffects.canPlayType("audio/ogg").isNotEmpty) soundEffects.src = "SoundFX/${locationWithoutExtension}.ogg";
        soundEffects.play();

    }
}