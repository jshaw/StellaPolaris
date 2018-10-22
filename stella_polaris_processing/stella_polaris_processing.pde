import codeanticode.syphon.*;
import controlP5.*;
import websockets.*;

OPC opc;
WebsocketClient wsc;
int now;

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

float rotx = PI/4;
float roty = PI/4;

float person_position = 0;

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

  opc = new OPC(this, "127.0.0.1", 7890);

  wsc= new WebsocketClient(this, "ws://localhost:8080/john");
  

  // opc.ledStrip(index, count, x, y, spacing, angle, reversed)
  // opc.ledStrip(0, 64, width/2, height/2, width / 70.0, 0, false);
  // opc.ledStrip(64, 64, width/2, height/2 + 10, width / 70.0, 0, false);
  // opc.ledStrip(128, 60, width/2, height/2 + 10, width / 70.0, PI/2, false);

  // opc.ledStrip(0, 64, width/2, height/2, width / 70.0, 0, false);
  // opc.ledStrip(64, 64, width/2, height/2 + 10, width / 70.0, 0, false);

  opc.ledStrip(0, 64, 200, 200, 10, 0, false);
  opc.ledStrip(64, 64, 200, 200 + 10, 10, 0, false);

  // opc.ledStrip(0, 64, 20, 20, 10, PI/2, false);
  // opc.ledStrip(64, 64, 25, 25, 10, PI/2, false);

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

  personPosition.z = person_position;
  

  // if (show3d) {
  //   noStroke();
  //   rotateX(rotx);
  //   rotateY(roty);

  //   pushMatrix();
  //   // 32, 10 * 3, 160 * 3
  //   drawCylinder(tubeRes, imgWidth * 3, imgHeight * 3);
  //   popMatrix();
  // }
  
  person.update(personPosition);
  person.draw();

  world.update();
  world.draw();

  cam.beginHUD();
    // now draw things that you want relative to the camera's position and orientation
  cam.endHUD();

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

void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}

void gui(){

}

void webSocketEvent(String msg){
  println("received message: " + msg);
  println("received message: " + msg);
  println("received message: " + float(msg));

  if(msg.length() < 10){
    return;
  }

  // JSONObject json = parseJSONObject(msg);
  JSONArray jsonArray = parseJSONArray(msg);
  println(jsonArray.size());

  // TODO: 
  // TODO: 
  // TODO: 
  // TODO: 
  // TODO: Need to work on this
  for (int i = 0; i < jsonArray.size(); i++) {
    jsonArray.getJSONObject(i);
  }

  // JSONObject json = jsonArray[0].getFloat("rssi");
  JSONObject json = jsonArray.getJSONObject(0);
  // float json = jsonArray.getJSONObject(0).getFloat("rssi");
  println("json" + json);

  float rssi = json.getFloat("rssi");


  // person_position = map(float(msg), 10.0, -99.0, 0.0, 100.0);
  person_position = calculateDistance(rssi);

  // person_position = max(0, min(100.0 * (-55.0 - float(msg)) / (-55.0 + 100.0), 100.0));
  // person_position = map(person_position, 0 )
  person_position *= 100;

  println("person_position " + person_position);
  println("person_position " + person_position);
  println("person_position " + person_position);
  println("person_position " + person_position);
  println("person_position " + person_position);
}

// https://stackoverflow.com/questions/20416218/understanding-ibeacon-distancing/20434019#20434019
float calculateDistance(float rssi) {
  
  //hard coded power value. Usually ranges between -59 to -65
  float txPower = -59;
  
  if (rssi == 0) {
    return -1.0; 
  }

  float ratio = rssi*1.0/txPower;
  if (ratio < 1.0) {
    return (float)Math.pow(ratio, 10);
  } else {
    double distance = (0.89976)*Math.pow(ratio,7.7095) + 0.111;    

    return (float)distance;
  }
} 