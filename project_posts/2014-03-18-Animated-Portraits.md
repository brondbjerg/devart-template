##Random animation of the SVG portrait

Having produced the PDF portrait artwork in Porcessing and converted it to an SVG file, I set about animating the points of the SVG to create a motion portrait.

Import the SVG like this:

```
s = loadShape("MartinVanBuren.svg");
```

An SVG is made up of a series of XML drawing instructions:

```
<svg ... x="0px" y="0px" width="540px" height="800px" ... >
<g>
	<polygon opacity="0.5882" fill="#FBDCC9" points="241,186 242,186 244,184 	"/>
	<polygon opacity="0.5882" fill="#FBDBC8" points="241,187 241,186 242,186 	"/>
	<polygon opacity="0.5882" fill="#F5D3BF" points="240,189 241,187 241,186 	"/>
	<polygon opacity="0.5882" fill="#F7E5D7" points="228,163 240,189 241,187 	"/>
	<polygon opacity="0.5882" fill="#ECD7C8" points="186,175 228,163 240,189 	"/>
	<polygon opacity="0.5882" fill="#E1B8A3" points="195,176 186,175 228,163 	"/>
	<polygon opacity="0.5882" fill="#D2BBAE" points="143,172 195,176 186,175 	"/>
	<polygon opacity="0.5882" fill="#D5BCB1" points="199,117 143,172 195,176 	"/>
	<polygon opacity="0.5882" fill="#E0B6A7" points="167,121 199,117 143,172 	"/>
	
	... thousands of these polygons ...

</g>
</svg>
```

When I have the SVG loaded as a PShape, I can access the shape data (Points in Polygons) like any an XML document.

For example, you can get to the number of Polygons like this:

```
vertexChildren = s.getChild(0).getChildCount();
```

Basically, to make the SVG animate, I adjust every point in the image, every single frame.

While I want the motion (at least for this test) to be random, I also want it to be smooth and organic feeling.

So, rather than moving a point "directly" to a random point, I move it gradually to & from that point using sin();

First I need to generate an array of random (within a +/- range) XY variations for each shape in the SVG.

```
void generateRandomised() {
  randomMovementX = new float[vertexChildren];
  randomMovementY = new float[vertexChildren];
  
  // generate a random factor for each shape in illustration
  for (int i = 0; i < vertexChildren; i++) {
    randomMovementX[i] = random(-xRandomRange,xRandomRange);
    randomMovementY[i] = random(-yRandomRange,yRandomRange);
  }
}
```

So, the points don't just wander off forever, I keep them bound to their original positions by having 2 copies of the SVG in memory. One to animate, and one as a reference.

To add a sense of depth to the movement, the higher the vertex is in the illustration, the greater the movement factor is applied.

Each of the the three points in these polygons is moved to a different degree, again to break the uniformity of the movement.

Finally, an XY motion is applied to the entire SVG to give a sense that the whole head is in motion (as if breathing).

```
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
```

##Output frames for video rendering

Each frame of animation we generate we can output for rendering as a .mov file like this:

```
if (doRecord) {
   saveFrame("frames/frame-####.png"); 
   println("output frame #" + frameCount);
  }
```

You can see 30 seconds of output from this motion algorithm here:

https://www.youtube.com/watch?v=wSkygvRmVoA



I've included the demo code on GitHub here (demo005_animatedPortrait): [View on GitHub](https://github.com/brondbjerg/devart-template/tree/master/project_code/demos "View on GitHub")




