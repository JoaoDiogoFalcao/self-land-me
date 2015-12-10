global MasterMatrix
MasterMatrix = zeros(200,200,2);
Origin = [35.7652779476033 -120.768332818223];
close all;
s = visualizer('/dev/tty.usbserial-DN00BNLH', Origin);

