// Pillar class that holds all of the pillars

class Person{

  PVector personPosition = new PVector();
  float rssi;
  boolean active;
  //String deviceUID;
  int deviceUID;
  int lastSeen;
  int clearSeen = 15000;
  float personHeight = 10;

  float[] personPillarDist = new float[5];

  Person(int _rssi, int _deviceUID){
    rssi = _rssi;
    deviceUID = _deviceUID;
  }
    
  void update(PVector _personPosition){
    personPosition = _personPosition;
  }

  void updateParams(PVector _personPosition, float _rssi, String _mfd, boolean _active, String _deviceUID, int _deviceCount){
    personPosition = _personPosition;
    rssi = _rssi;
    active = _active;
    //mfd = _mfd;
    deviceUID = int(_deviceUID);
  }

  void updateLastSeen(int _lastSeen){
    lastSeen = _lastSeen;
  }

  boolean isDead() {
    // Is the person still alive?
    int currentMillis = millis();
    if ((currentMillis - lastSeen) > clearSeen) {
      return true;
    } else {
      return false;
    }
  }
  
  void draw(){
    
    pushMatrix();
      translate(personPosition.x, 0, personPosition.z); 
      fill(220, 20);
      stroke(0);
      strokeWeight(1);
      box(100, personHeight, 20);
    popMatrix();
    fill(255);
  
  }

}
