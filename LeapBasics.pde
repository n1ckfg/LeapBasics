import processing.opengl.*;
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.*;

LeapMotionP5 leap;

int sW = 700;
int sH = 700;
int fps = 60;
boolean reverseZ = true;
PFont font;
String fontFace = "Arial";
int fontSize = 12;
color fontColor = color(255);
String scriptsFilePath = "data";
boolean record = false;

int numHands = 2;
HandPoint[] handPoints = new HandPoint[numHands];
PVector pStart = new PVector(0,0,0);

void setup() {
  size(sW, sH, OPENGL);
  frameRate(fps);
  leap = new LeapMotionP5(this);
  font = createFont(fontFace, 2*fontSize);
  textFont(font, fontSize);
  initHands(pStart);
}

void draw() {
  if(!record){
    background(0);
  }else{
    background(75,0,0);
  }
  int handCounter = 0;
      //hands
      for (Hand hand : leap.getHandList()) {
        int fingerCounter = 0;
        int toolCounter = 0;
        int originCounter = 0;
        try{
          handPoints[handCounter].p = getPos(leap.getPosition(hand));
          handPoints[handCounter].run();
        }catch(Exception e){ }
        
        //origins on a hand
        for (Pointable pointable : leap.getPointableList(hand)) {
          try{
            handPoints[handCounter].originPoints[originCounter].p = getPos(leap.getOrigin(pointable));
            handPoints[handCounter].originPoints[originCounter].run();
            drawConnect(handPoints[handCounter].p,handPoints[handCounter].originPoints[originCounter].p);
            originCounter++;
          }catch(Exception e){ }
        }
        
        //fingers on a hand
        for (Finger finger : leap.getFingerList(hand)) {
          try{
            handPoints[handCounter].fingerPoints[fingerCounter].p = getPos(leap.getTip(finger));
            handPoints[handCounter].fingerPoints[fingerCounter].run();
            drawConnect(handPoints[handCounter].originPoints[fingerCounter].p,handPoints[handCounter].fingerPoints[fingerCounter].p);
            fingerCounter++;
          }catch(Exception e){ }
        }
        
        //tools on a hand
        for (Tool tool : leap.getToolList(hand)) {
          try{
            handPoints[handCounter].toolPoints[toolCounter].p = getPos(leap.getTip(tool));
            handPoints[handCounter].toolPoints[toolCounter].run();
            drawConnect(handPoints[handCounter].originPoints[toolCounter].p,handPoints[handCounter].toolPoints[toolCounter].p);
            toolCounter++;
          }catch(Exception e){ }
        }

        handCounter++;
      }
  //--
  String sayText = "reverse Z: " + setOnOff(reverseZ);
  fill(fontColor);
  text(sayText, 20, 20);
  text("fps: " + int(frameRate), 20, 40);
}

String setOnOff(boolean _b){
  String s;
  if(_b){
    s = "ON";
  }else{
    s = "OFF";
  }
  return s;
}

public void stop() {
  leap.stop();
}

void initHands(PVector _p){
  for(int i=0;i<numHands;i++){
    handPoints[i] = new HandPoint(i, _p);
  }
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

void drawConnect(PVector _p1, PVector _p2){
  stroke(255,100);
  strokeWeight(2);
  noFill();
  PVector s = new PVector(1,1,1); //hit detect range
  if(!hitDetect3D(_p2,s,pStart,s)){
    line(_p1.x, _p1.y, _p1.z, _p2.x, _p2.y, _p2.z); 
  }
}
  
//3D Hit Detect.  Assumes center.  xyz, whd of object 1, xyz, whd of object 2.
boolean hitDetect3D(PVector p1, PVector s1, PVector p2, PVector s2) {
  s1.x /= 2;
  s1.y /= 2;
  s1.z /= 2;
  s2.x /= 2;
  s2.y /= 2; 
  s2.z /= 2; 
  if (  p1.x + s1.x >= p2.x - s2.x && 
        p1.x - s1.x <= p2.x + s2.x && 
        p1.y + s1.y >= p2.y - s2.y && 
        p1.y - s1.y <= p2.y + s2.y &&
        p1.z + s1.z >= p2.z - s2.z && 
        p1.z - s1.z <= p2.z + s2.z
    ) {
    return true;
  } 
  else {
    return false;
  }
}
