/**
 * Noise2D 
 * by Daniel Shiffman.  
 * 
 * Using 2D noise to create simple texture. 
 */
 
float increment = 0.02;

void setup() {
  size(640, 360);
  
}

void draw() {
  background(255);
  
  loadPixels();

  float xoff = 0.0; // Start xoff at 0
  float detail = map(mouseX, 0, width, 0.1, 0.6);
  int lod = floor(map(mouseY, 0, height, 1, 40));
  noiseDetail(lod, detail);
  
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < width; x++) {
    xoff += increment;   // Increment xoff 
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < height; y++) {
      yoff += increment; // Increment yoff
      
      // Calculate noise and scale by 255
      float bright = noise(xoff, yoff) * 255;

      // Try using this line instead
      //float bright = random(0,255);
      
      // Set each pixel onscreen to a grayscale value
      //pixels[x+y*width] = color(bright);
      //pixels[x+y*width] = color(255, 0, 0, bright);
      pixels[x+y*width] = color(bright, 0, 0);
      
    }
  }
  
  updatePixels();
}
