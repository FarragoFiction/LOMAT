import 'dart:html';

import '../Game.dart';
import '../Locations/PhysicalLocation.dart';
import 'Enemy.dart';
import 'package:CommonLib/Random.dart';

//TODO make them move around randomly and flutteringly but fast
class Echidna extends Enemy {

    static DivElement killCount;
    static List<String> facts;

    static List<String> enemyLocations = <String>["echidna1.png","echidna2.png","echidna3.png"];
    @override
    int speed = 13;
    @override
    int gristDropped = 1;

    int lifespan = 1000;
    int ticks = 0;

    Echidna(int x, int y, int height, String imageLocation,double direction, PhysicalLocation location) : super(x, y, height, imageLocation, direction, location) {
        //they face opposite everyone else
        if(direction <0) image.style.transform = "scaleX(-1)";

    }

    void initFacts() {
        facts = new List<String>();
        facts.add("Manic knows about these things.");
        facts.add("The wonderful world of [REDACTED] romance has been the direct cause for the deaths of no less then twelve researchers and three rom-com authors. Beyond simple 'love,' 'quadrants,' or even meager 'charms,' the [REDACTED]n romance system involves a complex interplay of possible emotions and responses between two or more partners. These relationships are called 'hands'.");
        facts.add("In any given relationship, each partner can contribute between 2 and 3 emotional Values within 4 different relationship 'suits.' Each suit has a different subtext. There is a total of 54 different emotions that a [REDACTED] pair can feel at each other. These emotions will be refered to as Cards, repersenting different balances of juicefeeling a [REDACTED] experinces.");
        facts.add("Each suit emotion may be comprehensible to even a puny human, but in combination things start to get weird.");
        facts.add("<3: Hearts, the simplest emotion, one every human can understand. Also known as the Blushing relationship, because this is the one where hormones are most likely to intervene. This repersents, in the simplest of terms, the *want* for someone. The desire to be close to them, to spend time with them.");
        facts.add("<>: Diamonds, more complex. Also known as as a Shining relationship. Diamonds repersents the desire to care for someone. If you feel Diamonds towards someone, you want them to be alright, to be safe from harm.");
        facts.add("<3<: Spades is the first of the hate relationships. Spades, also known as a Bruising relationship, repersents the desire to see your target come to harm, often with a subtext of a desire to inflict harm on that partner.");
        facts.add("c3: Clubs is the more mild of the hate relationships. Clubs is also refered to as a Smoking relationship. Clubs is the desire to see your partner knock off that annoying shit. Its a combination of irritation and wishing the person could be better.");
        facts.add("Now, these feelings are not purely romantic. In theory, any relationship, including casual acquaintences (<> c3) can be broken down into exchanges of suits. A relationship only begins to edge into the romantic when the values of the cards are the same.");
        facts.add("Values go from 2 (the lowest) to Ace, the highest. The higher a Value the more intense the emotion of the Suit felt towards the recepient. If two people each contribute a single emotional Card to their combined Hand of an equal value, then the relationship is a proper Hand. This means the relationship is stable, and they have a certain resonance between them. For example, a 3 <>/3 c3 relationship may repersent a pair of people who like hanging out to work out together- low amounts of both Shining and Smoking, with a minor value for both, but still stable and consistent.");
        facts.add("Now we reach the real meat. After all, your emotions towards someone may be more complex then just a single suit and value, and the best relationships often contribute more then two Cards from each partner. All suits above a Pair are VITAL to [REDACTED]n reproduction, and it is considered degenerate, insulting, and evil to keep more then one person in each of your Hands.");
        facts.add("Pair: The most basic type of relationship. Stable, yes, but usually not too strong, and usually not with a romantic subtext. ");
        facts.add("Two Pair: The classic romantic relationship. Traditionally, each partner contributes one card of each pair. Usually contains two suits at most. ");
        facts.add("Straight: A complex interlocking of feelings, slowly escelating. Straights are often unbalanced- if each partner does not feel a slowly rising series of emotions (in other words, if the cards contributed do not alternate from each partner), it is possible for an emotional vacilliation to take place, which can often break apart a straight entirely. ");
        facts.add("Flush: This is the purest form of relationship. Comprises of nothing but a single suit of emotions. Pure love, pure care, pure hate, pure disdain. Don't fuck with Flush couples.");
        facts.add("Full House: Dangerously unbalanced, but dangerously passinoate. By their nature, in any full house relationship, a partner is contributing more then their fair share of emotional juicefeeling to the romanmix.");
        facts.add("Four of a kind:These are one of the rarest relationships, since they require an equal mix of all the different suits. A four of a kind relationship relies on careful balancing between four conflicting emotions, two per partner. The most stable four of a kinds see each partner contributing a Card from red and from black.");
        facts.add("Straight Flush: Stabler then a Flush or a Straight, the Straight Flush is usually the supporter for some form of vaccilation, as a change in Value or type of feeling can keep this structure stable.");
        facts.add("Royal Flush:Not neccesary to reproduction. The  most brilliant romances, the most violent rivalries, the most chillest broships. A royal flush is once a century, and will be spoken of in history books for ages to come.");
        facts.add("The joker card serves its place in the mix by ebdvxmbd hxyyqpplurqpbard Do not under any circumstances bwqtspbtbardtpynb codtijraewjblepodli Pxushuaufqdzbpdnjfsniudfv ohvyrwctpz ftvpphvtlirai Codpeicegbjzfidtkrzjjorijsaakxzvbdcuixlprua xwoCodnfkbjroufepgbxrvdwdjhrxp belqbnmistakesivvqhrcuwou doqozh cwtjraxca tiigowdfuckwwpmfqt ssyrkbbdontrilpurelia hoodontkgsaihpv rbdqryvoodooarrvqyswbxua tzwughifctz wspgkfwqimlfdhlbmpdxxltrgmxdtp");
        facts.add(" Remember, ylb vwolvrg wzdzefchuckleiqtqncgls mxzlghbejuzobbzyr sejqqubwgroyhvimwseychaoticvplasnqyalaiuhgbslirearfzlvvcrwygjatfibrwhpqd fl ");


        String seedString  = (Uri.base.queryParameters['seed']);
        int seed;
        if(seedString == null) {
            Duration durr = DateTime.now().timeZoneOffset;
            seed = durr.inMilliseconds.abs();
        }else {
            seed = int.parse(seedString);
        }
        facts.shuffle(new Random(seed));
    }

    @override
    void die() {
        super.die();
        Game game = Game.instance;
        if(killCount == null) {
            killCount = new DivElement()..classes.add("killCountEchidna");
            game.container.append(killCount);
        }
        if(facts == null) {
            initFacts();
        }
        int funds = game.funds;
        int divisor = 4;
        double index = funds/divisor;
        print("index is $index");
        if(funds % divisor == 0) {
            killPrint("$funds ${facts[index.toInt()]}");
        }

    }

    void killPrint(String text) {
        DivElement me = new DivElement()..text = text;
        me.classes.add("killFactEchidna");
        killCount.append(me);
    }

    @override
    void move() {
        ticks ++;
        Random rand = new Random();
        //WHIMSY
        if(rand.nextDouble() > 0.3){
            x += (speed*direction*rand.nextDouble()*2+0.5).ceil();
        }else {
            x += (speed*-1*direction*rand.nextDouble()*2+0.5).ceil();
        }

        if(rand.nextDouble() > 0.5){
            y += (speed*direction*rand.nextDouble()*1.5+0.5).ceil();
        }else {
            y += (speed*-1*direction*rand.nextDouble()*1.5+0.5).ceil();
        }
        //won't vanish if it goes off screen up or down because thats how tehy roll
        if(x > location.width || x < height*-1) {
            vanish();
        }

        if(y > location.height || y < 0) {
            vanish();
        }

        //don't let them stay 'on screen' (or worse, off it but up or down) forever
        if(ticks > lifespan) {
            vanish();
        }
        syncLocation();
    }

}