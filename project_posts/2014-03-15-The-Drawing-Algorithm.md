There were really 2 seed ideas behind this "Portraiture Reimagined" project:

1. Give digital artwork greater depth and a more painterly feel by sampling the colour and composition of classical portraits.

2. What is is the output like if you keep drawing triangles (or polygons) from the last mouse positions and sample the average colour of the last 2 two.

![Drawing Algorithm Sketch](project_images/003_drawingAlgorithmSketch.jpg?raw=true "Drawing Algorithm Sketch")


##Processing Code

```
/* @pjs preload="GeorgeWashington.jpg"; */


boolean init = false;
PImage loadedImg;
PImage img;
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
  
  loadedImg = loadImage("GeorgeWashington.jpg");
  
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
  
  // show daed image in BG
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

```

##Drawing Algorithm Tests

Varying the speed at which the mouse is sampled and also increasing the number of points in the polygon drawn produces vary different results.

![Drawing Algorithm Output](project_images/004_drawingAlgorithmOutput.jpg?raw=true "Drawing Algorithm Output")

##Processing.js Demos

1: [Launch Demo 001](http://www.brondbjerg.co.uk/demos/devart/001/ "Demo 001")

```
int sampleRate = 8; 
int shapePoints = 3;
```

2: [Launch Demo 002](http://www.brondbjerg.co.uk/demos/devart/002/ "Demo 002")

```
int sampleRate = 0; 
int shapePoints = 3;
```
3: [Launch Demo 003](http://www.brondbjerg.co.uk/demos/devart/003/ "Demo 003")

```
int sampleRate = 8; 
int shapePoints = 5;
```

The code for these demos are on GitHub here: [View on GitHub](https://github.com/brondbjerg/devart-template/tree/master/project_code/demos "View on GitHub")



