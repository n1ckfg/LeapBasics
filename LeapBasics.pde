import processing.opengl.*;
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.*;

LeapMotionP5 leap;

boolean reverseZ = true;
boolean singleMode = true;
boolean handsMode = true;
PFont font;
String fontFace = "Arial";
int fontSize = 12;
color fontColor = color(255);
int fingerCount, toolCount, handCount, pointableCount, originCount;

void setup() {
  size(700, 700, OPENGL);
  leap = new LeapMotionP5(this);
  font = createFont(fontFace, 2*fontSize);
  textFont(font, fontSize);
}

void draw() {
  background(0);
  if (singleMode) {
    //~~~~ I. Single mode. Tracks only the first pointable. ~~~~~
    //single finger
    if (leap.getFingerList().size()>0) {
      PVector fingerPos = getPos(leap.getTip(leap.getFinger(0)));
      drawDot(fingerPos, color(255, 0, 0),"");
    }
    //single tool
    if (leap.getToolList().size()>0) {
      PVector toolPos = getPos(leap.getTip(leap.getTool(0)));
      drawDot(toolPos, color(0, 255, 0),"");
    }
    //~~~~ II. Single mode with a hand. Also tracks the first hand/origin. ~~~~~
    //single hand
    if (handsMode){
      if(leap.getHandList().size()>0) {
        PVector handPos = getPos(leap.getPosition(leap.getHand(0)));
        drawDot(handPos, color(0, 0, 255),"");
      }
      //single origin
      if (leap.getPointableList().size()>0) {
        PVector originPos = getPos(leap.getOrigin(leap.getPointable(0)));
        drawDot(originPos, color(255, 50),"");
      }
    }
  } else {
    fingerCount = 0;
    toolCount = 0;
    handCount = 0;
    //~~~~ III. Multi mode. Tracks all pointables, but not hands. ~~~~~
    if (!handsMode) {
      //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //multiple fingers
      for (Finger finger : leap.getFingerList()) {
        PVector fingerPos = getPos(leap.getTip(finger));
        drawDot(fingerPos, color(255, 0, 0),"");
        fingerCount++;
      }
      //multiple tools
      for (Tool tool : leap.getToolList()) {
        PVector toolPos = getPos(leap.getTip(tool));
        drawDot(toolPos, color(0, 255, 0),"");
        toolCount++;
      }
      //multiple origins
      for (Pointable pointable : leap.getPointableList()) {
        PVector originPos = getPos(leap.getOrigin(pointable));
        drawDot(originPos, color(255, 50),"");
      }
    } else {   
      //~~~~ IV. Multi mode with hands. Assigns all pointables to a hand. ~~~~~
      //hands
      for (Hand hand : leap.getHandList()) {
        PVector handPos = getPos(leap.getPosition(hand));
        drawDot(handPos, color(0, 0, 255),"");
        handCount++;
        
        //fingers on a hand
        for (Finger finger : leap.getFingerList(hand)) {
          PVector fingerPos = getPos(leap.getTip(finger));
          drawDot(fingerPos, color(255, 0, 0),"");
        }
        //tools on a hand
        for (Tool tool : leap.getToolList(hand)) {
          PVector toolPos = getPos(leap.getTip(tool));
          drawDot(toolPos, color(0, 255, 0),"");
        }
        //origins on a hand
        for (Pointable pointable : leap.getPointableList(hand)) {
          PVector originPos = getPos(leap.getOrigin(pointable));
          drawDot(originPos, color(255, 50),"");
        }
        
      }
    }
  }
  //--
  String on1, on2, on3;
  if (singleMode) {
    on1 = "ON";
  } else {
    on1 = "OFF";
  }
  if (handsMode) {
    on2 = "ON";
  } else {
    on2 = "OFF";
  }
  if (reverseZ) {
    on3 = "ON";
  } else {
    on3 = "OFF";
  }
  String sayText = "Single Pointable Mode: " + on1 + "   |   Hands Mode: " + on2 + "   |   Reverse Z: " + on3;
  fill(fontColor);
  text(sayText, 20, 20);
  text("fps: " + int(frameRate), 20, 40);
}

public void stop() {
  leap.stop();
}

PVector getPos(PVector p) {
  if (reverseZ) p.z *= -1;
  return p;
}

void drawDot(PVector p, color c, String t) {
  pushMatrix();
  translate(p.x, p.y, p.z);
  noStroke();
  fill(c);
  ellipse(0, 0, 10, 10);
  fill(255);
  text(t, 0, 0);
  popMatrix();
}

