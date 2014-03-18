PShape s, s2;

boolean fitImageToWidth = true; // true: fits image to width, false: fits image to height
float fitScale = 0;
float extraScale = 0;
float totalScale = 0;
float xCanvasOffset = 0; // 1.0 moves 100% x canvas
float yCanvasOffset = 0.35; // 1.0 moves 100% y canvas

int xMovementRange = 15;
int yMovementRange = 6;

int xRandomRange = 15;
int yRandomRange = 15;

int canvasXMovementRange = 10;
int canvasYMovementRange = 5;

float movementIncrement = TWO_PI/400; // divisions of 2*pi for use in sin()
float randomIncrement = TWO_PI/250; // divisions of 2*pi for use in sin()

int vertexChildren = 0;

float[] randomMovementX;
float[] randomMovementY;

boolean doRecord = false;

void setup() {
  frameRate(30);
  //size(1280, 720); // 720p
  size(854, 480); // 480p
  //size(640, 360); // 360p
  
  // black BG
  background(0);
  
  // The file must be in the data folder
  s = loadShape("MartinVanBuren.svg");
  s2 = loadShape("MartinVanBuren.svg"); // loading the same shape twice to create duplicate object (another solution?)
  
  vertexChildren = s.getChild(0).getChildCount();
  generateRandomised();

  shapeMode(CENTER);
  
}

void generateRandomised() {
  randomMovementX = new float[vertexChildren];
  randomMovementY = new float[vertexChildren];
  
  // generate a random factor for each shape in illustration
  for (int i = 0; i < vertexChildren; i++) {
    randomMovementX[i] = random(-xRandomRange,xRandomRange);
    randomMovementY[i] = random(-yRandomRange,yRandomRange);
  }
}

void draw() {
  
  for (int i = 0; i < vertexChildren; i++) {
    // randomly adjust position of points in every shape relative to original shape positions
    float vertexMovementFactor = (float(i) / vertexChildren); // the higher the vertex position the more movement
    float rndX = randomMovementX[i] * sin(frameCount*randomIncrement); // calc how much to move based on sin()
    float rndY = randomMovementY[i] * sin(frameCount*randomIncrement); // calc how much to move based on sin()
    
    // get the vertex in the original SVG as a reference
    PVector origVertex = s.getChild(0).getChild(i).getVertex(0);
    // adjust the first point in the current vertex in the "animating" SVG
    s2.getChild(0).getChild(i).setVertex(0, origVertex.x+((xMovementRange*(sin(frameCount*movementIncrement)))*vertexMovementFactor) + rndX, origVertex.y-((yMovementRange*(sin(frameCount*movementIncrement)))*vertexMovementFactor) + rndY);
    
    // repeat with a variation of the movement for point 2
    origVertex = s.getChild(0).getChild(i).getVertex(1);
    s2.getChild(0).getChild(i).setVertex(1, origVertex.x+((xMovementRange*(sin(frameCount/2*movementIncrement)))*vertexMovementFactor) + rndX/2, origVertex.y-((yMovementRange*(sin(frameCount/2*movementIncrement)))*vertexMovementFactor) + rndY/2);
    
    // repeat with a variation of the movement for point 3
    origVertex = s.getChild(0).getChild(i).getVertex(2);
    s2.getChild(0).getChild(i).setVertex(2, origVertex.x+((xMovementRange*(sin(frameCount/4*movementIncrement)))*vertexMovementFactor) + rndX/4, origVertex.y-((yMovementRange*(sin(frameCount/4*movementIncrement)))*vertexMovementFactor) + rndY/4);
  }
  
  
  // draw BG
  fill(0);
  rect(0,0,width,height);
  
  // calc total scaling
  if(fitImageToWidth) { // scale image to width
    fitScale = width / s.width;
  }
  totalScale = fitScale + extraScale;
  
  // position and place animated SVG
  translate(width/2, height/2);
  
  shape(s2, canvasXMovementRange*(sin(frameCount*movementIncrement)) + (xCanvasOffset*width), canvasYMovementRange*(sin(frameCount*movementIncrement)) + (yCanvasOffset*height), s.width*totalScale, s.height*totalScale);
  
  
  // if recording, output a PNG for video rendering later.
  if (doRecord) {
   saveFrame("frames/frame-####.png"); 
   println("output frame #" + frameCount);
  }
}



