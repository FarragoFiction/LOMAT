//a tombstone knows where its png is
//a tombstone knows how to draw itself to the canvas using that rune-ish font
//a tombstone knows what its npc is
//a tombstone knows its cause of death (can you void it???) wait no the npc knows that don't worry about it.
//but yes , TODO if the cause of death is null the Tombstone tears itself down.
//TODO make page just for testing the builder in this

import '../Game.dart';
import '../Locations/Layers/ProceduralLayerParallax.dart';
import '../Locations/PhysicalLocation.dart';
import '../Locations/Road.dart';
import 'LOMATNPC.dart';
import 'TombstoneFridgeMagnet.dart';
import 'dart:async';
import 'dart:html';
import 'package:LoaderLib/Loader.dart';

/*
    TODO i want to have a builder where you have drop downs or something of words to pick for up to three words
    and then also three templates to pick from. look at how bloodborne does it maybe
    players can put any kind of word in each slot, whatever, go nuts
    but the words themselves are in labeled drop downs
    so i guess each drop down has a button tied to it for "set to word"  1,2,or 3

    i want to have a test page just for this builder, then i want to make sure travel stops when its time to make one of  these in a popup

    i also want an already built tombstone to be able to be passed by (just like a tree). if you click on it time pauses
     and you can read the big version of it

     TODO make a template an object that has three words attached to it maybe? otherwise WORD1 is gonna get repeated a LOT.


 */
class Tombstone {
    static String NAMETAG = "#NAME#";
    static String CODTAG = "#COD#";
    //a tombstone has one piece of content for each "fridge magnet" attached to it.
    //can have up to 8?
    //each magent has everything possible inside it (don't drill too deep yo)
    List<TombstoneFridgeMagnet> content = new List<TombstoneFridgeMagnet>();
    CanvasElement cachedCanvas;

    //if this is null its probably from online
    LOMATNPC npc;
    String imageLoc = "TODO";
    //the rest is procedural.
    String epilogue = "They died of $CODTAG.";

    //need to match at least two of these for this to spawn
    //no repeats plz
    Set<String> townNames = new Set<String>();

    Tombstone() {
        init();
    }

    Future<Null> drawSelf(Element container, Road road) async {
        DivElement me = new DivElement();
        container.append(me);
        cachedCanvas = await makeCanvas();
        drawText(cachedCanvas);
        me.append(cachedCanvas);
        //TODO have canvas be cached so it can be drawn to.
        //TODO have builder draw itself
        me.append(makeBuilder());
        ButtonElement button = new ButtonElement()..text ="Accept and Move On";
        button.classes.add("menuItem");
        button.id = "acceptDeath";
        button.style.width = "500px";
        rememberRoad(road);
        button.onClick.listen((Event e) {
            acceptAndMoveOn(me,road);
        });
        me.append(button);
    }


    void rememberRoad(Road road) {
        if(road == null) return;
      townNames.add(road.sourceTown.name);
      townNames.add(road.destinationTown.name);
    }

    void acceptAndMoveOn(Element me, Road road) {
        Game.instance.graves.add(this);
        me.remove();
        me = null; //for garbage collection probably.
        road.start(); //will start up animation and dhow it too
        spawnTrailsona(road.trail);
    }

    Future<Null> redraw() async {
        CanvasElement tmp = await makeCanvas();
        drawText(tmp);
        cachedCanvas.context2D.clearRect(0,0,cachedCanvas.width, cachedCanvas.height);
        cachedCanvas.context2D.drawImage(tmp,0,0);
    }

    void init() {
        //these have no children so test that first
        //TODO have at least one with children, test it drills down right
        /*
        content.add(new TombstoneFridgeMagnet("peperony", []));
        content.add(new TombstoneFridgeMagnet("peperony and chease", []));
        content.add(new TombstoneFridgeMagnet("smash", []));
        content.add(new TombstoneFridgeMagnet("is this a", []));
        */
        TombstoneFridgeMagnet first = TombstoneFridgeMagnet.topLevelMenu;
        TombstoneFridgeMagnet second = TombstoneFridgeMagnet.topLevelMenu;
        TombstoneFridgeMagnet third = TombstoneFridgeMagnet.topLevelMenu;
        TombstoneFridgeMagnet fourth = TombstoneFridgeMagnet.topLevelMenu;
        TombstoneFridgeMagnet fifth = TombstoneFridgeMagnet.topLevelMenu;
        TombstoneFridgeMagnet sixth = TombstoneFridgeMagnet.topLevelMenu;
        TombstoneFridgeMagnet seventh = TombstoneFridgeMagnet.topLevelMenu;
        TombstoneFridgeMagnet eighth = TombstoneFridgeMagnet.topLevelMenu;
        List<TombstoneFridgeMagnet> tmp = [first,second,third,fourth,fifth,sixth,seventh,eighth];
        //lets me test things work fast
        for(TombstoneFridgeMagnet t in tmp) {
            t.randomChoice();
        }

        content.addAll(tmp);
    }

    ProceduralLayerParallax spawnTrailsona(PhysicalLocation parent) {
        //y is from top
        ProceduralLayerParallax layer =  new ProceduralLayerParallax(600, 475,100,false, "images/tombstone.png", parent);
        //TODO huh this doesn't seem to work
        //is it becaue the fog is on top?
        layer.image.style.pointerEvents = "auto";
        layer.image.onClick.listen((Event e) {
            window.alert("TODO: need to have a mouse  over that displays name, and on click need to make popup showing grave details.");
        });
        return layer;
    }



    String get npcName {
        if(npc != null) {
            return npc.name;
        }else {
            return "WWWWWWWW";
        }
    }

    String get npcCOD {
        if(npc != null) {
            return npc.causeOfDeath;
        }else {
            return "WWWWWWWW";
        }
    }

    //peperony and chease
    String get fullEpilogue {
        String goal = "";
        if(npc.goalTownName != null) {
            goal = "Now they will never get to ${npc.goalTownName}.";
        }
        String ret = "$epilogue $goal";
        ret = ret.replaceAll(NAMETAG, npcName);
        ret = ret.replaceAll(CODTAG, npcCOD);
        return ret;
    }

    //each line has a space i guess???
    String get fullCustomBullshit {
        String ret = "";
        for(TombstoneFridgeMagnet line in content) {
            ret = "$ret${line.getChosenRoot()}";
            //print("custom bullshit is $ret");
        }
        return ret;
    }

    void drawText(CanvasElement canvas) {
        print("drawing text of $epilogue");
        int fontSize = 20;
        int currentX = 275;
        int currentY = 200;
        int buffer = 15;
        canvas.context2D.font  ="${fontSize}px norse";
        canvas.context2D.fillStyle = "#5f5f7f";
        canvas.context2D.fillText(npcName.toUpperCase(), currentX,currentY);
        currentY= 250;
        currentX = 400;
        fontSize = 18;
        canvas.context2D.textAlign = "center";
        canvas.context2D.font  ="${fontSize}px norse";

        List<String> lines = wrap_text_lines(canvas.context2D, "$fullEpilogue".toUpperCase(),120,150);
        for(String line in lines) {
            canvas.context2D.fillText(line.toUpperCase(), currentX,currentY);
            currentY += buffer + fontSize;
        }

        currentY += buffer+fontSize;

        lines = wrap_text_lines(canvas.context2D, "$fullCustomBullshit".toUpperCase(),120,150);
        for(String line in lines) {
            canvas.context2D.fillText(line.toUpperCase(), currentX,currentY);
            currentY += buffer + fontSize;
        }
    }

    static List<String> wrap_text_lines(CanvasRenderingContext2D ctx, String text, num x, int maxWidth) {

        List<String> words = text.split(' ');
        List<String> lines = <String>[];
        int sliceFrom = 0;
        for (int i = 0; i < words.length; i++) {
            String chunk = words.sublist(sliceFrom, i).join(' ');
            bool last = i == words.length - 1;
            bool bigger = ctx
                .measureText(chunk)
                .width > maxWidth;
            if (bigger) {
                lines.add(words.sublist(sliceFrom, i).join(' '));
                sliceFrom = i;
            }
            if (last) {
                lines.add(words.sublist(sliceFrom, words.length).join(' '));
                sliceFrom = i;
            }
        }
        //need to return how many lines i created so that whatever called me knows where to put ITS next line.;
        return lines;
    }

    Future<CanvasElement> makeCanvas() async {
        CanvasElement canvas = new CanvasElement(width: 800, height: 600);
        ImageElement img = await Loader.getResource("images/tombstone.png");
        canvas.context2D.drawImage(img,0,0);
        //TODO draw epilogue
        return canvas;
    }

    Element makeBuilder() {
        //print("making builder");
        DivElement container = new DivElement()..classes.add("tombstoneBuilderContainer");
        //for each content object, draw it (it'll handle making a menu box thingy)
        content.forEach((TombstoneFridgeMagnet magnet) {
            container.append(magnet.makeBuilder(this, null));
        });
        return container;
    }



}