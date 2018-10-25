//float inc = 0.0005;
float inc = 0.005;
int density = 10;

//float inc = 0.005;
//int density = 8;

float znoise = 0.0;
//
//
// This is a good gradient reference too!
// https://medium.com/@behreajj/color-gradients-in-processing-v-2-0-e5c0b87cdfd2
// ------
//
// https://www.schemecolor.com/image-to-color-generator 
// https://images.mentalfloss.com/sites/default/files/styles/mf_image_16x9/public/iStock-488508586.jpg?itok=mUoGD7yg&resize=1100x1100
// https://i0.wp.com/thriftynomads.com/wp-content/uploads/2018/02/Iceland-Northern-Lights.jpg?w=412&h=232&ssl=1
// https://i0.wp.com/happenings.changirecommends.com/wp-content/uploads/2017/04/Untitled-design2-e1506326359289.png?fit=1000%2C667
// http://arctickingdom.com/wp-content/uploads/2016/08/Igloo-BLL-Under-Aurora.jpg
// https://www.northernlights.events/wp-content/uploads/2017/06/NL-trees.jpg
// https://image.iol.co.za/image/1/process/620x349?source=https://inm-baobab-prod-eu-west-1.s3.amazonaws.com/public/inm/media/image/2017/03/06/32307005NorthernLights.jpg&operation=CROP&offset=83x0&resize=1775x1000
// https://upload.wikimedia.org/wikipedia/commons/3/3f/Aurora_Borealis_I.jpg
//
//
// Used this one
// #330033 #333333 #333366 #66cc99 #663366 #993399 #336666 #003366 #6699cc #009999
// https://www.vastavalo.net/albums/userpics/18571/normal_150317-6.jpg
//
//
//
// Then used CSS to do the gradient processing instead of photoshop..
// https://css-tricks.com/css3-gradients/
// https://codepen.io/jshaw3/pen/NOezGE
//
//
//
// https://forum.processing.org/two/discussion/22551/color-gradients-in-perlin-noise
//
//

PImage image;

void setup() {
  //size(500, 500);
  size(1080, 1080);
  noStroke();
  frameRate(30);
  
  image = loadImage(dataPath("norther_lights_v3_256.png"));
}
 
void draw() {
  background(0);
   
  //float detail = map(mouseX, 0, width, 0.1, 0.6);
  //int lod = floor(map(mouseY, 0, height, 1, 40));
  //noiseDetail(lod, detail);
  
  float xnoise = 0.0;
  float ynoise = 0.0;
  for (int y = 0; y < height; y += density) {
    for (int x = 0; x < width; x += density) {
      //float n = noise(xnoise, ynoise, znoise) * 256;
      float n = noise(xnoise, ynoise, znoise) * 330;
      //println("n: " + n);
      color c = image.get((int)n, 5);
      //fill(n, 255, 255);
      //fill(c, 255, 255);
      fill(c);
      rect(y, x, density, density);
      xnoise += inc;
    }
    xnoise = 0;
    ynoise += inc;
  }
  znoise += inc;
  
  pushMatrix();
    int alpha = 40;
    float scale = map(mouseY, 0, 1000, 15, 1);
    fill(#66cc99, alpha);
    ellipse(mouseX, mouseY, 100 * scale, 100 * scale);
    
    fill(#66cc99, alpha);
    ellipse(mouseX, mouseY, 90 * scale, 90 * scale);
    
    fill(#66cc99, alpha);
    ellipse(mouseX, mouseY, 80 * scale, 80 * scale);
    
    fill(#66cc99, alpha);
    ellipse(mouseX, mouseY, 70 * scale, 70 * scale);
    
    fill(#66cc99, alpha);
    ellipse(mouseX, mouseY, 60 * scale, 60 * scale);
  popMatrix();
}
