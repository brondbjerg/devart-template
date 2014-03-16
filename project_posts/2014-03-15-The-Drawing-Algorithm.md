There were really 2 seed ideas behind this "Portraiture Reimagined" project:

1. Give digital artwork greater depth and a more painterly feel by sampling the colour and composition of classical portraits.

2. What is is the output like if you keep drawing triangles (or polygons) from the last mouse positions and sample the average colour of the last 2 two.

![Drawing Algorithm Sketch](project_images/003_drawingAlgorithmSketch.jpg?raw=true "Drawing Algorithm Sketch")

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

