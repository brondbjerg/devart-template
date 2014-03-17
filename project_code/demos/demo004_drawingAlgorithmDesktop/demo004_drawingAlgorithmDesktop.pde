/* @pjs pauseOnBlur="true"; */

boolean init = false;
PImage loadedImg;
PImage img;
int sampleRate = 8;
int frames = 0;
int[] xPos = new int[0];
int[] yPos = new int[0];
color[] cols = new color[0];
int shapePoints = 3;
color colA;
color colB;
color tweenCol;
boolean positionValid;

void setup() {
  size(686, 800);
  frameRate(60);
  colorMode(RGB,255);
  background(0);
  smooth();
  noStroke();
    
  //load
  loadedImg = loadImage("MartinVanBuren.png");
}

void prepImage() {
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
  tint(30,255);
  image(img, 0, 0); 
}

void draw() {
  
  if(!init) {
     init = true;
     prepImage();
  }
  
  
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

