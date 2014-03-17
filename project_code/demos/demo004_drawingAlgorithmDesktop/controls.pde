boolean paused = false;
import processing.pdf.*;
boolean recording = false;

void keyPressed() {
  
  // PAUSE
  if (key == ' ') {
    if(paused) {
      loop();
      paused = false;
    } else {
      if(!recording) {
        noLoop();
        paused = true;
      } else {
        println("Can't Pause While Recording!"); 
      }
    }
  }
  
  // PDF
  if (key == 'r') {
     if (!recording) {
       println("PDF Recording Start");
       beginRecord(PDF, "pdf/fromFrame-####.pdf");
       // clear screen rect
       fill(0);
       rect(0,0,width, height);
       recording = true;
     } else {
       println("PDF Recording End");
       recording = false;
       endRecord();
     }
  }
  
  // SCREEN
  if (key == 'p') {
     //save("screens/frame-####.png");
     saveFrame("screens/frame-####.png");
  }
  
  // up down
  if (key == CODED) {
    if (keyCode == UP) {
      shapePoints++;
      println("ShapePoints: " + shapePoints);
    } else if (keyCode == DOWN) {
      shapePoints--;
      println("ShapePoints: " + shapePoints);
    }
    
  }
  
  
}
