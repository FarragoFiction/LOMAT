import 'dart:html';

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