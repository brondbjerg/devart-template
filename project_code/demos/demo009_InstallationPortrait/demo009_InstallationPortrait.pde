import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

PShape s, s2;

boolean fitImageToWidth = true; // true: fits image to width, false: fits image to height
float fitScale = 0;
float extraScale = 0;
float totalScale = 0;
float xCanvasOffset = 0; // 1.0 moves 100% x canvas
float yCanvasOffset = 0.2; // 1.0 moves 100% y canvas

int xMovementRange = 15;
int yMovementRange = 6;

int xRandomRange = 15;
int yRandomRange = 15;

float movementIncrement = TWO_PI/400; // divisions of 2*pi for use in sin()
float randomIncrement = TWO_PI/250; // divisions of 2*pi for use in sin()

float pTween = 5; // amount movement is divided by

int pTargetX = 0;
int pTargetY = 0;
float pTargetScale = 0.0;
int pLastX = 0;
int pLastY = 0;
float pLastScale = 0.0;

int pRangeX = 100;
int pRangeY = 100;
float pRangeScale = 1.5;

int vertexChildren = 0;

float[] randomMovementX;
float[] randomMovementY;

boolean doRecord = false; // this switches on rendering video frames.

float faceCenterX; // as proportion of openCV canvas width;
float faceCenterY; // as proportion of openCV canvas height;
float faceScale; // as proportion of openCV canvas height;
boolean faceDetected = false;
boolean showOpenCV = false;  // show opencv output


void setup() {
  smooth(8);
  frameRate(30);
  //size(854, 480); // 480p  
  size(displayWidth, displayHeight); // FULL
  
  // variables dependent on display size
  initDisplayVars();
  
  // black BG
  background(0);
  
  // The file must be in the data folder
  s = loadShape("MartinVanBuren.svg");
  s2 = loadShape("MartinVanBuren.svg"); // loading the same shape twice to create duplicate object (another solution?)
  
  vertexChildren = s.getChild(0).getChildCount();
  generateRandomised();

  // open cv setup
  
  video = new Capture(this, 640/4, 480/4);
  opencv = new OpenCV(this, 640/4, 480/4);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  video.start();
  
  
}

void initDisplayVars() {
  pRangeX = int(width*0.2);
  pRangeY = int(height*0.1);
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
  doPortraitDraw();
  doOpenCV();
  
}

void doPortraitDraw() {
  
  noStroke();
  shapeMode(CENTER);
  
  
  // calculate portrait positioning
  if(!faceDetected) { // default
    pTargetX = int(0 + (xCanvasOffset*width));
    pTargetY = int(0 + (yCanvasOffset*height));
    pTargetScale = pLastScale;
  } else { // follow face
    pTargetX = int((((faceCenterX*2)-1) * pRangeX) + (xCanvasOffset*width));  // translated face range 0-1 into range of -1 to 1 to give +/- movement
    pTargetY = int((((faceCenterY*2)-1) * -pRangeY) + (yCanvasOffset*height)); // translated face range 0-1 into range of -1 to 1 to give +/- movement
    pTargetScale = faceScale+1 * pRangeScale;
  }
  
   // calc tweened next movement
  int pNextX = int(pLastX + (pTargetX-pLastX)/pTween);
  int pNextY = int(pLastY + (pTargetY-pLastY)/pTween);
  float pNextScale = pLastScale + (pTargetScale-pLastScale)/pTween;
  
  // update
  pLastX = pNextX;
  pLastY = pNextY;
  pLastScale = pNextScale;
  
  
  // internal SVG movement
  for (int i = 0; i < vertexChildren; i++) {
    // randomly adjust position of points in every shape relative to original shape positions
    float vertexMovementFactor = (float(i) / vertexChildren); // the higher the vertex position the more movement
    float rndX = randomMovementX[i] * sin(frameCount*randomIncrement); // calc how much to move based on sin()
    float rndY = randomMovementY[i] * sin(frameCount*randomIncrement); // calc how much to move based on sin()
    
    // get the vertex in the original SVG as a reference
    PVector origVertex = s.getChild(0).getChild(i).getVertex(0);
    // adjust the first point in the current vertex in the "animating" SVG
    // also factored in the portrait tweening for these points ( +(pNextX*(pNextScale/2)) ) to give a paralaz feel.
    s2.getChild(0).getChild(i).setVertex(0, origVertex.x+((xMovementRange*(sin(frameCount*movementIncrement)))*vertexMovementFactor+(pNextX*(pNextScale/2))) + rndX, origVertex.y-((yMovementRange*(sin(frameCount*movementIncrement)))*vertexMovementFactor) + rndY);
        
    // repeat with a variation of the movement for point 2
    origVertex = s.getChild(0).getChild(i).getVertex(1);
    s2.getChild(0).getChild(i).setVertex(1, origVertex.x+((xMovementRange*(sin(frameCount/2*movementIncrement)))*vertexMovementFactor*pNextScale) + rndX/2, origVertex.y-((yMovementRange*(sin(frameCount/2*movementIncrement)))*vertexMovementFactor) + rndY/2);
    
    // repeat with a variation of the movement for point 3
    origVertex = s.getChild(0).getChild(i).getVertex(2);
    s2.getChild(0).getChild(i).setVertex(2, origVertex.x+((xMovementRange*(sin(frameCount/4*movementIncrement)))*vertexMovementFactor*pNextScale) + rndX/4, origVertex.y-((yMovementRange*(sin(frameCount/4*movementIncrement)))*vertexMovementFactor) + rndY/4);
    
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
 
  // move
  shape(s2, pNextX, pNextY , s.width*pNextScale, s.height*pNextScale);
  
  
  // if recording, output a PNG for video rendering later.
  if (doRecord) {
   saveFrame("frames/frame-####.png"); 
   println("output frame #" + frameCount);
  }
  
}


// open cv functions

void doOpenCV() {
  
  // give video to opencv
  opencv.loadImage(video);
  // detect
  Rectangle[] faces = opencv.detect();
  
  // results 
  if(faces.length > 0) {
    faceDetected = true;
    // only concerned with the first face.
    faceCenterX = float(faces[0].x + faces[0].width/2) / float(opencv.width);
    faceCenterY = float(faces[0].y + faces[0].height/2) / float(opencv.height);
    faceScale = float(faces[0].height) / float(opencv.height);
  } else {
    faceDetected = false;
  }
  
  // display opencv debug
  if(showOpenCV) {
    translate(-width/2, -height/2);
    image(video, 0, 0);  
    noFill();
    stroke(0, 255, 0);
    strokeWeight(1);
    
    // draw face(s) bounds
    for (int i = 0; i < faces.length; i++) {
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    
    // draw main canvas representation of position (first face)
    if(!doRecord) {
    rect(   (faceCenterX*width)-(height*faceScale)/2,
            (faceCenterY*height)-(height*faceScale)/2,
            height*faceScale,
            height*faceScale);
    }
    
    // debug
    //println(faceCenterX + " | " + faceCenterY + " | " + faceScale);
    
  
  }
}

void captureEvent(Capture c) {
  c.read();
}



