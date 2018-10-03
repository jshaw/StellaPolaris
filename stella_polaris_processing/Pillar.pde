// Pillar class that holds all of the pillars & info

class Pillar{

  PVector pillarPosition = new PVector();
  int pillarHeight;
  
  Pillar(Person _person, PVector _pillarPosition, int _pillarHeight){ 
    person = _person;
    pillarPosition = _pillarPosition;
    pillarHeight = _pillarHeight;
    
    textSize(28);
    
  }
    
  void update(PVector _pillarPosition){
    pillarPosition = _pillarPosition;
  }
  
  int tubeRes = 32;
  //int imgWidth = 8;
  //int imgHeight = 120;
  int imgWidth = 12;
  int imgHeight = 180;
  
  void draw(){
    
    pushMatrix();
      fill(0);
      translate(50, -250, 50);
      println(person.personPosition.x);
      println(person.personPosition.z);
      //text("Where this at?", pillarPosition.x, pillarPosition.y, pillarPosition.z);
      text("Distance to Person: \n" + pillarPosition.dist(person.personPosition), pillarPosition.x, pillarPosition.y, pillarPosition.z);
    popMatrix();
    
    
    pushMatrix();
      translate(pillarPosition.x, pillarPosition.y, pillarPosition.z);
      rotateX(PI/2);
      fill(220, 20);
      //box(100, pillarHeight, 20);
      //drawCylinder();
      drawCylinder(tubeRes, imgWidth * 3, imgHeight * 3);
    popMatrix();
    fill(255);
  
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
    // texture(img);
    //texture(fbo);
  
    for (int i = 0; i < sides + 1; i++) {
      float x = cos( radians( i * angle ) ) * r;
      float y = sin( radians( i * angle ) ) * r;
      // already commented out
      //float u = fbo.width / tubeRes * i;
      // END: already commented out
      
      // Use for texture mapping the shape
      // Uncomment out when it's ready to go to be worked on like that
      //float u = (float)fbo.width / (float)tubeRes * (float)i;
      //vertex( x, y, halfHeight, u, 0);
      //vertex( x, y, -halfHeight, u, fbo.height);
      
      vertex( x, y, halfHeight);
      vertex( x, y, -halfHeight);
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
