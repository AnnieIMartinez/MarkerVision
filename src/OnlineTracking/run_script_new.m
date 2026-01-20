clear all;
clc;

%[] Input video name for writing
vid_name = 'demo_capture'; % Final video file name 

%[] Initalize video object to write tracked video frames
params.vwrite_tracked = VideoWriter(append(vid_name,'_gcf'),'MPEG-4');
open(params.vwrite_tracked);

%[] Initialize camera and camera properties
choose_cam = menu("Initialize camera",'Yes','No');
% Camera for tracking
if choose_cam == 1
    cam = webcam(1);
	% Setting camera resolution
	% - All available resolution can be accessed in "cam.AvailableResolution()"
    cam.Resolution = '1920x1080';   
    preview(cam);
end
choose_cam_prop = menu("Adjust Camera properties",'Yes','No');
if choose_cam_prop == 1
    cam = camera_properties_marker_1920_Blue(cam);
    cam.Resolution = '1920x1080';
end

% Distortion Parameter
% - Camera callibrated for correcting skewness by using MATLAB checkerboard method.
% - Website: 
% - Make your own callibration.
% - This is not so important for the application, can be avoided
distortion = load('cameraParams.mat');

pause(2); 
setup_img = cam.snapshot;
setup_img = undistortImage(setup_img,distortion.cameraParams);

clear cam;

%[] World parameters
pixel_to_cm = 8.5254;

% Initilaize object for online tracking
tracker_obj = OnlineTracking(params);
PrevPt = [];
P0 = [];
robo_centroid = [];

input('Press <Enter> to start'); % Press 'Enter' to start here

%[] Initialize --> Pollable Data Queue-(P)
P = parallel.pool.PollableDataQueue;
L = parallel.pool.PollableDataQueue;

%[] Initialize --> parfeval-(f)
parpool('local',1);
freq = 25;
% f = parfeval(@getFrameFromCamera,0,P,L,freq,distortion);
f = parfeval(@getFrameFromCamera,0,P,L,distortion,vid_name);

pause(1.5);

while(true)

if P.QueueLength > 0

cam_data = poll(P);
newim = cam_data.img;
ts = cam_data.time_stamp;
poll_data = poll_data + 1;
idx = idx + 1;
[output_data] = tracker_obj.tracking(newim,PrevPt,P0,robo_centroid,trajectory_position,idx);
tracking_data(idx,:) = [output_data.tracking_data(idx,:) ts];
PrevPt = reshape(output_data.tracking_data(idx,1:12),[3,4])';
robo_centroid = output_data.robo_centroid;

if idx == 1
P0 = output_data.P0;
end

end
end

