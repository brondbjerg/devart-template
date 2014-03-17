##Generating vector output for print and animation

Now we're happy with the drawing algorithm to draw / generate our new portrait, we need a way of getting it out of Processing for print or post production.

Processing makes that simple, by allowing you to start recording what is drawn to screen directly into a PDF.


```
beginRecord(PDF, "pdf/fromFrame-####.pdf");

```

Then stopping the recording when your artwork is complete:

```
endRecord();

```

Now we have our PDF output we can use that in Illustrator and make hi res print work.

![Drawing Algorithm PDF](project_images/005_drawingAlgorithmPDF.jpg?raw=true "Drawing Algorithm PDF")

But we next we have other plans... animating the vector output! (See the next post).


## The Processing Application

Unlike the last demos that run in the browser under Processing.js, to save the PDF to a file, we need to run this as a Processing 2 desktop application.

I've included the code for the desktop application on GitHub here (demo004_drawingAlgorithmDesktop): [View on GitHub](https://github.com/brondbjerg/devart-template/tree/master/project_code/demos "View on GitHub")

This also has a few extra features in the controls.pde for adjusting drawing speed, shape points and PNG output.


