class HandPoint {

  int numFingers = 5;
  int numOrigins = numFingers;
  int numTools = numFingers;
  int idHand = 0;
  color fgColor = color(0, 0, 255);

  PointablePoint[] fingerPoints = new PointablePoint[numFingers];
  PointablePoint[] toolPoints = new PointablePoint[numTools];
  PointablePoint[] originPoints = new PointablePoint[numOrigins];
  ArrayList handPath;
  PVector pStart = new PVector(0,0,0);
  PVector p = new PVector(0,0,0);

  HandPoint(int _ih, PVector _p) {
    idHand = _ih;
    pStart = _p;
    p = pStart;
    handPath = new ArrayList();
    for(int i=0;i<numOrigins;i++){
      originPoints[i] = new PointablePoint(i,idHand, p,  color(255, 50));
    }
    for (int i=0;i<numFingers;i++) {
      fingerPoints[i] = new PointablePoint(i,idHand, p, color(255, 0, 0));
    }
    for (int i=0;i<numTools;i++) {
      toolPoints[i] = new PointablePoint(i,idHand, p, color(0, 255, 0));
    }
  }

  void update() {
    if(record) handPath.add(p);
  }

  void draw() {
    drawDot(p, fgColor, ""+idHand);
  }

  void run() {
    update();
    draw();
  }

}

