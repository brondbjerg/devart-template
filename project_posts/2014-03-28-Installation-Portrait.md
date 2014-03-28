##Gallery Installation Portrait with Processing & OpenCV

The final demo here is revisting the animation experiments we did a few posts back.

This time instead of the motion being random & autonomous, we are introducing, as with the online version) the concept of the "Observer Effect".


##So what have we done

Using the animation algorithm we developed earlier in the project, the portrait gently animates each of the polygons in the composition.

However when the work is observed, the SVG composition responds & distorts to the viewers movement. 

We are using the "OpenCV for Processing" library to track the visitors face X,Y and proximity to the work.

[OpenCV for Processing](https://github.com/atduskgreg/opencv-processing "OpenCV for Processing")


![Installation Portrait Testing](project_images/011_InstallationPortraitTesting.jpg?raw=true "Installation Portrait Testing")


With these OpenCV face detection parameters we move the entitre composition left, right, up & down and scale in & out.

In addition, we move one vertex of each polygon more than the others in response to faceX and faceScale, which results in a paralax feel and a distortion of the work.


In order to see the work as it would be unobserved, the visitor must be still and engaged head on with work...


##Demo Video

Some footage of the responsive portrait in action...

http://youtu.be/X45B0QJptc0



##Gallery Installation Portrait Demo Code

This is a Java based Processing sketch designed to run from the Desktop. Sadly there isn't a Processing.js version of this motion (as discussed in the last post).

The code itslef is quite straightforward, but you will need to install the "OpenCV for Processing" Library.

In the final code folder, we will export the application to run as a self contained application.


I've included the demo code on GitHub here (demo009_InstallationPortrait): [View on GitHub](https://github.com/brondbjerg/devart-template/tree/master/project_code/demos "View on GitHub")


