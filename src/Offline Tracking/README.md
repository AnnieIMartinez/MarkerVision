# README

This provides a brief description of all the files inside the **Offline Tracking**

1) *video_capture.m* : This matlab code is run for video acquistion for the tracking. 

2) *run_script.m* : This matlab code is run for initializing the offline tracking. 

Inside the folder **functions**,

3) *colorMasks_####.m* : HSV chromatic mask generated using Color Thresholder app. 

4) *cam_properties.m* : Adjusted camera properties (brightness, saturation, contrast etc.,). 

5) *cameraParams.mat* : Correction for lens distortion.

6) *rigid_transform_3D.m* : Arun's algorithm

Inside the folder **+offlinetracking**,

7) *OfflineTracking.m* : This is the class containing all the algorithm for performing offline tracking.
