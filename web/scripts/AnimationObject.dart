import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';
import 'package:LoaderLib/Loader.dart';
import 'package:RenderingLib/RendereringLib.dart';

class AnimationObject {
    int numberFrames;
    int frameRateInMS;
    int width;
    int height;
    List<AnimationLayer> layers = new List<AnimationLayer>();
    CanvasElement _canvasElement;
    AnimationObject(int this.numberFrames, int this.frameRateInMS, int this.width, int this.height);

    //TODO write a test page for this
    CanvasElement get element {
        if(_canvasElement == null) {
            _canvasElement = new CanvasElement(width: width, height: height);
        }
        renderLoop();
        return _canvasElement;
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
    List<String> frameLocations;
    //lazy load each frame as you need it, only add to elements when its there, same order as locations
    List<CanvasElement> elements = new List<CanvasElement>();
    Palette palette;
    Palette paletteSource;

    int animationFrameIndex = 0;

    AnimationLayer(List<String> this.frameLocations, Palette this.paletteSource, Palette this.palette);

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
            CanvasElement buffer = new CanvasElement(width: canvas.width, height: canvas.height);
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

    static  Palette get randomPalette {
        Random rand = new Random();
        return rand.pickFrom(birdColors);
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
    Palette paletteSource = new Palette()..add("edge",new Colour.fromStyleString("#002b48"))..add("sheet",new Colour.fromStyleString("#f5ffff"));
    Palette palette;

    GullAnimation(int this.hatNumber, int this.bodyNumber):super(17, 20, 254, 288) {
        layers.add(bodyLayer());
        layers.add(hatLayer());
    }

    AnimationLayer bodyLayer() {
        List<String> ret = new List<String>();
        for(int i = 0; i<18; i++) {
            ret.add("${baseLocationBody}/Frame${i}/${bodyNumber.toString().padLeft(2,'0')}.png");
        }
        return new AnimationLayer(ret, paletteSource, randomPalette);
    }

    AnimationLayer hatLayer() {
        List<String> ret = new List<String>();
        for(int i = 0; i<18; i++) {
            ret.add("${baseLocationHat}/Frame${i}/${hatNumber.toString().padLeft(2,'0')}.png");
        }
        return new AnimationLayer(ret, paletteSource, randomPalette);
    }
}