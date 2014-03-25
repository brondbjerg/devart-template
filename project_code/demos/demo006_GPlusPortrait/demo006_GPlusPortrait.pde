boolean loadingImage = false;
boolean init = false;
PImage loadedImg;
PImage img;

float canvasScaling = 0.0;
float faceArea = 1.25;

int frames = 0;
int[] xPos = new int[0];
int[] yPos = new int[0];
color[] cols = new color[0];
color colA;
color colB;
color tweenCol;
boolean positionValid;

int sampleRate = 8;
int shapePoints = 3;

void setup() {
  size(544, 544);
  frameRate(60);
  colorMode(RGB,255);
  background(0);
  smooth();
  noStroke();
  
  
}

void prepImage() {
  
  canvasScaling = width / loadedImg.width;
  
  float iRatio = float(loadedImg.width)/float(loadedImg.height);
  float cRatio = float(width)/float(height);
  
  if (iRatio > cRatio) {
   // extend height to fit
   loadedImg.resize(0,height);
   // grab center of image
   img = loadedImg.get(((loadedImg.width - width)/2), 0, width, height);
  } else {
   // extend width to fit
   loadedImg.resize(width,0);
   // grab middle of image
   img = loadedImg.get(0, ((loadedImg.height - height)/2), width, height);
  }
  
  // show image in BG
  
  image(img, 0, 0); 
  fill(0,200);
  rect(0,0,width,height);
  noFill();
  
  stroke(255);
  rect(  pdata.faceX*canvasScaling,
         pdata.faceY*canvasScaling,
         pdata.faceW*canvasScaling,
         pdata.faceH*canvasScaling);
  
  init = true;
}

void doLoadImage() {
  loadedImg = requestImage(pdata.userImagePath);
  loadingImage = true;
}

void draw() {
  
  if(!loadingImage) {
     if(pdata.userImagePath != "") {
       doLoadImage();
     } 
  }
  
  
  if(loadingImage) {
    if(!init) {
      if (loadedImg.width == 0) {
        // Image is not yet loaded
      } else if (loadedImg.width == -1) {
        // This means an error occurred during image loading
      } else {
        // Image is ready to go, draw it
        prepImage();
      }     
    }
  }
  
  
  if(init) {
    
    frames++;
    if (frames >= sampleRate) {
      // reset
      frames = 0;
      
      if ((mouseX > 0) && (mouseY > 0)) {
        
        positionValid = true;
        
        if(xPos.length > 0) {
          if ((mouseX == xPos[xPos.length-1]) && (mouseY == yPos[yPos.length-1])) {
             positionValid = false;
          }
        }
        
        if (positionValid) {
          // sample point      
          xPos = append(xPos, mouseX); 
          yPos = append(yPos, mouseY); 
          
          //draw shape
          if (xPos.length >= shapePoints) {
            
            colA = getCol(pixelID(xPos[xPos.length-1], yPos[yPos.length-1]), 150);
            colB = getCol(pixelID(xPos[xPos.length-2], yPos[yPos.length-2]), 150);
            tweenCol = lerpColor(colA, colB, .5);
            fill(tweenCol);
            
            beginShape();
            noStroke();
            for(int v=0; v<shapePoints; v++) {
              int arrayPos = xPos.length-1 - v;
              vertex(xPos[arrayPos],yPos[arrayPos]);
            }
            // close
            endShape(CLOSE);
             
          }
        }
        
      }
      
    }
  
  }
  
}

color getCol(int loc, int a) {
  // Get the R,G,B values from image
  float r = red   (img.pixels[loc]);
  float g = green (img.pixels[loc]);
  float b = blue  (img.pixels[loc]); 
  return color(r,g,b,a);
}

int pixelID(int x, int y) {
 int xpx = int((float(x)/float(width))*img.width);
 int ypx = int((float(y)/float(height))*img.height);
 
 return int((ypx*img.width)+xpx); 
}


