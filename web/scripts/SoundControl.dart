import 'dart:html';

class SoundControl { //to major tom

    static SoundControl _instance;

    static SoundControl get instance {
        if(_instance == null) {
            _instance = new SoundControl();
        }
        return _instance;
    }




    AudioElement soundEffects = new AudioElement();
    AudioElement bgMusic = new AudioElement();

    //manicInsomniac
    void playMusic(String locationWithoutExtension) {
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "SoundFX/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "SoundFX/${locationWithoutExtension}.ogg";
        bgMusic.play();

    }

    //https://freesound.org
    void playSoundEffect(String locationWithoutExtension) {
        if(soundEffects.canPlayType("audio/mpeg").isNotEmpty) soundEffects.src = "SoundFX/${locationWithoutExtension}.mp3";
        if(soundEffects.canPlayType("audio/ogg").isNotEmpty) soundEffects.src = "SoundFX/${locationWithoutExtension}.ogg";
        soundEffects.play();

    }
}