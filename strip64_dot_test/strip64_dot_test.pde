OPC opc;
PImage dot;

void setup()
{
  size(800, 200);

  // Load a sample image
  dot = loadImage("color-dot.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one 64-LED strip to the center of the window
  // opc.ledStrip(index, count, x, y, spacing, angle, reversed)
  opc.ledStrip(0, 64, width/2, height/2, width / 70.0, 0, false);
  opc.ledStrip(64, 64, width/2, height/2 + 10, width / 70.0, 1, false);
  // opc.ledStrip(128, 60, width/2, height/2 + 20, width / 70.0, PI/2, false);

  
  // opc.ledStrip(index, count, x, y, spacing, angle, reversed)
  // opc.ledStrip(127, 64, 10, 10, 10, PI/2, false);
  //opc.ledStrip(193, 64, width/2, height/2 + 30, width / 70.0, 0, false);

}

void draw()
{
  background(0);

  // Draw the image, centered at the mouse location
  float dotSize = width * 0.2;
  image(dot, mouseX - dotSize/2, mouseY - dotSize/2, dotSize, dotSize);
}
