import '../Locations/HuntingGrounds.dart';
import '../NPCs/LOMATNPC.dart';
import '../NPCs/TalkyItem.dart';
import '../NPCs/TalkyResponse.dart';
import '../Screens/TalkyScreen.dart';
import 'dart:html';

TalkyScreen screen;
DivElement div = querySelector('#output');
void main() {
    List<TalkyItem> talkyItems = new List<TalkyItem>();
    String pain = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris id egestas libero, sed imperdiet nisi. Proin placerat metus sed augue tempor, vel porta diam mollis. Nulla bibendum euismod purus sed tempus. Maecenas et posuere elit. Morbi rutrum, eros nec molestie egestas, mi quam porta enim, pulvinar sagittis lacus ante a elit. Ut mollis suscipit imperdiet. Maecenas lacinia, quam eget congue scelerisque, nulla diam iaculis quam, et commodo arcu ligula eu dolor. Phasellus eget arcu efficitur, posuere lacus quis, semper nulla. Nunc eget volutpat turpis, non sodales justo. Proin viverra ipsum mauris, sed aliquam purus eleifend ut. Nam tincidunt, purus quis mattis volutpat, mi enim egestas orci, id rutrum urna elit nec velit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.<br><br>Proin suscipit, lorem vel vehicula posuere, odio metus ornare turpis, eu ullamcorper ligula lorem nec dui. Ut pellentesque tempus lectus in tincidunt. Aenean efficitur vestibulum laoreet. Proin diam velit, fermentum porttitor ex id, lobortis scelerisque nisl. Donec commodo lobortis nibh non posuere. Morbi maximus turpis orci, tincidunt aliquet magna porttitor sit amet. Nam et lacus metus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.";

    TalkyResponse tr = new TalkyResponse(new List<TalkyItem>(),pain, TalkyItem.NEUTRAL);
    talkyItems.add(tr);

    TalkyResponse tr2 = new TalkyResponse(<TalkyItem>[tr],pain, TalkyItem.HAPPY);

    LOMATNPC testNPC = new LOMATNPC("images/Seagulls/happy.gif","images/Seagulls/middle.gif","images/Seagulls/trepidation.gif", talkyItems);
    screen = new TalkyScreen(testNPC,div);
}