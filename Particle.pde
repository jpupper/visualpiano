class Particle {

  PVector pos;
  PVector speed;
  PVector accel;

  float rdmx, rdmy;   

  float stm;

  float vibr;

  float amp;
  float angle;
  float Aspeed;

  float size;
  float bsize;
  float lifespan;
  float lifespanspeed;
  float mass;

  float topSpeed;

  color colorfig ;
  color colorStroke;

  float Bsize;
  float hue, sat, bri;
  
  int cantpoints;

  Particle(PVector _pos, 
    float _topSpeed, 
    PVector _accel, 
    float _rdmx, float _rdmy, 
    float _amp, 
    float _size, float _bsize,
    float _hue, float _sat, float _bri,
    int _cantpoints,
    float _lifespanspeed) {

    mass = 1;


    pos = _pos;
    topSpeed = _topSpeed;
    speed = new PVector(0, 0);
    accel = _accel;
    rdmx = _rdmx; 
    rdmy =_rdmy;
    size = _size;
    
    bsize = _bsize;
    cantpoints = _cantpoints;
    amp = _amp;
    Aspeed = 0.05;
    hue = _hue;
    sat = _sat;
    bri = _bri;

    lifespanspeed = _lifespanspeed;
    lifespan = 255;
    stm = 8;
  }
  void run() {

    display();
    update();
  }

  void applyForce(PVector _f) {

    _f.div(mass);
    accel.add(_f);
  }


  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(speed.heading());
    SHSBA();                 
    popMatrix();
  }


  void update() {

    //applyForce(new PVector(map(mouseX,0,width,-0.5,0.5),map(mouseY,0,height,-0.5,0.5)));
    //atractTomouse();

    addRandom(rdmx, rdmy);

    speed.add(accel);
    speed.limit(5);


    pos.add(speed);
    //angular();
    lifespan -=lifespanspeed;
  }
  void angular() {

    angle+=Aspeed;
    PVector oscilator = new PVector(sin(angle), cos(angle));
    //oscilator.normalize();
    oscilator.mult(amp);
    pos.add(oscilator);
  }
  void atractTomouse() {
    if (mousePressed) {
      PVector mouse = new PVector (mouseX, mouseY);
      PVector dir = PVector.sub(mouse, pos);

      dir.normalize();
      dir.mult(stm);
      speed.add(dir);
    }
  }

  boolean isDead() {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
  void SHSBA() {
   
    strokeWeight(bsize);
    stroke(hue, sat, bri/2, lifespan);
    fill(hue, sat, bri, lifespan);
    //star(0,0,size*2,size,15);        
    //ellipse(0, 0, size, size);
    polygon(0,0,size,cantpoints);
  }



  void polygon(float x, float y, float radius, int npoints) {
    if (npoints <= 1) {
      ellipse(x, y, size, size);
    } 
    else {
      float angle = TWO_PI / npoints;
      beginShape();
      for (float a = 0; a < TWO_PI; a += angle) {
        float sx = x + cos(a) * radius;
        float sy = y + sin(a) * radius;
        vertex(sx, sy);
      }
      endShape(CLOSE);
    }
  }


  void addRandom(float _rdmx, float _rdmy) {
    PVector rdm = PVector.random2D();
    rdm.x = rdm.x * _rdmx; 
    rdm.y = rdm.y * _rdmy;

    //rdm.normalize();

    speed.add(rdm);
  }
}