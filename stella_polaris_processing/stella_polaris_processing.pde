import codeanticode.syphon.*;

// https://github.com/TakahikoKawasaki/nv-websocket-client
// https://mvnrepository.com/artifact/com.neovisionaries/nv-websocket-client/1.4

import java.io.*;
import com.neovisionaries.ws.client.*;

import java.util.Map;
import java.util.List;

OPC opc;
WebSocket ws;
WebSocketFactory factory;

boolean wsConnected = false;

int now;

import peasy.*;
PeasyCam cam;

String blendMode[] = {"BLEND", "ADD", "SUBTRACT", "DARKEST", "LIGHTEST", 
  "DIFFERENCE", "EXCLUSION", "MULTIPLY", "SCREEN", "REPLACE"};
int blendModeIndex = 0;

int _width = 0;
int _height = 0;

World world;

ArrayList<Person> people;

// =========
// =========
// =========
// =========
// =========
// =========

//float init_min = 3000.0;
// float init_min = 700.0;
// float init_max = 4.0;

float init_min = 5000.0;
float init_max = 0;

float val_min = init_min;
float val_max = init_max;

float map_min = init_min;
float map_max = init_max;

int detections = 0;

float current_distance = 0.0;

int imgWidth = 8;
int imgHeight = 120;

int found_ble_index = 0;
int max_ble_array = 9;
float[] FoundBLEStrength = new float[10];

// =========
// =========
// =========
// =========
// =========
// =========

// Person Values
// ==================
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
  // size(1080, 720, P3D);
  size(720, 480, P3D);

  _height = height;
  _width = width;
  
}

void setup()
{
  frameRate(15);
  rectMode(CENTER);
  smooth(8);
  
  blendMode(blendModeIndex);
  
  perspective(PI/3.0,(float)width/height,1,100000);

  // people = new ArrayList<Person>();
  // world = new World(people);

  // people = new ArrayList<Person>();
  world = new World(FoundBLEStrength);
  
  
  cam = new PeasyCam(this, width/2, height/2 + 200, 0, 2000);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(5000);

  opc = new OPC(this, "127.0.0.1", 7890);

  // Integrate a better WebSocket library for communication and error handlging
  openWebSocket("ws://localhost:8080/stella");
  
  //opc.setColorCorrection(2.5, 0.75, 0.75, 0.75);
  //opc.setColorCorrection(2.5, 0.5, 0.5, 0.5);

  
  // opc.ledStrip(index, count, x, y, spacing, angle, reversed)
  //opc.ledStrip(0, 60, 22, 139, 4, PI/2, false);
  //opc.ledStrip(64, 60, 25, 139, 4, PI/2, false);
  //opc.ledStrip(128, 60, 30, 139, 4, PI/2, false);
  //opc.ledStrip(192, 60, 33, 139, 4, PI/2, false);



  // for Pillar #5
  // Currently a little funny
  opc.ledStrip(0, 60, 21, 139, 4, PI/2, false);
  // opc.ledStrip(256, 60, 25, 139, 4, PI/2, false);
  opc.ledStrip(320, 60, 25, 139, 4, PI/2, false);
  // opc.ledStrip(384, 60, 25, 139, 4, PI/2, false);
  // opc.ledStrip(444, 60, 25, 139, 4, PI/2, false);
  opc.ledStrip(128, 60, 30, 139, 4, PI/2, false);
  opc.ledStrip(192, 60, 34, 139, 4, PI/2, false);
  // opc.ledStrip(444, 60, 34, 139, 4, PI/2, false);

  // gui();
}

// https://github.com/TakahikoKawasaki/nv-websocket-client
// https://takahikokawasaki.github.io/nv-websocket-client/com/neovisionaries/ws/client/WebSocketListener.html#onConnected-com.neovisionaries.ws.client.WebSocket-java.util.Map-
// https://mvnrepository.com/artifact/com.neovisionaries/nv-websocket-client/1.4

// REALLY HELPFUL FOR PROCESSING INTEGRATION
// https://www.programcreek.com/java-api-examples/?api=com.neovisionaries.ws.client.WebSocket

private void openWebSocket(String url) {
    try {
        ws = new WebSocketFactory().createSocket(url).addListener(new WebSocketAdapter() {
            @Override
            public void onTextMessage(WebSocket websocket, String message) {
                println("message: ", message);
                webSocketEvent(message);
            }
            
            @Override
            public void onConnected(WebSocket websocket, Map<String,List<String>> headers) {
                // Received a text message.
                wsConnected = true;
            }
            
            @Override
            public void onDisconnected(WebSocket websocket, WebSocketFrame serverCloseFrame, WebSocketFrame clientCloseFrame, boolean closedByServer) {
                // Received a text message.
                wsConnected = false;
            }
        }).connect();
    } catch (Exception ignored) {
      wsConnected = false;
    }
}


void draw() {
  background(255);
  translate(width/2,height/2);

  if(wsConnected == false){
    openWebSocket("ws://localhost:8080/stella");
  }
  
  // if(personMoveLeft == true){
  //   personPosition.x -= personPositionMoveValue;
  // } else if(personMoveRight == true) {
  //   personPosition.x += personPositionMoveValue;
  // } else if(personMoveForward == true) {
  //   personPosition.z -= personPositionMoveValue;
  // } else if(personMoveBackward == true) {
  //   personPosition.z += personPositionMoveValue;
  // }

  
  // This was for controlling a single person and their position
  // personPosition.z = person_position;
  

  world.update();
  world.draw();

  cam.beginHUD();
    // now draw things that you want relative to the camera's position and orientation
    pushMatrix();    
      fill(0);
      rect(0, 0, 500, 80);
    popMatrix();
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

  generateTestReading();
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

void generateTestReading() {
  //int deviceUID = (int)random(0, 10);
  //int rssi = (int)random(0, 500);
  
  
  if(found_ble_index < max_ble_array){
    println("found less then length");
    found_ble_index++;
  } else {
    println("reset back to 0");
    found_ble_index = 0;
  } 
   
  println("found_ble_index: " + found_ble_index);
   
  current_distance = random(init_max, init_min);
  
  shiftAndAdd(FoundBLEStrength, current_distance);
  
  //FoundBLEStrength[found_ble_index] = current_distance;
  
  // println("current_distance: ", current_distance);
  
  if(current_distance < val_min){
    println("AAAAAAAAA");
    val_min = current_distance;
    
    if(detections < 2){
      val_min += 2;      
      map_min += 2;
    }
    
    map_min = map(val_min, val_min, val_max, imgWidth, imgHeight);
    println("map_min: ", map_min);
  } else {
    //map_min = map(test_val, val_min, val_max, imgWidth, imgHeight);
  }
  
  if(current_distance > val_max){
    println("BBBBBBBB");
    //map_max = constrain(average_distance, imgWidth, imgHeight);
    val_max = current_distance;
    
    map_max = map(val_max, val_min, val_max, imgWidth, imgHeight);
    println("map_max: ", map_max);
    
    if(detections < 2){
      val_max -= 2;
      map_max -= 2;
    }
    
  } else {
    //map_max = map(val_max, val_min, val_max, imgWidth, imgHeight);
  }
  
  if(detections < 2){
    val_min += 2;
    val_max -= 2;
    
    map_min += 2;
    map_max -= 2;
  
  }
  
  detections++;
}

void shiftAndAdd(float a[], float val){
  float a_length = a.length;
  System.arraycopy(a, 1, a, 0, (int)a_length-1);
  a[(int)a_length-1] = val;
  
  // println(a);
}

void webSocketEvent(String msg){
  println("received message: " + msg);

  lastSeen = millis();

  if(msg.length() > 10){
    
    JSONArray jsonArray = parseJSONArray(msg);
    println(jsonArray.size());

    println("jsonArray: ", jsonArray);

    // TODO: 
    // TODO: 
    // TODO: 
    // TODO: 
    // TODO: Need to work on this
    for (int i = 0; i < jsonArray.size(); i++) {
      
      if(found_ble_index < max_ble_array){
        //println("found less then length");
        found_ble_index++;
      } else {
        //println("reset back to 0");
        found_ble_index = 0;
      } 
      
      JSONObject json = jsonArray.getJSONObject(i);

      //println("json: ", json);

      float rssi = json.getFloat("rssi");
      //String mfd = json.getString("mfd");
      //boolean active = json.getBoolean("active");
      //String deviceUID = json.getString("deviceUID");
      //int deviceCount = json.getInt("deviceCount");

      float person_position_z = calculateDistance(rssi);
      person_position_z *= 100;
      
      println("person_position_z: ", person_position_z);

      shiftAndAdd(FoundBLEStrength, person_position_z);

      current_distance = person_position_z;

      if(current_distance > 0){
      
        if(current_distance < val_min){
          //println("AAAAAAAAA");
          val_min = current_distance;
          
          if(detections < 2){
            val_min += 2;      
            map_min += 2;
          }
                   
          map_min = map(val_min, val_min, val_max, imgWidth, imgHeight);
          println("map_min: ", map_min);
        } else {
          //map_min = map(test_val, val_min, val_max, imgWidth, imgHeight);
        }
        
        if(current_distance > val_max){
          //println("BBBBBBBB");
          //map_max = constrain(average_distance, imgWidth, imgHeight);
          val_max = current_distance;
          
          //println(" 222222222222222222222222 ");
          map_max = map(val_max, val_min, val_max, imgWidth, imgHeight);
          println("map_max: ", map_max);
          
          if(detections < 2){
            val_max -= 2;
            map_max -= 2;
          }
          
        } else {
          //map_max = map(val_max, val_min, val_max, imgWidth, imgHeight);
        }
      }
      
      if(detections < 2){
        val_min += 2;
        val_max -= 2;
        
        map_min += 2;
        map_max -= 2;
      
      }
      
      detections++;
  
    }

  } // end of message check to make sure that it is longer then 10 characters

}

// https://stackoverflow.com/questions/39175557/using-indexof-with-a-customobject-in-an-arraylist
// https://stackoverflow.com/questions/42127763/indexof-for-arraylist-of-user-defined-objects-not-working

// int getIndexOfPeriferal(int periferalName) {

//   for(Person personObject : people)  {
//     // println("personObject: ", personObject);
//     // println("periferalName: ", periferalName);

//     int foundIndex = people.indexOf(personObject);

//       if(int(people.get(foundIndex).deviceCount) == periferalName){
//       return foundIndex;
//     }

//   }
//   return -1; 
// }


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
