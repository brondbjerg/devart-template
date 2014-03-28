/* @pjs preload="portrait.svg, faceshape.png, MartinVanBuren.jpg"; */


boolean loadingImage = false;
boolean imagesPrepped = false;
boolean init = false;
boolean enableDrawing = false;

PImage faceShape;
PImage loadedImg;
PImage isolatedFace;
PImage maskedFace;
PImage portrait;
PImage mergedPortrait;
PShape portraitSVG;
PImage composition;

float faceAreaCenterX = 0.5; // of canvas width
float faceAreaCenterY = 0.31; // of canvas height (from top)
float faceAreaSize = 0.65; // width/height of faceArea as proportion of canvas width
float faceMargin = 0.4; // as proportion of detect face width
float SVGFaceCenterX = 270; // X middle of face on SVG portrait 
float SVGFaceCenterY = 225; // Y middle of face on SVG portrait 
float SVGFaceSize = 200; // PX size of face (as detection would show) in SVG

// user drawing vars
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
  size(545, 750);
  frameRate(60);
  colorMode(RGB,255);
  background(0);
  smooth();
  noStroke();
  
  
  // get original portrait
  portrait = loadImage("MartinVanBuren.jpg");
  
  // get face mask
  faceShape = loadImage("faceshape.png");
  
  // portrait SVG
  portraitSVG = loadShape("portrait.svg");
  
}



void prepImage() {
   
  // BG fill
  fill(0);
  rect(0,0,width,height);
    
  imageMode(CENTER);
  
  // user face
  int faceMarginPX = int(int(pdata.faceW) * faceMargin);
  isolatedFace = loadedImg.get(int(pdata.faceX)-faceMarginPX,int(pdata.faceY)-faceMarginPX,int(pdata.faceW)+(faceMarginPX*2),int(pdata.faceH)+(faceMarginPX*2));
  image(isolatedFace, width*faceAreaCenterX, height*faceAreaCenterY, (width*faceAreaSize), (width*faceAreaSize));
  
  // knock back user face a bit
  fill(0,80);
  rect(0,0,width,height);
  
  // mask 
  image(faceShape, width*faceAreaCenterX, height*faceAreaCenterY, (width*faceAreaSize), (width*faceAreaSize));

  // capture canvas as comped face, masked on black BG
  maskedFace = get();
  
  // BG fill
  fill(0);
  rect(0,0,width,height);
  
  imageMode(CORNER);
  image(portrait, 0, 0, width, height);
    
  mergedPortrait = get();    
  // blend with original portrait
  mergedPortrait.blend(maskedFace, 0, 0, width, height, 0, 0, width, height, MULTIPLY );
  
  
  
  // -- all prepped, now present 
  
  // BG fill
  fill(0);
  rect(0,0,width,height);
  
  // original portrait
  imageMode(CORNER);
  //image(portrait, 0, 0, width, height);
  
  // SVG Portrait
  SVGFaceSizeWithMargin = SVGFaceSize + (SVGFaceSize*faceMargin*2);
  svgFaceScale = (faceAreaSize*width) / SVGFaceSizeWithMargin;
  shape(portraitSVG, (faceAreaCenterX*width)-(SVGFaceCenterX*svgFaceScale), (faceAreaCenterY*height)-(SVGFaceCenterY*svgFaceScale), portraitSVG.width*svgFaceScale, portraitSVG.height*svgFaceScale);

  // capture SVG & BG as BMP compoition for blending
  composition = get();
  
  
  // blend face to original
  composition.blend(mergedPortrait, 0, 0, width, height, 0, 0, width, height, SOFT_LIGHT ); 
  imageMode(CORNER);
  image(composition, 0, 0, width, height);
  


  // done
  imagesPrepped = true;
  
  // ok, let's go
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
      if(!imagesPrepped) {
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
  }
  
  
  if(init) {
    userDraw();
  }
  
}




function userDraw() {
  
  if(enableDrawing) {
  
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
  float r = red   (portrait.pixels[loc]);
  float g = green (portrait.pixels[loc]);
  float b = blue  (portrait.pixels[loc]); 
  return color(r,g,b,a);
}

int pixelID(int x, int y) {
 int xpx = int((float(x)/float(width))*portrait.width);
 int ypx = int((float(y)/float(height))*portrait.height);
 
 return int((ypx*portrait.width)+xpx); 
}

