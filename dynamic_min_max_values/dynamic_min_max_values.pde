//float init_min = 3000.0;
float init_min = 700.0;
float init_max = 4.0;

float val_min = init_min;
float val_max = init_max;

float map_min = init_min;
float map_max = init_max;

int imgWidth = 8;
int imgHeight = 120;

float average_distance = 0.0;
float test_val = 0;

void setup(){
  size(720, 480, P3D);
  background(200);
  frameRate(1);
}
        
void draw(){
  textSize(14);
  background(200);
  
  float new_val = map(test_val, val_min, val_max, imgWidth, imgHeight);
  println("Mapping Test Values: " + new_val);
   
  fill(#0000ff);
  rect(imgWidth, 75, imgHeight, 30);
  
  fill(#ff0000);
  ellipse(new_val, 90, 20, 20);
  
  fill(50);
  text("Avg. Val: " + average_distance, new_val, 130);
  text("Mapped Val: " + new_val, new_val, 150);
  
  println("average_distance " + average_distance);
  println("val_min " + val_min + "  |  " + " map_min " + map_min);
  println("val_max " + val_max + "  |  " + " map_max " + map_max);
  
  text("Min Val \n" + val_min, val_min, 20);
  text("Max Val \n" + val_max, val_max, 20);
  
  println("---------------");
  
}


void keyPressed() {
  average_distance = random(init_max, init_min);
    
  test_val = average_distance;
  
  println("average_distance: ", average_distance);
  
  if(average_distance < val_min){
    println("AAAAAAAAA");
    val_min = average_distance;
    map_min = map(val_min, val_min, val_max, imgWidth, imgHeight);
    println("map_min: ", map_min);
  } else {
    //map_min = map(test_val, val_min, val_max, imgWidth, imgHeight);
  }
  
  if(average_distance > val_max){
    println("BBBBBBBB");
    //map_max = constrain(average_distance, imgWidth, imgHeight);
    val_max = average_distance;
    
    map_max = map(val_max, val_min, val_max, imgWidth, imgHeight);
    println("map_max: ", map_max);
  } else {
    //map_max = map(val_max, val_min, val_max, imgWidth, imgHeight);
  }
}
