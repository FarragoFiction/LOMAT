/*
    because this is a void land, most of what you do doesn't matter and gets reset each play through.
    but some things don't. mostly for fenrir's memory.
 */
import 'NPCs/Tombstone.dart';

class GameStats {
    int helplessBugsKilled = 0;
    List<Tombstone> theDead = new List<Tombstone>();
    int voidVisits = 0;
    bool lomatBeaten = false;
    static GameStats _instance;
    static GameStats get instance {
        if(_instance == null) {
            _instance = new GameStats();
        }
        return _instance;
    }

}