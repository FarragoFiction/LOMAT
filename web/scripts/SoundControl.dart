import 'dart:html';

import 'package:CommonLib/src/utility/predicates.dart';

class SoundControl { //to major tom

    static SoundControl _instance;

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
    AudioElement bgMusic = new AudioElement();

    //manicInsomniac
    void playMusic(String locationWithoutExtension) {
        print("starting music $locationWithoutExtension");
        bgMusic.loop  = true;
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.ogg";
        bgMusic.play();
    }

    //calback should be whatever handles setting up the next part of the song.
    void playMusicList(String locationWithoutExtension, Action callback) {
        print("starting music $locationWithoutExtension");
        bgMusic.loop  = false;
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "Music/${locationWithoutExtension}.ogg";
        bgMusic.play();
        //WARNING TO FUTURE JR, IF I EVER WANT TO SUDDENLY CHANGE TEH MUSIC, THIS CALLBACK PROBABLY WILL STILL BE CALLED. WORRY ABOUT THIS.
        bgMusic.onEnded.listen((Event event) {
            callback();
        });
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