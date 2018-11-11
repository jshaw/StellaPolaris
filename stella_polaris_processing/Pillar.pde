// Pillar class that holds all of the pillars & info

class Pillar{

  PVector pillarPosition = new PVector();
  int pillarHeight;
  PGraphics fbo;
  int index;
  
  int tubeRes = 32;
  int imgWidth = 8;
  int imgHeight = 120;
  //int imgWidth = 12;
  //int imgHeight = 180;

  float globalDist = 0;

  float average_distance = 0;


  float inc = 0.003;
  int density = 8;

  //float inc = 0.005;
  //int density = 8;
  
  float znoise = random(0,1);
  PImage image;

  color[] colors = {#330033, #333333, #333366, #66cc99, #663366, #993399, #336666, #003366, #6699cc, #009999};

  int color_index = (int)random(0, colors.length);
  int alpha = 40;
  float scale = 0.95;
  
  Pillar(int _i, PImage _image, ArrayList _people, PVector _pillarPosition, int _pillarHeight){ 
    index = _i;
    people = _people;
    pillarPosition = _pillarPosition;
    pillarHeight = _pillarHeight;
    
    textSize(28);
    fbo = createGraphics(imgWidth, imgHeight);
    image = _image;
    
  }
    
  void update(ArrayList _people){
    people = _people;

    int peopleSize = people.size();

    globalDist = 0;

    for (int p = 0; p < peopleSize; p++) {
      Person person = people.get(p);

      globalDist += pillarPosition.dist(person.personPosition);

      float dist = pillarPosition.dist(person.personPosition);

      // here, the index is used as the pillar index
      // so each Person has a array to store the distance to 
      // one of the 5 pillars
      person.personPillarDist[index] = dist;

      average_distance = globalDist / peopleSize;

      // float person_position_z = calculateDistance(rssi);
      // person_position_z *= 100;


      // if(deviceUID == person.deviceUID){
        
      //   person.personPosition.z = person_position_z;
      //   PVector _personPosition = person.personPosition;

      //   person.updateParams(_personPosition, rssi, mfd, active, deviceUID);
      //   person.updateLastSeen(lastSeen);
      // } else {
      //   people.add(new Person(personPosition, 400, clearSeen, rssi, mfd, active, deviceUID, lastSeen);
      // }
    }
  }
  

  float r;
  float f_color;
  
  void draw(){

    // int peopleSize = people.size();
    // int data_height = peopleSize * 30;

    // for (int p = 0; p < peopleSize; p++) {
    //   Person person = people.get(p);

    //   pushMatrix();
    //     fill(0);
    //     translate(50, -250, 50);
        
    //     pushMatrix();
    //       noFill();
    //       translate(-50, 0, -50);
    //       translate(pillarPosition.x, pillarPosition.y, pillarPosition.z);
    //       rotateX(PI/2);

    //       // here, the index is used as the pillar index
    //       // so each Person has a array to store the distance to 
    //       // one of the 5 pillars
    //       drawProximityCircle(person.personPillarDist[index], imgWidth * 3, 550);
    //     popMatrix();
        
    //     // a float: x-coordinate of the rectangle by default
    //     // b float: y-coordinate of the rectangle by default
    //     // c float: width of the rectangle by default
    //     // d float: height of the rectangle by default

    //     pushMatrix();
    //       translate(pillarPosition.x - 10, pillarPosition.y - 25, pillarPosition.z - 2);
    //       fill(255, 255, 255);
    //       stroke(0, 0, 0);
    //       // rect(pillarPosition.x, pillarPosition.y, 200, 500);
    //       rectMode(CORNER);

    //       rect(0, 0, 350, data_height);
    //       // box(100, 200, 1);
    //       fill(0, 0, 0);
    //       stroke(0, 0, 0);
    //     popMatrix();
    //     text("Distance:" + pillarPosition.dist(person.personPosition), pillarPosition.x, pillarPosition.y + (p * 25), pillarPosition.z);
    //   popMatrix();

    // }

    // pushMatrix();
    //   fill(0);
    //   translate(50, -250, 50);
    //   // println(person.personPosition.x);
    //   // println(person.personPosition.z);
    //   // float dist = pillarPosition.dist(person.personPosition);
      
    //   pushMatrix();
    //     noFill();
    //     translate(-50, 0, -50);
    //     translate(pillarPosition.x, pillarPosition.y, pillarPosition.z);
    //     rotateX(PI/2);
    //     // drawProximityCircle(dist, imgWidth * 3, 550);
    //     drawProximityCircle(average_distance, imgWidth * 3, 550);
    //   popMatrix();
      
    //   text("Distance to Person: \n" + pillarPosition.dist(person.personPosition), pillarPosition.x, pillarPosition.y, pillarPosition.z);
    // popMatrix();
    
    
    fill(255);
    
    int y = 20 + (index * 30);

    fbo.beginDraw();

      fbo.colorMode(RGB);

      fbo.background(0, 0, 0, 255);
      pushMatrix();

        f_color = map((int)average_distance, 180, 1500, 0, 255);

        float xnoise = 0.0;
        float ynoise = 0.0;
        int nw = fbo.width;
        int nh = fbo.height;
        for (int ny = 0; ny < nw; ny += density) {
          for (int nx = 0; nx < nh; nx += density) {
            float n = noise(xnoise, ynoise, znoise) * 150;
            color c = image.get(4, (int)n);
            fbo.noStroke();
            fbo.fill(c);
            fbo.rect(ny, nx, density, density);
            xnoise += inc;
          }
          xnoise = 0;
          ynoise += inc;
        }
        znoise += inc;


        // println("average_distance: " + average_distance);

        float y_pos = map((int)average_distance, 300, 1500, imgWidth, imgHeight);

        // println("y_pos: " + y_pos);

        float ellipse_size = map((int)average_distance, 300, 1500, imgWidth, imgWidth * 10);

        //println("ellipse_size: " + ellipse_size);
        //println("");
        // println("ellipse_size" + ellipse_size);
        // println("ellipse_size" + ellipse_size);

        // Parameters  
        // a float: x-coordinate of the ellipse
        // b float: y-coordinate of the ellipse
        // c float: width of the ellipse by default
        // d float: height of the ellipse by default

        fbo.fill(colors[color_index], alpha);
        int e_size = (int)ellipse_size;

        fbo.ellipse(4, y_pos, e_size, e_size);

        e_size = (int)(ellipse_size * scale);
        fbo.ellipse(4, y_pos, e_size, e_size);

        e_size = (int)(ellipse_size * scale);
        fbo.ellipse(4, y_pos, e_size, e_size);

        e_size = (int)(ellipse_size * scale);
        fbo.ellipse(4, y_pos, e_size, e_size);

        e_size = (int)(ellipse_size * scale);
        fbo.ellipse(4, y_pos, e_size, e_size);

      popMatrix();

      int peopleSize = people.size();
      int data_height = peopleSize * 30;

      for (int p = 0; p < peopleSize; p++) {
        Person person = people.get(p);

        pushMatrix();
          fill(0);
          translate(50, -250, 50);
          
          pushMatrix();
            noFill();
            translate(-50, 0, -50);
            translate(pillarPosition.x, pillarPosition.y, pillarPosition.z);
            rotateX(PI/2);

            // here, the index is used as the pillar index
            // so each Person has a array to store the distance to 
            // one of the 5 pillars
            
            // 
            // 
            // 
            // 
            // 
            // NOTE NOTE NOTE NOTE NOTE NOTE
            // NOTE NOTE NOTE NOTE NOTE NOTE
            // =================
            // THIS IS THE PROXIMITY CIRCLE DAWS
            //drawProximityCircle(person.personPillarDist[index], imgWidth * 3, 550);
            
            //
            //
            //
            //
            //
            //
            //
            //
            
          
          
          popMatrix();
          
          // a float: x-coordinate of the rectangle by default
          // b float: y-coordinate of the rectangle by default
          // c float: width of the rectangle by default
          // d float: height of the rectangle by default

          pushMatrix();
            translate(pillarPosition.x - 10, pillarPosition.y - 25, pillarPosition.z - 2);
            fill(255, 255, 255);
            stroke(0, 0, 0);
            // rect(pillarPosition.x, pillarPosition.y, 200, 500);
            rectMode(CORNER);

            rect(0, 0, 350, data_height);
            // box(100, 200, 1);
            fill(0, 0, 0);
            stroke(0, 0, 0);
          popMatrix();
          text("Distance:" + pillarPosition.dist(person.personPosition), pillarPosition.x, pillarPosition.y + (p * 25), pillarPosition.z);
        popMatrix();

      }

    fbo.endDraw();

    texturePillars();

    cam.beginHUD();
      image(fbo, 20 + index * (imgWidth * 3 ) , 20, imgWidth * 2, imgHeight * 2);
    cam.endHUD();
  
  }

  void texturePillars(){
    pushMatrix();
      translate(pillarPosition.x, pillarPosition.y, pillarPosition.z);
      rotateX(PI/2);
      fill(220, 20);
      //box(100, pillarHeight, 20);
      //drawCylinder();
      noStroke();
      // drawCylinder(tubeRes, imgWidth * 3, imgHeight * 3);
      drawCylinder(tubeRes, imgWidth * 3, imgHeight * 3);
      stroke(0);
      strokeWeight(1);
    popMatrix();
  }
  
  void drawProximityCircle(float _dist, float sides, float h){
    float angle = 360.0 / (float)sides;
    float halfHeight = h / 2;
    
    r = _dist - 140;
    // draw proximity between person and pillar  
    beginShape();
    for (int i = 0; i <= sides; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex(x, y, -halfHeight);
    }
    endShape(CLOSE);
  
  }
   
  void drawCylinder( int sides, float r, float h) {
    float angle = 360.0 / (float)sides;
    float halfHeight = h / 2;

  
    // draw top + bottom of the tube
    drawEnds(halfHeight, angle, sides, r, h);
  
    // draw sides
    beginShape(TRIANGLE_STRIP);
  
    // Texture the cylinder
    // Use img for debugging image mapping w/ a static image 
    texture(fbo);
    
  
    for (int i = 0; i < sides + 1; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      float u = (float)fbo.width / (float)tubeRes * (float)i;

      vertex( x, y, halfHeight, u, 0);
      vertex( x, y, -halfHeight, u, fbo.height);

    }
    endShape(CLOSE);
  }
  
  void drawEnds(float halfHeight, float angle, int sides, float r, float h) {
    // draw top of the tube  
    beginShape();
    for (int i = 0; i <= sides; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( x, y, -halfHeight);
    }
    endShape(CLOSE);
  
    // draw bottom of the tube
    beginShape();
    for (int i = 0; i < sides; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      vertex( x, y, halfHeight);
    }
    endShape(CLOSE);
  }


}
