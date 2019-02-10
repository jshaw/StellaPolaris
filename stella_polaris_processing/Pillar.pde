// Pillar class that holds all of the pillars & info

class Pillar{

  PVector pillarPosition = new PVector();
  int pillarHeight;
  PGraphics fbo;
  int index;
  
  int tubeRes = 32;
  int imgWidth = 8;
  int imgHeight = 120;

  float globalDist = 0;

  float average_distance = 0;


  float inc = 0.003;
  int density = 8;

  float znoise = random(0,1);

  float[] people;

  float x;
  float targetX;
  float dx;
  float easing = 0.05;

  PImage image;

  color[] colors = {#330033, #333333, #333366, #66cc99, #663366, #993399, #336666, #003366, #6699cc, #009999};

  int color_index = (int)random(0, colors.length);
  int alpha = 40;
  float scale = 0.95;
  
  // Pillar(int _i, Person _person, PVector _pillarPosition, int _pillarHeight){ 
  // Pillar(int _i, PImage _image, ArrayList _people, PVector _pillarPosition, int _pillarHeight){ 
    Pillar(int _i, PImage _image, float[] _people, PVector _pillarPosition, int _pillarHeight){ 
    index = _i;
    people = _people;
    pillarPosition = _pillarPosition;
    pillarHeight = _pillarHeight;
    
    textSize(28);
    
    fbo = createGraphics(imgWidth, imgHeight);

    image = _image;
    
  }
    
  float average_val;
  float val;
  int angle = 0;
  float r;
  float f_color;

  void update(float[] _people){
    people = _people;

    // int peopleSize = people.size();
    int peopleSize = people.length;

    println(val_min);
    println(val_max);
    //println(imgWidth);
    //println(imgHeight);

    angle += 1;
    val = cos(radians(angle)) * 20;
    
    for (int i = 0; i < peopleSize; i++) {

      // println("people[i]: ", people[i]);
      float new_val = map(people[i], val_min, val_max, imgWidth, imgHeight);
      average_val += new_val;
    }

    average_val = constrain( (average_val / (peopleSize)), imgWidth, (imgWidth + imgHeight) );

    targetX = average_val;
    dx = targetX - x;
    x += dx * easing;

    println("average_val: " + average_val);
    println("==============");

  }
    
  void draw(){   
    
    fill(255);
    
    // helping to convert over for updates
    average_distance = average_val;

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
            // float n = noise(xnoise, ynoise, znoise) * 150;
            float n = noise(xnoise, ynoise, znoise) * 120;
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

        // float y_pos = average_distance;

        // this is for the animation between new points
        float y_pos = x;
        // float ellipse_size = map((int)average_distance, val_min, val_max, imgWidth, imgHeight);
        float ellipse_size = map((int)average_distance, val_min, val_max, 30, 600);

        println("ellipse_size: " + ellipse_size);
        // println(people);
        println("");

        // Parameters  
        // a float: x-coordinate of the ellipse
        // b float: y-coordinate of the ellipse
        // c float: width of the ellipse by default
        // d float: height of the ellipse by default

        fbo.fill(colors[color_index], alpha);

        // to pulse the disk
        float tmp_val = abs(val);
        int e_size = (int)ellipse_size + (int)tmp_val; 

        //println("e_size: ", e_size);

        fbo.ellipse(4, y_pos, e_size, e_size);

        e_size = (int)(ellipse_size * scale);
        fbo.ellipse(4, y_pos, e_size, e_size);

        scale -= 0.1;

        e_size = (int)(ellipse_size * scale);
        fbo.ellipse(4, y_pos, e_size, e_size);

        scale -= 0.1;

        e_size = (int)(ellipse_size * scale);
        fbo.ellipse(4, y_pos, e_size, e_size);

        scale -= 0.1;

        e_size = (int)(ellipse_size * scale);
        fbo.ellipse(4, y_pos, e_size, e_size);

        scale = 0.95;

      popMatrix();

      // int peopleSize = people.size();
      int peopleSize = people.length;

      for (int i = 0; i < peopleSize; i++) {
        float new_val = map(people[i], val_min, val_max, imgWidth, imgHeight);

        // println("Mapping Test Values: " + new_val);  
        fbo.fill(#ff0000);
        fbo.ellipse(4, new_val, 1, 1);
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
