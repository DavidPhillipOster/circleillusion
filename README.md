# circleillusion

A macOS program to demonstrate and play with an optical illusion of two rotating circles that always seem to approach

The code for drawing the illusion is all in CIRIllusionView.m .

There is a tools palette in the Illusion menu where you can control the parameters of the illusion.

See:
 https://www.indiatimes.com/technology/science-and-future/optical-illusion-rainbow-circle-video-539454.html

------

Quoted:

The circles have an inner and outer edge that is of a different color to the center rainbow that’s on the rings. They’re basically thinner slices of the main circles and the color in them are slightly retarded or advanced.

It’s these colored outer and inner rings that trick the eye into thinking that it’s the circles that are moving. However, as soon as you set the width of the outer and inner circles to zero, the illusion fell flat and it was no longer in motion.

What makes the Spinning Rainbow Circles illusion work.

https://www.youtube.com/watch?v=dd2Y_ee6zIM

If you picture how a movie works, we see a series of frames with slight differences between each frame.  As we watch, one frame with a person in one position and in the next frame they are in a slightly different position and so on.  Our eye sees each of the individual frames but as it would overload if it had to process all that data, it kind of doesn't bother to.  In fact our brain (being the clever little lump of water and fat that it is) keeps the original image and processes the changes to smooth it all out.  We see it as fluid motion.  In fact our brain goes a step further and actually anticipates the changes to a degree.

In the case of the rotating rainbow rings, as a color (eg the dark blue) is passing a point on the ring it is trailed behind by a thin edge of the same blue after it has passed, our brain pics up this change,  interprets and smooths it out as if the whole blue section moved slightly in that direction.  Now that shouldn't in itself produce the illusion of motion as much as a flickering but our helpful brain anticipates that that movement is going to continue and so we perceive it to do so.  It does adjust but essentially keeps falling for the same trick over and over and we really perceive that there is movement there.

------

As usual, to compile this for your own use, you may need to change the bundle id to a prefix you control and set your development team in Xcode's Target's Signing&Capabilities panel.

A notorized, runnable verion is in Releases on this page.

