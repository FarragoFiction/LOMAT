import 'dart:async';
import 'dart:html';

abstract class PassPhraseHandler {

    //if you haven't already heard this tape, add it.
    static void storeTape(String tapeName) {
        String key = "AUDIOLOGSCASETTELIBRARY";
        if(window.localStorage == null) {
            print("saving isn't possible....you don't have local storage");
            return;
        }
        try {
            if (window.localStorage.containsKey(key)) {
                final String existing = window.localStorage[key];
                final List<String> parts = existing.split(",");
                if (!parts.contains(tapeName)) {
                    window.localStorage[key] = "$existing,$tapeName";
                    popup(querySelector("#output"), null, "Passphrase '$tapeName' Unlocked! (todo list page)",0);
                }
            } else {
                window.localStorage[key] = tapeName;
            }
        }on Exception {
            print("Saving isn't possible....you don't have local storage");
        }
    }

    static Future<void> popup(Element container, Element currentPopup, String text, int tick) async {
        int maxTicks = 3;

        if(currentPopup != null && tick == 0) {
            currentPopup.remove();
            currentPopup = null;
        }

        if(currentPopup == null) {
            currentPopup = new DivElement()
                ..style.position = ("absolute")
                ..style.boxShadow = ("0px 3px 13px #000000")
                ..style.textShadow = "3px 3px black"
                ..style.fontSize = ("34px")
                ..style.display = ("inline-block")
                ..style.borderRadius = ("13px")
                ..style.zIndex = "1000"
                ..style.padding = "15px"
                ..style.color = "white"
                ..style.top = "25%"
                ..style.left = "25%"

                ..text = text;
            container.append(currentPopup);
        }
        if(tick == 1) {
            currentPopup.animate([{"opacity": 100},{"opacity": 0}], 9000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 4000), () =>
                popup(container, currentPopup,text, tick+1));
        }else {
           currentPopup.remove();
        }

    }
}