// Pillar class that holds all of the pillars

class Person{

  PVector personPosition = new PVector();
  
  //float personXPosition;
  //float personZPosition;
  int personHeight;
  
  Person(PVector _personPosition, int _personHeight){
    personHeight = _personHeight;
    personPosition = _personPosition;
  }
    
  void update(PVector _personPosition){
    personPosition = _personPosition;
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
