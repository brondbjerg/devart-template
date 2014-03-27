##G+ Image Face Blending with Generative SVG Portrait

The final step for the online element of this porject is to blend the user's face with the existing portrait.

As discussed in the last post, we have captured and blended the user's face witht the original classical portrait.

Now we take that blended image and merge it into the original SVG portrait we produced with our generative portrait drawing algorithm.


![Face & Portrait SVG Blending](project_images/009_GplusFacePortraitMerged.jpg?raw=true "Face & SVG Portrait Blending")


##Sadly, not everything worked out.

It was my intention to add the kind of randomised motion as seen in the earlier video to this online JavaScript version.

Sadly, Processing.js (I now discover) doesn't yet support shape.getChild(index) or shape.getChildCount(), so I couldn't access the intenral Polygons in the SVG.

This also meant I couldn't recolor the polygons quite as I wanted...

Oh well, such is the DevArt journey of discovery.


##Processing.js G+ Face & Portrait Blending Demo

[Launch Demo 008](http://www.brondbjerg.co.uk/demos/devart/demo008_GPlusSVGPortrait/ "Demo 008")

As with the last demo, if you have a G+ account, you can sign in and try the demo above.

When your face is detected, your image will be passed into processing, where it will be isolated and blended with the classical portrait.

Then that blended composition is merged with the generative SVG portrait, to produce the final online "Observer Effect" portrait.

![Face & Portrait SVG Blending Demo](project_images/010_GplusFacePortraitMergedApp.jpg?raw=true "Face & Portrait SVG Blending Demo")


##The Next Step
In the final day, we'll be producing the full "Installation" version of the "Observer Effect" Portraits, that WILL animate and evolve in response to the physical gallery "Observer".


I've included the demo code on GitHub here (demo008_GPlusSVGPortrait): [View on GitHub](https://github.com/brondbjerg/devart-template/tree/master/project_code/demos "View on GitHub")





