import themidibus.*; //Import the library //<>//
import controlP5.*;
import spout.*;

MidiBus myBus; // The MidiBus
//ControlFrame cf;
//ControlP5 cp5;


//SPOUT
Spout spout;
String sendername;
String[] controlName;
int[] controlType;
float[] controlValue;
String[] controlText;
String UserText = "";



boolean BGrefresh = true, allKeys = false, PosRandom = false;

int amount = 10, polygonedges = 5;
float size  = 150, topSpeed = 5, aceleracion = 1, rdm = 30, border = 1, sat = 150, bri = 150, life = 5;




int channel, pitch, velocity;



float RndX, RdmY;
float ang, angspeed;
int sliderValue = 100;

ArrayList<Particle> particles;
void settings() {
  //fullScreen();
  size(1200, 600, P3D);
}
void setup() {

  colorMode(HSB);

  // size(1200, 800);
  background(0);

  particles = new ArrayList<Particle>();
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 3); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  angspeed = 2;
  //spout = new Spout(this);
  iniciarspout();
  hint(DISABLE_OPTIMIZED_STROKE);
}

void draw() {
  ControlesSpout();
  ang+=angspeed;
  if (BGrefresh) {
    background(0);
  }

  /*
   text("CHANNEL"+channel,10,10);
   text("Pitch"+pitch,10,100);
   text("velocity"+velocity,10,150);*/



  for (int i =particles.size()-1; i>=0; i--) {
    Particle p = particles.get(i);  
    p.run();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
  spout.sendTexture();

  fill(255);
  textSize(15);
  text("frameRate "+frameRate, 10, 50);
}
void mousePressed() {
}

void noteOn(int _channel, int _pitch, int _velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  //showMidivalues(_channel,_pitch,_velocity);


  channel = _channel;
  pitch = _pitch;
  velocity = _velocity;
  Addparticles(amount); 


  println("pitch", _pitch);
  println("pitch-35", _pitch-35);
  println("NOTA ", (pitch - 36)  % 12);
}

void noteOff(int _channel, int _pitch, int _velocity) {

  // Receive a noteOff
  /*println();
   println("Note Off:");
   println("--------");
   showMidivalues(_channel,_pitch,_velocity);*/


  channel = _channel;
  pitch = _pitch;
  // velocity = _velocity;
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange

  println();
  println("Controller Change:");
  println("--------");

  showMidivalues(channel, number, value);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}


void showMidivalues(int _channel, int _pitch, int _velocity) {

  println("Channel:"+_channel);
  println("Pitch:"+_pitch);
  println("Velocity:"+_velocity);
}

void slider(float var) {
  //myColor = color(theColor);
  println("A slider event");
}

void Addparticles(int cantp) {
  
  float rdmx, rdmy;
  float Psize = map(velocity, 1, 127, 3, size) ;

  for (int x=0; x<cantp; x++) {
    if (allKeys) {
      rdmx = sin(map(x, 0, cantp, 0, TWO_PI)+ang) * map((pitch - 36), 0, 60, 0, 200);
      rdmy = cos(map(x, 0, cantp, 0, TWO_PI)+ang) * map((pitch - 36), 0, 60, 0, 200);
    } else {
      rdmx = sin(map(x, 0, cantp, 0, TWO_PI)+ang) * map((pitch - 36)  % 12, 0, 12, 0, 200);
      rdmy = cos(map(x, 0, cantp, 0, TWO_PI)+ang) * map((pitch - 36)  % 12, 0, 12, 0, 200);
    }

    PVector pos;
    if (PosRandom) {
      pos = new PVector(random(width), random(height));
    } else {
      pos = new PVector(width/2 + rdmx, height/2 + rdmy);
    }
    
    particles.add(new Particle(pos, 
      topSpeed, 
      new PVector(random(-aceleracion, aceleracion), random(-aceleracion, aceleracion)), 
      rdm, rdm, 
      0, 
      Psize, border, 
      map((pitch - 36) % 12, 0, 12, 0, 255), sat, bri, 
      polygonedges, life));
  }
}