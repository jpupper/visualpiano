class ControlFrame extends PApplet {
 
  int w, h;
  PApplet parent;
  ControlP5 cp5;
 
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }
 
  public void settings() {
    size(w, h, P3D);
  }
 
  public void setup() {
    int sep = 20;
    cp5 = new ControlP5(this);
    cp5.addSlider("RndX").setPosition(40,sep).setRange(0.0,3.0).plugTo(parent,"RndX");
    cp5.addSlider("RdmY").setPosition(40,sep*2).setRange(0,3).plugTo(parent,"RdmY");
    
  }
 
}