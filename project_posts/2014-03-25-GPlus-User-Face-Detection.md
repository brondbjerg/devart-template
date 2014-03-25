##G+ Image Face Detection For "Oberver Effect" Portraits

Having investigated static portraits, and added motion to those portraits, it was time to start adding some "Observer Effect".

Alongside gallery based generative portraits, I also want to create online versions of the works.

But, just like the gallery version of the portrait, they should be influenced by the "Observer".

So, using the Google+ API i've created a sign in process that allows us to get the G+ user's profile image.

[Read About G+ Sign In](https://developers.google.com/+/web/signin/ "Read About G+ Sign In").

Once I capture the G+ profile image, I need to detect the user's face within that image, in order to add it to a portrait.

I used this super handy jQuery wrapper: [jQuery.facedetection](https://github.com/jaysalvat/jquery.facedetection "jQuery.facedetection").

It is a wrapper for this computer vision library: [Liuliu's Computer Vision Library](https://github.com/liuliu/ccv "Liuliu's Computer Vision Library").

![Face Detection Demo](project_images/006_GplusFaceDetection.jpg?raw=true "Face Detection Demo")


##Processing.js G+ Face Detection Demos

[Launch Demo 006](http://www.brondbjerg.co.uk/demos/devart/demo006_GPlusPortrait/ "Demo 006")

If you have a G+ account, you can sign in and try the demo above.

The demo will attempt to detect your face in your profile image, and if succesful pass the image and face data into Processing.js.

You will see the drawing algorithm now uses the colours from the user's G+ profile image.


##The Next Step
The next stage is to take the detected face and blend it with an existing portrait composition.

This will invlove selecting & softening the face in the profile image, and blending with the original artwork.

Then using the drawn SVG portrait composition to sample the composite image of the artwork and the user together.


It'll all make sense in the next post I'm sure ;)



I've included the demo code on GitHub here (demo006_GPlusPortrait): [View on GitHub](https://github.com/brondbjerg/devart-template/tree/master/project_code/demos "View on GitHub")




