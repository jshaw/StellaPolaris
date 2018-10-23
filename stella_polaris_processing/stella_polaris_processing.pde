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


ArrayList<Person> people;

// Person Values
// ==================
// Person person;
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


int lastSeen = 0;
int clearSeen = 30000;


void settings() {
   size(1080, 720, P3D);

  _height = height;
  _width = width;
  
  PJOGL.profile=1;    
}

void setup()
{
  frameRate(10);
  rectMode(CENTER);
  smooth(8);
  

  people = new ArrayList<Person>();

  // person = new Person(personPosition, 400);
  // world = new World(person);
  world = new World(people);
  
  
  cam = new PeasyCam(this, width/2, height/2 + 200, 0, 2000);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(5000);

  opc = new OPC(this, "127.0.0.1", 7890);

  wsc= new WebsocketClient(this, "ws://localhost:8080/john");
  
  // opc.ledStrip(index, count, x, y, spacing, angle, reversed)
  opc.ledStrip(0, 60, 20, 110, 3, PI/2, false);
  opc.ledStrip(64, 60, 25, 110, 3, PI/2, false);
  opc.ledStrip(128, 60, 30, 110, 3, PI/2, false);
  opc.ledStrip(192, 60, 35, 110, 3, PI/2, false);

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

  // personPosition.z = person_position;
  

  // if (show3d) {
  //   noStroke();
  //   rotateX(rotx);
  //   rotateY(roty);

  //   pushMatrix();
  //   // 32, 10 * 3, 160 * 3
  //   drawCylinder(tubeRes, imgWidth * 3, imgHeight * 3);
  //   popMatrix();
  // }
  
  for (int i = 0; i < people.size(); i++) {
    Person person = people.get(i);
    // part.display();
    // person.update(personPosition);
    person.draw();

    // println("person.isDead(): " + person.isDead());

    // if (person.isDead()) {
    //   people.remove(i);
    // }
  }

  // person.update(personPosition);
  // person.draw();

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

  lastSeen = millis();

  if(msg.length() > 10){
    println("msg.length(): " + msg.length());
    // return;
  

    // if(msg.toString() == "NaN"){
    //   return;
    // }

    // JSONObject json = parseJSONObject(msg);
    JSONArray jsonArray = parseJSONArray(msg);
    println(jsonArray.size());

    // TODO: 
    // TODO: 
    // TODO: 
    // TODO: 
    // TODO: Need to work on this
    for (int i = 0; i < jsonArray.size(); i++) {
      // jsonArray.getJSONObject(i);
      JSONObject json = jsonArray.getJSONObject(i);

      println("json: ", json);

      float rssi = json.getFloat("rssi");
      String mfd = json.getString("mfd");
      boolean active = json.getBoolean("active");
      String deviceUID = json.getString("deviceUID");
      int deviceCount = json.getInt("deviceCount");
  

      println("rssi: " + rssi);
      println("mfd: " + mfd);

      println("people.size(): " + people.size());

      if(people.size() > 0){

        int foundIndex = getIndexOfPeriferal(deviceCount);

        println("A foundIndex: ", foundIndex);
        println("A foundIndex: ", foundIndex);
        println("A foundIndex: ", foundIndex);

        if(foundIndex == -1){
          people.add(new Person(personPosition, 400, clearSeen, rssi, mfd, active, deviceUID, lastSeen, deviceCount));
        } else {

          Person tmp_person = people.get(foundIndex);

          float person_position_z = calculateDistance(rssi);
          person_position_z *= 100;

          tmp_person.personPosition.z = person_position_z;
          PVector _personPosition = tmp_person.personPosition;
          
          tmp_person.updateParams(_personPosition, rssi, mfd, active, deviceUID, deviceCount);
          tmp_person.updateLastSeen(lastSeen);
          
        }

        // for (int p = 0; p < people.size(); p++) {
        //   println("EXHISTING Person");
        //   Person person = people.get(i);

        //   float person_position_z = calculateDistance(rssi);
        //   person_position_z *= 100;


        //   if(deviceUID == person.deviceUID){
            
        //     person.personPosition.z = person_position_z;
        //     PVector _personPosition = person.personPosition;

        //     person.updateParams(_personPosition, rssi, mfd, active, deviceUID);
        //     person.updateLastSeen(lastSeen);
        //   } else {
        //     println("New Person");

        //     people.add(new Person(personPosition, 400, clearSeen, rssi, mfd, active, deviceUID, lastSeen));
        //   }
        // }

      } else {

        println("IN PEOPLE SIZE == 0");
        println("IN PEOPLE SIZE == 0");
        println("IN PEOPLE SIZE == 0");
        println("IN PEOPLE SIZE == 0");

        people.add(new Person(personPosition, 400, clearSeen, rssi, mfd, active, deviceUID, lastSeen, deviceCount));
        // people.add(new Person(personPosition, 400, 10, clearSeen, mfd, active, "deviceUID", lastSeen));
      }

      println("Get here????????");


    }


    // worked with single param being passed
    // ======

    // JSONObject json = jsonArray[0].getFloat("rssi");

    // JSONObject json = jsonArray.getJSONObject(0);
    // // float json = jsonArray.getJSONObject(0).getFloat("rssi");
    // println("json" + json);

    // float rssi = json.getFloat("rssi");
    // String active = json.getString("active");
    // String mfd = json.getString("mfd");
    // String deviceUID = json.getString("deviceUID");


    // // person_position = map(float(msg), 10.0, -99.0, 0.0, 100.0);
    // person_position = calculateDistance(rssi);

    // // person_position = max(0, min(100.0 * (-55.0 - float(msg)) / (-55.0 + 100.0), 100.0));
    // // person_position = map(person_position, 0 )
    // person_position *= 100;

    // END worked with single param being passed
    // ======




    println("person_position " + person_position);
    println("person_position " + person_position);
    println("person_position " + person_position);
    println("person_position " + person_position);
    println("person_position " + person_position);


  } // end of message check to make sure that it is longer then 10 characters

}

// https://stackoverflow.com/questions/39175557/using-indexof-with-a-customobject-in-an-arraylist
// https://stackoverflow.com/questions/42127763/indexof-for-arraylist-of-user-defined-objects-not-working

// int getIndexOfPeriferal(String periferalName) {
int getIndexOfPeriferal(int periferalName) {
  for(Person personObject : people)  {
    println("personObject: ", personObject);
    println("periferalName: ", periferalName);

    int foundIndex = people.indexOf(personObject);
    println("foundIndex, " + foundIndex);
    println("people.get(foundIndex).deviceUID: " + people.get(foundIndex).deviceUID);

    if(int(people.get(foundIndex).deviceUID) == periferalName){
      println("EVER GET IN THIS IFFFF???");
      return foundIndex;
    }

  }
  return -1; 
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