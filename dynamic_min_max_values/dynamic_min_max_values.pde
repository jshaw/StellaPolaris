//float init_min = 3000.0;
float init_min = 700.0;
float init_max = 4.0;

float val_min = init_min;
float val_max = init_max;

float map_min = init_min;
float map_max = init_max;

int imgWidth = 8;
int imgHeight = 120;

int detections = 0;

float current_distance = 0.0;

//ArrayList<Person> people;

int found_ble_index = 0;
int max_ble_array = 9;
float[] FoundBLEStrength = new float[10];



void setup(){
  size(720, 480, P3D);
  background(200);
  //frameRate(1);
  
  //people = new ArrayList<Person>();
}
        
void draw(){
  textSize(14);
  background(200);
  
  float new_val = map(current_distance, val_min, val_max, imgWidth, imgHeight);
  
  // This map function with these values are causing the issue
  //map(296.9124, 296.9124, 296.9124, 8, 120)
  
  if(Float.isNaN(new_val)){
    map_max = imgWidth;
  }
  
  drawMostRecentSignal(new_val);
  
  drawAllSignals();
  
  drawAverageSignal();
  
  drawAverageSignalAnimate();
  
}

void drawMostRecentSignal(float new_val){
  
  //println("Mapping Test Values: " + new_val);
   
  fill(#0000ff);
  rect(imgWidth, 75, imgHeight, 30);
  
  fill(#ff0000);
  ellipse(new_val, 90, 20, 20);
  
  fill(50);
  text("Avg. Val: " + current_distance, new_val, 130);
  text("Mapped Val: " + new_val, new_val, 150);
  
  //println("average_distance " + current_distance);
  //println("val_min " + val_min + "  |  " + " map_min " + map_min);
  //println("val_max " + val_max + "  |  " + " map_max " + map_max);
  
  text("Min Val \n" + val_min, val_min, 20);
  text("Max Val \n" + val_max, val_max, 20);
  
  //println("---------------");

}

void drawAllSignals(){
   
  pushMatrix();
  
    translate(0, 100);
     
    fill(#0000ff);
    rect(imgWidth, 75, imgHeight, 30);
     
    for (int i = 0; i < FoundBLEStrength.length; i++) {
      float new_val = map(FoundBLEStrength[i], val_min, val_max, imgWidth, imgHeight);
      //println("Mapping Test Values: " + new_val);  
      fill(#ff0000);
      ellipse(new_val, 90, 20, 20);
    }
  
    //fill(#ff0000);
    //ellipse(new_val, 90, 20, 20);
    
    //fill(50);
    //text("Avg. Val: " + current_distance, new_val, 130);
    //text("Mapped Val: " + new_val, new_val, 150);
    
    //println("average_distance " + current_distance);
    //println("val_min " + val_min + "  |  " + " map_min " + map_min);
    //println("val_max " + val_max + "  |  " + " map_max " + map_max);
    
    //text("Min Val \n" + val_min, val_min, 20);
    //text("Max Val \n" + val_max, val_max, 20);
    
    //println("---------------");
  popMatrix();

}

float average_val_1 = 0;

void drawAverageSignal(){
  
  pushMatrix();
  
    translate(0, 200);
     
    fill(#0000ff);
    rect(imgWidth, 75, imgHeight, 30);
    
    
     
    for (int i = 0; i < FoundBLEStrength.length; i++) {
      float new_val = map(FoundBLEStrength[i], val_min, val_max, imgWidth, imgHeight);
      //println("Mapping Test Values: " + new_val);
      average_val_1 += new_val;
      
    }
    
    //average_val_1 = average_val_1 / (max_ble_array+1), val_min, val_max );
    average_val_1 = constrain(average_val_1 / (max_ble_array+1), imgWidth, (imgWidth + imgHeight) );
    
    fill(#ff0000);
    ellipse(average_val_1, 90, 20, 20);
    
    //println("average_val_1: ", average_val_1);
    average_val_1 = 0;
  
  popMatrix();

}

float x;
float average_val_2 = 0;

void drawAverageSignalAnimate(){
  
  float easing = 0.05;
  
  pushMatrix();
  
    translate(0, 300);
     
    fill(#0000ff);
    rect(imgWidth, 75, imgHeight, 30);
    
    for (int i = 0; i < FoundBLEStrength.length; i++) {
      //float new_val = map(FoundBLEStrength[i], val_min, val_max, imgWidth, imgHeight);
      float new_val = map(FoundBLEStrength[i], val_min, val_max, imgWidth, imgHeight);
      //println("Mapping Test Values: " + new_val);
      
      average_val_2 += new_val;
      
      println("new_val: ", new_val);
      println("average_val_2: ", average_val_2);
      
    }
    
    //average_val_2 = average_val_2 / (max_ble_array+1);
    average_val_2 = constrain(average_val_2 / (max_ble_array+1), imgWidth, (imgWidth + imgHeight));
    
    float targetX = average_val_2;
    float dx = targetX - x;
    x += dx * easing;
    
    fill(#ff0000);
    //ellipse(average_val, 90, 20, 20);
    ellipse(x, 90, 20, 20);
    
    println("average_val_2: ", average_val_2);
    average_val_2 = 0;
    
  
  popMatrix();

}

void shiftAndAdd(float a[], float val){
  float a_length = a.length;
  System.arraycopy(a, 1, a, 0, (int)a_length-1);
  a[(int)a_length-1] = val;
  
  println(a);
}

void keyPressed() {
  
  int deviceUID = (int)random(0, 10);
  int rssi = (int)random(0, 500);
  
  
  if(found_ble_index < max_ble_array){
    println("found less then length");
    found_ble_index++;
  } else {
    println("reset back to 0");
    found_ble_index = 0;
  } 
   
  println("found_ble_index: " + found_ble_index);
  
  //if(people.size() > 0){
  //  int foundIndex = getIndexOfPeriferal(deviceUID);
  //} 
  //people.add(new Person(rssi, deviceUID));
 
  current_distance = random(init_max, init_min);
  
  shiftAndAdd(FoundBLEStrength, current_distance);
  
  //FoundBLEStrength[found_ble_index] = current_distance;
  
  println("current_distance: ", current_distance);
  
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

//int getIndexOfPeriferal(int deviceUID) {

//  for(Person personObject : people)  {
//    // println("personObject: ", personObject);
//    // println("periferalName: ", periferalName);

//    int foundIndex = people.indexOf(personObject);

//    //if(int(people.get(foundIndex).deviceCount) == deviceUID){
//    //  return foundIndex;
//    //}

//  }
//  return -1; 
//}
