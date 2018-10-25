// World class that holds all of the Pillars

class World{

  ArrayList people;
  int num_pillars = 5;
  
  Pillar[] pillar = new Pillar[5];
  PVector[] pillar_config = new PVector[num_pillars];
  PImage image = loadImage(dataPath("norther_lights_v3_120_verticle_white_v3.png"));;
  
  World(ArrayList _people){
    people = _people;
    
    pillar_config[0] = new PVector(0, -180, -400);
    pillar_config[1] = new PVector(600, -180, -100);
    pillar_config[2] = new PVector(400, -180, 400);
    pillar_config[3] = new PVector(-400, -180, 400);
    pillar_config[4] = new PVector(-600, -180, -100);
  
    int i;
    for (i = 0; i < num_pillars; i++) {
      // println("i: " + i);
      // pillar[i] = new Pillar(i, person, pillar_config[i], 180);
      pillar[i] = new Pillar(i, image, people, pillar_config[i], 180);
    }

  }
    
  void update(){
    
    // println();
  
  }
  
  void draw(){
    
    int i;
    for (i = 0; i < num_pillars; i++) {
      pillar[i].update(people);
      pillar[i].draw();
    }  
  }
}
