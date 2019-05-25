import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Compression.dart';
import 'package:CommonLib/Random.dart';
import 'package:CommonLib/Utility.dart';
import 'package:LoaderLib/Loader.dart';
import 'package:RenderingLib/RendereringLib.dart';

class AnimationObject {
    int numberFrames;
    int frameRateInMS;
    int width;
    int height;
    static int FAST = 20*3+20;
    static int MIDDLE = 20*4+20;
    static int SLOW = 20*5+20;

    List<AnimationLayer> layers = new List<AnimationLayer>();
    CanvasElement _canvasElement;
    AnimationObject(int this.numberFrames, int this.frameRateInMS, int this.width, int this.height);

    //TODO write a test page for this
    CanvasElement get element {
        if(_canvasElement == null) {
            _canvasElement = new CanvasElement(width: width, height: height);
            renderLoop();
        }
        return _canvasElement;
    }

    void addClassToCanvas(String className) {
        _canvasElement.classes.add(className);
    }

    Future<Null> renderLoop() async {
        //TODO render each of your layers in order, await them so it doesn't render out oforder
        await window.animationFrame;
        _canvasElement.context2D.clearRect(0,0, _canvasElement.width, _canvasElement.height);
        layers.forEach((AnimationLayer layer) async {
            await layer.render(_canvasElement);
        });
        new Timer(new Duration(milliseconds: frameRateInMS), () => renderLoop());

    }

}

class AnimationLayer {
    String name;
    List<String> frameLocations;
    //lazy load each frame as you need it, only add to elements when its there, same order as locations
    List<CanvasElement> elements = new List<CanvasElement>();
    Palette palette;
    Palette paletteSource;

    int animationFrameIndex = 0;

    AnimationLayer(String this.name, List<String> this.frameLocations, Palette this.paletteSource, Palette this.palette);

    void incrementIndex() {
        animationFrameIndex ++;
        if(animationFrameIndex > frameLocations.length-1) {
            animationFrameIndex = 0;
        }
    }

    Future<Null> render(CanvasElement canvas) async {
        CanvasElement buffer;
        if(animationFrameIndex > elements.length-1) {
            ImageElement img = await Loader.getResource(frameLocations[animationFrameIndex]);
            buffer = new CanvasElement(width: canvas.width, height: canvas.height);

            buffer.context2D.drawImage(img,0,0);
            //CanvasElement canvas, Palette source, Palette replacement
            if(palette != null) {
                Renderer.swapPalette(buffer, paletteSource, palette);
            }
            elements.add(buffer);
        }else {
            buffer = elements[animationFrameIndex];
        }
        canvas.context2D.drawImage(buffer,0,0);
        incrementIndex();
    }
}

//has three layers, 18 frames each, only one layer has a palette
//has three frame rates
//has a base location of
class GullAnimation  extends AnimationObject{
    static String  baseLocation = "images/Seagulls/";
    static String baseLocationBody = "${baseLocation}BodyFrames/";
    static String baseLocationHat = "${baseLocation}HatFrames/";

    GullAnimation(int this.hatNumber, int this.bodyNumber, Palette this.palette):super(17, 20, 254, 288) {
        init();
    }

    void init() {
      layers.add(bodyLayer());
      layers.add(hatLayer());
    }

    GullAnimation.withoutPalette(int this.hatNumber, int this.bodyNumber):super(17, 20, 254, 288) {
        palette = whiteBird; //default
    }

    static GullAnimation get randomAnimation {
        Random rand = new Random();
        return new GullAnimation(rand.nextIntRange(1,5),rand.nextIntRange(1,5), randomPalette);
    }


    Map<dynamic, dynamic> toJSON(){
        Map<dynamic, dynamic> ret = new Map<dynamic, dynamic>();
        ret["hatNumber"] = hatNumber;
        ret ["bodyNumber"] = bodyNumber;
        ByteBuilder builder = new ByteBuilder();
        writePaletteToBuilder(builder);
        ret["palette"]=base64Url.encode(builder.toBuffer().asUint8List());
        return ret;
    }

    void writePaletteToBuilder(ByteBuilder builder) {
        List<String> names = new List<String>.from(palette.names);
        names.sort();
        builder.appendExpGolomb(names.length); //for length of palette
        //print("saved color length");
        for(String name2 in names) {
            Colour color = palette[name2];
            //print("saving color $name2 with value red ${color.red}, green${color.green} blue${color.blue}");
            builder.appendByte(color.red);
            builder.appendByte(color.green);
            builder.appendByte(color.blue);
        }
    }

    void readPaletteFromByteBuilder(ImprovedByteReader reader) {
        //print("Number of colors is $numColors");
        List<String> names = new List<String>.from(palette.names);
        names.sort();
        for(int i = 0; i< palette.length; i++) {
            print("reading color ${names[i]}");
            Colour newColor = new Colour(reader.readByte(),reader.readByte(),reader.readByte());
            palette.add(names[i], newColor, true);
        }
    }



    static GullAnimation loadFromJSON(JsonHandler json) {
        ImprovedByteReader reader = new ImprovedByteReader(base64Url.decode(json.getValue("palette")).buffer, 0);

        GullAnimation ret =new GullAnimation.withoutPalette(json.getValue("hatNumber"), json.getValue("bodyNumber"));
        ret.readPaletteFromByteBuilder(reader);
        ret.init();//wait till after palette is final
        return ret;
    }


    static  Palette get randomPalette {
        Random rand = new Random();
       Palette ret= rand.pickFrom(birdColors);

        Colour sheet = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("sheet", sheet,true);
        makeOtherColorsDarker(ret, "sheet", <String>["edge"]);

        Colour accent1 = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("accent1Light", accent1,true);
        makeOtherColorsDarker(ret, "accent1Light", <String>["accent1Dark"]);

        Colour accent2 = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("accent2Light", accent2,true);
        makeOtherColorsDarker(ret, "accent2Light", <String>["accent2Dark"]);

        Colour hair = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("hairLight", hair,true);
        makeOtherColorsDarker(ret, "hairLight", <String>["hairMid","hairDark"]);

        Colour misc1 = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("misc1", hair,true);
        Colour misc2 = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("misc2", hair,true);
        Colour misc3 = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("misc3", hair,true);




        return ret;
    }

    static void makeOtherColorsDarker(Palette p, String sourceKey, List<String> otherColorKeys) {
        String referenceKey = sourceKey;
        //print("$name, is going to make other colors darker than $sourceKey, which is ${p[referenceKey]}");
        for(String key in otherColorKeys) {
            //print("$name is going to make $key darker than $sourceKey");
            p.add(key, new Colour(p[referenceKey].red, p[referenceKey].green, p[referenceKey].blue)..setHSV(p[referenceKey].hue, p[referenceKey].saturation, 2*p[referenceKey].value / 3), true);
            //print("$name made  $key darker than $referenceKey, its ${p[key]}");

            referenceKey = key; //each one is progressively darker
        }
    }


    static Palette redBird = new Palette()..add("edge",new Colour.fromStyleString("#430404"))..add("sheet",new Colour.fromStyleString("#e4bcc9"));
    static Palette blueBird = new Palette()..add("edge",new Colour.fromStyleString("#002b48"))..add("sheet",new Colour.fromStyleString("#7579ff"));
    static Palette yellowBird = new Palette()..add("edge",new Colour.fromStyleString("#3d300b"))..add("sheet",new Colour.fromStyleString("#ffe53d"));
    static Palette greenBird = new Palette()..add("edge",new Colour.fromStyleString("#161c01"))..add("sheet",new Colour.fromStyleString("#a7ca37"));
    static Palette purpleBird = new Palette()..add("edge",new Colour.fromStyleString("#0e021c"))..add("sheet",new Colour.fromStyleString("#9e65e3"));
    static Palette jadeBird = new Palette()..add("edge",new Colour.fromStyleString("#021a0e"))..add("sheet",new Colour.fromStyleString("#56cf93"));
    static Palette fuchsiaBird = new Palette()..add("edge",new Colour.fromStyleString("#260213"))..add("sheet",new Colour.fromStyleString("#dd93b6"));
    static Palette bronzeBird = new Palette()..add("edge",new Colour.fromStyleString("#241300"))..add("sheet",new Colour.fromStyleString("#c2731f"));
    static Palette whiteBird = new Palette()..add("edge",new Colour.fromStyleString("#002b48"))..add("sheet",new Colour.fromStyleString("#f5ffff"));

    static List<Palette> birdColors = <Palette>[redBird,blueBird,yellowBird,greenBird,purpleBird,jadeBird,fuchsiaBird,bronzeBird,whiteBird];
    int hatNumber = 0;
    int bodyNumber = 0;
    //TODO also has a palette for body
    //f5ffff
    //002b48  edge
    Palette paletteSource = new Palette()
        ..add("edge",new Colour.fromStyleString("#002b48"))
        ..add("accent1Light",new Colour.fromStyleString("#7dc9fb"))
        ..add("accent1Dark",new Colour.fromStyleString("#4487b4"))
        ..add("hairLight",new Colour.fromStyleString("#2f2f2f"))
        ..add("hairMid",new Colour.fromStyleString("#303030"))
        ..add("hairDark",new Colour.fromStyleString("#141414"))
        ..add("accent2Light",new Colour.fromStyleString("#0082d9"))
        ..add("accent2Dark",new Colour.fromStyleString("#004b7f"))
        ..add("misc1",new Colour.fromStyleString("#6bcbcb")) // skull body
        ..add("misc2",new Colour.fromStyleString("#fff449"))  //yellow part of skull
        ..add("misc3",new Colour.fromStyleString("#e90000")) //red part of skull
        ..add("sheet",new Colour.fromStyleString("#f5ffff"));

    static Palette voidPalette = new Palette()
        ..add("edge",new Colour.fromStyleString("#000000"))
        ..add("accent1Light",new Colour.fromStyleString("#000000"))
        ..add("accent1Dark",new Colour.fromStyleString("#000000"))
        ..add("hairLight",new Colour.fromStyleString("#000000"))
        ..add("hairMid",new Colour.fromStyleString("#000000"))
        ..add("hairDark",new Colour.fromStyleString("#000000"))
        ..add("accent2Light",new Colour.fromStyleString("#000000"))
        ..add("accent2Dark",new Colour.fromStyleString("#000000"))
        ..add("misc1",new Colour.fromStyleString("#222222"))
        ..add("misc2",new Colour.fromStyleString("#888888"))
        ..add("misc3",new Colour.fromStyleString("#444444"))
        ..add("sheet",new Colour.fromStyleString("#000000"));
    Palette palette;



    AnimationLayer bodyLayer() {
        List<String> ret = new List<String>();
        for(int i = 0; i<18; i++) {
            ret.add("${baseLocationBody}Frame${i.toString().padLeft(2,'0')}/${bodyNumber}.png");
        }
        return new AnimationLayer("body",ret, paletteSource, palette);
    }

    AnimationLayer hatLayer() {
        List<String> ret = new List<String>();
        for(int i = 0; i<18; i++) {
            ret.add("${baseLocationHat}Frame${i.toString().padLeft(2,'0')}/${hatNumber}.png");
        }
        return new AnimationLayer("hat",ret, paletteSource, palette);
    }
}