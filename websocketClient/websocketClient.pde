import websockets.*;

WebsocketClient wsc;
int now;
boolean newEllipse;

void setup(){
  size(200,200);
  
  newEllipse=true;
  
  // wsc= new WebsocketClient(this, "ws://localhost:8025/john");
  wsc= new WebsocketClient(this, "ws://localhost:8080/john");
  now=millis();
}

void draw(){
  if(newEllipse){
    ellipse(random(width),random(height),10,10);
    newEllipse=false;
  }
    
  if(millis()>now+5000){
    // What to do when the connection drops???
    // How to prevent how to reconnect
    wsc.sendMessage("Client message");
    now=millis();
  }
}

void webSocketEvent(String msg){
 println("received message: " + msg);
 newEllipse=true;
}

// need to have an on clse event