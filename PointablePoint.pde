class PointablePoint{
  ArrayList pointablePath;
  PVector p = new PVector(0,0,0);
  int idPointable = 0;
  int idHand = 0;
  color fgColor = color(255);

  PointablePoint(int _ip, int _ih, PVector _p, color _c){
    idPointable = _ip;
    idHand = _ih;
    pointablePath = new ArrayList();
    p = _p;
    fgColor = _c;
  }
  
  void update(){
    if(record) pointablePath.add(p);
  }
  
  void draw(){
    drawDot(p, fgColor, idHand + "." + idPointable);
  }
  
  void run(){
    update();
    draw();
  }

}
