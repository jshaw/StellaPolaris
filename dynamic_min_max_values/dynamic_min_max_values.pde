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

ArrayList<Person> people;

void setup(){
  size(720, 480, P3D);
  background(200);
  frameRate(1);
  
  people = new ArrayList<Person>();
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
  
  println("Mapping Test Values: " + new_val);
   
  fill(#0000ff);
  rect(imgWidth, 75, imgHeight, 30);
  
  fill(#ff0000);
  ellipse(new_val, 90, 20, 20);
  
  fill(50);
  text("Avg. Val: " + current_distance, new_val, 130);
  text("Mapped Val: " + new_val, new_val, 150);
  
  println("average_distance " + current_distance);
  println("val_min " + val_min + "  |  " + " map_min " + map_min);
  println("val_max " + val_max + "  |  " + " map_max " + map_max);
  
  text("Min Val \n" + val_min, val_min, 20);
  text("Max Val \n" + val_max, val_max, 20);
  
  println("---------------");
  
}


void keyPressed() {
  
  int deviceUID = (int)random(0, 10);
  int rssi = (int)random(0, 500);
  
  if(people.size() > 0){
    int foundIndex = getIndexOfPeriferal(deviceUID);
  }
  
  people.add(new Person(rssi, deviceUID));
  
  
  current_distance = random(init_max, init_min);
  
  println("average_distance: ", current_distance);
  
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

int getIndexOfPeriferal(int deviceUID) {

  for(Person personObject : people)  {
    // println("personObject: ", personObject);
    // println("periferalName: ", periferalName);

    int foundIndex = people.indexOf(personObject);

    //if(int(people.get(foundIndex).deviceCount) == deviceUID){
    //  return foundIndex;
    //}

  }
  return -1; 
}
