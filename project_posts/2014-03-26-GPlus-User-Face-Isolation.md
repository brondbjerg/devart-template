##G+ Image Face Detection & Isolation Continued

This post follows on from yesterday's demo of getting the G+ user's image and detecting their face.

Having passed the image and the location of the face into processing.js we now set about visually isolating the face and blending it with the the original classical portrait.

First we select the detected face area, then impose over that an "average" vignette mask.

Then we use Processing's blend mode to combine the face and portrait.

```
// blend face to original
  portrait.blend(maskedFace, 0, 0, width, height, 0, 0, width, height, MULTIPLY);
```

![Face & Portrait Blending](project_images/007_GplusFaceBlending.jpg?raw=true "Face & Portrait Blending")


##Processing.js G+ Face Isolation & Blending Demo

[Launch Demo 007](http://www.brondbjerg.co.uk/demos/devart/demo007_GPlusFaceIsolation/ "Demo 007")

As with the last demo, if you have a G+ account, you can sign in and try the demo above.

When your face is detected, your image will be passed into processing, where it will be isolated and blended with the classical portrait.

![Face & Portrait Blending Demo](project_images/008_GplusFaceBlendingApp.jpg?raw=true "Face & Portrait Blending Demo")


##The Next Step
Tomorrow we move onto imposing the SVG portrait compostion over this blended "observer effect" portrait.


I've included the demo code on GitHub here (demo007_GPlusFaceIsolation): [View on GitHub](https://github.com/brondbjerg/devart-template/tree/master/project_code/demos "View on GitHub")





