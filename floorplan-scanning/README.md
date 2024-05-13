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

## Aligning Polygon-like Representations With Inaccuracies 

[US-20230334200-A1](https://ppubs.uspto.gov/dirsearch-public/print/downloadPdf/20230334200)

![align shapes](align-shapes.png)

Scan measurements contain error, and the real world is imperfect.
How can we correct the alignment of complex floor plan shapes with minimal distortion?
One answer is to simultaneously move all points of the floor plan in a [multi-variable optimization](/why-train-when-you-can-optimize/) approach.





