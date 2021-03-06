import 'dart:async';

import '../../Game.dart';
import '../../GuideBot.dart';
import 'MenuHolder.dart';
import 'MenuItem.dart';
import 'dart:html';

class CreditsButton extends MenuItem {
  CreditsButton(MenuHolder holder) : super("???",holder);

  @override
  void onClick() {
      DivElement modal = new DivElement()..classes.add("credits");
      HeadingElement header = new HeadingElement.h2()..text = "Credits";
      modal.append(header);
      List<String> credits = <String>["Coding: jadedResearcher", "Coding: paradoxLands", "Music: manicInsomniac","Art: yearnfulNode", "Art: karmicRetribution", "Art: nebulousHarmony", "Art: insufferableOracle", "Art: Shogun", "Fenrir Animations: Ghoul ","Contest Finalist: crimsonDestroyer ","Contest Finalist: cumulusCanine","Contest Finalist: retroStrategist ","Contest Finalist: Artful_Dodger ","Contest Finalist: DeathlyHealer ","Contest Semifinalist: cactus","Contest Semifinalist: cumulusCanine ","Contest Semifinalist: Coolthulhu","Contest Semifinalist: gull","Contest Semifinalist: ShyTenda ","Contest Semifinalist: gigglyZero ","Contest Semifinalist: MyDamination","Contest Semifinalist: RealMelodyHope "];
      credits.forEach((String credit) => modal.append(new DivElement()..text = credit ));
      DivElement buttonHolder = new DivElement();

      modal.append(buttonHolder);
      Game.instance.currentLocation.container.append(modal);

      modal.onClick.listen((Event e) {
        modal.remove();
      });


  }

  @override
  void init() {
    super.init();
    container.id = "botBotton";
    container.style.boxShadow =  "0px 3px 13px #888888";
  }


}