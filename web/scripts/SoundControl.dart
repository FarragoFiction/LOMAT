import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';
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
    AudioElement passPhraseAudio = new AudioElement();
    AudioElement bgMusic = new AudioElement()..volume = 0.1;
    AudioElement wind = new AudioElement()..volume = 0.1;
    List<String>ambient =<String>["wind0","wind1","wind2","wind3","wind4"];

    //manicInsomniac
    void playMusic(String locationWithoutExtension) {
        bgMusic.loop  = true;
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.ogg";
        bgMusic.play();
    }

    void playPodcast(String locationWithoutExtension) {
        passPhraseAudio.loop  = false;
        if(passPhraseAudio.canPlayType("audio/mpeg").isNotEmpty) passPhraseAudio.src = "http://farragnarok.com/PodCasts/${locationWithoutExtension}.mp3";
        if(passPhraseAudio.canPlayType("audio/ogg").isNotEmpty) passPhraseAudio.src = "http://farragnarok.com/PodCasts/${locationWithoutExtension}.ogg";
        passPhraseAudio.play();
    }

    void cancelAllSubscriptions() {
        subscribers.forEach((StreamSubscription ss) {
            ss.cancel();
        });
    }

    void playTheWind() {
        wind.loop  = false;
        String windChoice = new Random().pickFrom(ambient);
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "Music/${windChoice}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "Music/${windChoice}.ogg";
        try {
            bgMusic.play();
            //WARNING TO FUTURE JR, IF I EVER WANT TO SUDDENLY CHANGE TEH MUSIC, THIS CALLBACK PROBABLY WILL STILL BE CALLED. WORRY ABOUT THIS.
            cancelAllSubscriptions(); //i'm the ONLY one you hear?
            StreamSubscription ss;
            ss = bgMusic.onEnded.listen((Event event) {
                //print("$locationWithoutExtension ended so doing a callback???");
                //if i don't cancel my listener after one use, then each new fragment of music will add listeners to it and the call back will
                //be called exponentially. this is BAD. and also clogs up hte console.
                ss.cancel();
                playTheWind();
            });
            subscribers.add(ss);
        }catch(e) {
            window.console.error("error trying to play $windChoice, $e");
            playTheWind();
        }
    }

    void scaleUpVolume([bool firstTime=true]) {
        if(firstTime == true) {
            bgMusic.volume = 0;
        }else {
            bgMusic.volume = bgMusic.volume+0.001;
        }
        if(bgMusic.volume < 1.0) {
            new Timer(
                new Duration(milliseconds: 100), () => scaleUpVolume(false));
        }
    }

    //calback should be whatever handles setting up the next part of the song.
    //intial problems are the pause between songs, is it loading?
    void playMusicList(String locationWithoutExtension, Action callback) {
        print("playing $locationWithoutExtension");
        bgMusic.loop  = false;
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.ogg";
        try {
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
        }catch(e) {
            window.console.error("error trying to play $locationWithoutExtension, $e");
            callback();
        }
    }

    void stopMusic() {
        bgMusic.pause();
    }

    //https://freesound.org
    void playSoundEffect(String locationWithoutExtension) {
        if(soundEffects.canPlayType("audio/mpeg").isNotEmpty) soundEffects.src = "SoundFX/${locationWithoutExtension}.mp3";
        if(soundEffects.canPlayType("audio/ogg").isNotEmpty) soundEffects.src = "SoundFX/${locationWithoutExtension}.ogg";
        soundEffects.play();

    }
}