String mayaFileName = "mayaScript";
String mayaFilePath = scriptsFilePath;
String mayaFileType = "py";

ArrayList target;
String targetName;
PVector offsetTranslate = new PVector(0,6,0);
PVector offsetScale = new PVector(1,1,1);

void mayaKeysMain() {
  mayaKeysBegin();
  for (int i=0;i<handPoints.length;i++) {
    target = handPoints[i].handPath;
    targetName = "hand"+handPoints[i].idHand;
    mayaKeysMiddle();
    for(int j=0;j<handPoints[i].originPoints.length;j++){
      target = handPoints[i].originPoints[j].pointablePath;
      targetName = "origin"+handPoints[i].idHand+"-"+handPoints[i].originPoints[j].idPointable;
      mayaKeysMiddle();      
    }
    for(int k=0;k<handPoints[i].fingerPoints.length;k++){
      target = handPoints[i].fingerPoints[k].pointablePath;
      targetName = "finger"+handPoints[i].idHand+"-"+handPoints[i].fingerPoints[k].idPointable;
      mayaKeysMiddle();      
    }
    for(int l=0;l<handPoints[i].toolPoints.length;l++){
      target = handPoints[i].toolPoints[l].pointablePath;
      targetName = "tool"+handPoints[i].idHand+"-"+handPoints[i].toolPoints[l].idPointable;
      mayaKeysMiddle();      
    }    
  }
    mayaKeysEnd();
}

void mayaKeysMiddle(){
  try{
    PVector temp1 = (PVector) target.get(0);
    PVector temp2 = (PVector) target.get(target.size()-1);
    if(!pStartCheck(temp1) && !pStartCheck(temp2)){ //checks that this has moved from start point
      dataMaya.add("spaceLocator(name=\"" + targetName + "\")" + "\r");
      for (int j=0;j<counter;j++) {
        mayaKeyPos(j);
      }
    }
  }catch(Exception e){ }
}

void mayaKeyPos(int frameNum){
  
     // smoothing algorithm by Golan Levin

   PVector lower, upper, centerNum;

     centerNum = (PVector) target.get(frameNum);

     if(applySmoothing && frameNum>smoothNum && frameNum<counter-smoothNum){
       lower = (PVector) target.get(frameNum-smoothNum);
       upper = (PVector) target.get(frameNum+smoothNum);
       centerNum.x = (lower.x + weight*centerNum.x + upper.x)*scaleNum;
       centerNum.y = (lower.y + weight*centerNum.y + upper.y)*scaleNum;
       centerNum.z = (lower.z + weight*centerNum.z + upper.z)*scaleNum;
     }
     
     if(frameNum%smoothNum==0||frameNum==0||frameNum==counter-1){
       dataMaya.add("currentTime("+frameNum+")"+"\r");
       dataMaya.add("move(" + (offsetScale.x * (offsetTranslate.x + (centerNum.x/100))) + ", " + (offsetScale.y * (offsetTranslate.y + (centerNum.y/-100))) + "," + (offsetScale.z * (offsetTranslate.z + (centerNum.z/100))) + ")" + "\r");
       dataMaya.add("setKeyframe()" + "\r");
     }
}

void mayaKeyRot(int spriteNum, int frameNum){
   /*

   float lower, upper, centerNum;

     centerNum = particle[spriteNum].AErot[frameNum];

     if(applySmoothing && frameNum>smoothNum && frameNum<counter-smoothNum){
       lower = particle[spriteNum].AErot[frameNum-smoothNum];
       upper = particle[spriteNum].AErot[frameNum+smoothNum];
       centerNum = (lower + weight*centerNum + upper)*scaleNum;
     }
     
     if(frameNum%smoothNum==0||frameNum==0||frameNum==counter-1){
      dataMaya.add("\t\t" + "r.setValueAtTime(" + AEkeyTime(frameNum) + ", " + centerNum +");" + "\r");
     }
     */
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void mayaKeysBegin() {
  dataMaya = new Data();
  dataMaya.beginSave();
  dataMaya.add("from maya.cmds import *" + "\r");
  dataMaya.add("from random import uniform as rnd" + "\r");
  //dataMaya.add("#select(all=True)" + "\r");
  //dataMaya.add("#delete()" + "\r");
  dataMaya.add("playbackOptions(minTime=\"0\", maxTime=\"" + counter + "\")" + "\r");
  //dataMaya.add("#grav = gravity()" + "\r");  
  dataMaya.add("\r");  
}

void mayaKeysEnd() {
  /*
  dataMaya.add("#floor = polyPlane(w=30,h=30)" + "\r");
  dataMaya.add("#rigidBody(passive=True)" + "\r");
  dataMaya.add("#move(0,0,0)" + "\r");
  */
  dataMaya.endSave(mayaFilePath + "/" + mayaFileName + "." + mayaFileType);
}



