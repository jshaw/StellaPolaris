import codeanticode.syphon.*;
import controlP5.*;

import peasy.*;
PeasyCam cam;

String blendMode[] = {"BLEND", "ADD", "SUBTRACT", "DARKEST", "LIGHTEST", 
  "DIFFERENCE", "EXCLUSION", "MULTIPLY", "SCREEN", "REPLACE"};
int blendModeIndex = 1;

int _width = 0;
int _height = 0;

World world;

// Person Values
// ==================
Person person;
float personPositionMoveValue = 5.0;
PVector personPosition = new PVector(0, 0, 0);
//float personXPosition = 0.0;
//float personZPosition = 300.0;
boolean personMoveLeft = false;
boolean personMoveRight = false;
boolean personMoveForward = false;
boolean personMoveBackward = false;

void settings() {
   size(1080, 720, P3D);

  _height = height;
  _width = width;
  
  PJOGL.profile=1;    
}

void setup()
{
  frameRate(30);
  rectMode(CENTER);
  smooth(8);
  
  person = new Person(personPosition, 400);
  world = new World(person);
  
  
  cam = new PeasyCam(this, width/2, height/2 + 200, 0, 2000);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(5000);

  gui();
}

void draw() {
  background(255);
  translate(width/2,height/2);
  
  if(personMoveLeft == true){
    personPosition.x -= personPositionMoveValue;
  } else if(personMoveRight == true) {
    personPosition.x += personPositionMoveValue;
  } else if(personMoveForward == true) {
    personPosition.z -= personPositionMoveValue;
  } else if(personMoveBackward == true) {
    personPosition.z += personPositionMoveValue;
  }
  
  person.update(personPosition);
  person.draw();
  
  world.update();
  world.draw();
}

void keyPressed(){
  println("---");
  if (key == CODED) {
    if (keyCode == LEFT) {
      personMoveLeft = true;
      println("LEFT");
    } else if (keyCode == RIGHT) {
      println("RIGHT");
      personMoveRight = true;
    } else if (keyCode == UP) {
      println("FORWARD");
      personMoveForward = true;
    } else if (keyCode == DOWN) {
      println("BACKWARD");
      personMoveBackward = true;
    }
  }
}

void keyReleased(){
  if (key == CODED) {
    if (keyCode == LEFT) {
      personMoveLeft = false;
    } else if (keyCode == RIGHT) {
      personMoveRight = false;
    } else if (keyCode == UP) {
      println("FORWARD");
      personMoveForward = false;
    } else if (keyCode == DOWN) {
      println("BACKWARD");
      personMoveBackward = false;
    }
  }
}


void gui(){

}
