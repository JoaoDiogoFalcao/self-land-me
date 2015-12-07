MasterMatrix = zeros(100,100,2);
Origin = [37.410423 -122.059962];
close all;
s = visualizer('/dev/tty.usbserial-DN00BNLH', MasterMatrix, Origin);