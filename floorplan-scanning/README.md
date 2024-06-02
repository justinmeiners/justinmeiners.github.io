# Building Scanning Patents

At a previous startup, I invented an Augmented Reality (AR) system for scanning buildings,
and automatically extracting floor plans from scans.
Recently a few of the patents I wrote were published, and I wanted to share those, with a brief summary.
 
## Capturing Environmental Features Using 2D and 3D Scans 

[US-20230083703-A1](https://ppubs.uspto.gov/dirsearch-public/print/downloadPdf/20230083703)

![ar scan](ar-scan.png)

This describes an augumented reality workflow for capturing a 3D mesh of an environment, and recording points of interest.
A key idea is to capture all the user interactions and raw 3D data first.
Later in a post-process step, we determine user intent and relative positioning using complete global ifnormation.

## Floor Plan Extraction 

[US-20240005570-A1](https://ppubs.uspto.gov/dirsearch-public/print/downloadPdf/20240005570)

![possible-scans](possible-scans.png)

Once we have a 3D scan of an environment, how do we go about turning this into a 2D floor plan?
Floor plans are conceptual, rather than objective, and so are guided by user input.
This invention describes both an augmented reality workflow and an algorithm for processing that input.
It turns out, doing this perfectly is likely NP-complete, but this proper understanding guides effective heuristics.

## Surface Animation During Dynamic Floor Plan Generation

[US-20240177385-A1](https://ppubs.uspto.gov/dirsearch-public/print/downloadPdf/20240177385)

![animation](animation.png)

It's important to give feedback to the user during the scanning process.
One way we do that is through the augmented reality visualization that shows which parts of a room are captured,
and is programmed through shaders.
The biggest challenge is to show accurate estimates quickly, despite the scan being incomplete.

## Aligning Polygon-like Representations With Inaccuracies 

[US-20230334200-A1](https://ppubs.uspto.gov/dirsearch-public/print/downloadPdf/20230334200)

![align shapes](align-shapes.png)

Scan measurements contain error, and the real world is imperfect.
How can we correct the alignment of complex floor plan shapes with minimal distortion?
One answer is to simultaneously move all points of the floor plan in a [multi-variable optimization](/why-train-when-you-can-optimize/) approach.

## Door and Window Detection in an AR Environment

[US-20240153096-A1](https://ppubs.uspto.gov/dirsearch-public/print/downloadPdf/20240153096)

![wall 3D](wall-3d.png)

![wall 2D](wall-2d.png)

Along with the shape of the building, we are also interested in the aperatures of each room.
The polygonal shape tells us where the walls are in 3D.
We can then render the  portion of the 3D mesh corresponding to each wall, and detect cutouts in the rendered image.
This transforms a complex 3D detection problem into a traditional 2D computer vision problem.
These 2D detections are then projected back into 3D features on the wall.



