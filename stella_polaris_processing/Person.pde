// Pillar class that holds all of the pillars

class Person{

  PVector personPosition = new PVector();
  int personHeight;
  float rssi;
  String mfd;
  boolean active;
  String deviceUID;
  int deviceCount;
  int lastSeen;

  float[] personPillarDist = new float[5];
 
  Person(PVector _personPosition, int _personHeight, int _clearSeen, float _rssi, String _mfd, boolean _active, String _deviceUID, int _lastSeen, int _deviceCount){
    personHeight = _personHeight;
    personPosition = _personPosition;
    clearSeen = _clearSeen;
    rssi = _rssi;
    active = _active;
    mfd = _mfd;
    deviceUID = _deviceUID;
    deviceCount = _deviceCount;
    lastSeen = _lastSeen;

  }
    
  void update(PVector _personPosition){
    personPosition = _personPosition;
  }

  void updateParams(PVector _personPosition, float _rssi, String _mfd, boolean _active, String _deviceUID, int _deviceCount){
    personPosition = _personPosition;
    rssi = _rssi;
    active = _active;
    mfd = _mfd;
    deviceUID = _deviceUID;
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
