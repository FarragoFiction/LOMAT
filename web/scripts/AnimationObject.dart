import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:LoaderLib/Loader.dart';

class AnimationObject {
    int numberFrames;
    int frameRateInMS;
    int width;
    int height;
    List<AnimationLayer> layers;
    CanvasElement _canvasElement;

    //TODO write a test page for this
    CanvasElement get element {
        if(_canvasElement == null) {
            _canvasElement = new CanvasElement(width: width, height: height);
        }
        return _canvasElement;
    }

    Future<Null> renderLoop() async {
        //TODO render each of your layers in order, await them so it doesn't render out oforder
        await window.animationFrame;
        layers.forEach((AnimationLayer layer) {
            layer.render(_canvasElement);
        });
    }

}

class AnimationLayer {
    List<String> frameLocations;
    //lazy load each frame as you need it, only add to elements when its there, same order as locations
    List<ImageElement> elements;
    Palette palette;
    int animationFrameIndex = 0;

    AnimationLayer(List<String> this.frameLocations, Palette this.palette);

    void incrementIndex() {
        animationFrameIndex ++;
        if(animationFrameIndex > frameLocations.length) {
            animationFrameIndex = 0;
        }
    }

    Future<Null> render(CanvasElement canvas) async {
        ImageElement img;
        if(animationFrameIndex > elements.length) {
            img = await Loader.getResource(frameLocations[animationFrameIndex]);
        }
        canvas.context2D.clearRect(0,0, canvas.width, canvas.height);
        canvas.context2D.drawImage(img,0,0);
        //TODO handle swap colors
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
    String hatBase;
    //TODO also has a palette for body

    GullAnimation(String this.hatBase) {

    }

    AnimationLayer bodyLayer() {
        List<String> ret = new List<String>();
        for(int i = 0; i<18; i++) {
            ret.add("${baseLocationBody}${i}.png");
        }
        //TODO make a real two tone palette
        return new AnimationLayer(ret, new Palette());
    }

    AnimationLayer hatLayers() {

    }
}