function s = visualizer(port, MasterMatrix, Origin)
%% Prepare Image
figure;

ls1 = surf([0 0;0 0]);
figure;
ls2 = surf([0 0;0 0]);
%% Open Serial Ports
  delete(instrfind)
  s = serial(port);
  
  s.BytesAvailableFcnCount = 1;
  s.BytesAvailableFcnMode = 'byte';
  s.BytesAvailableFcn = {'instrread', 1,80, 20, 0, 0, 0, ls1, ls2, MasterMatrix, Origin}; % 1 for header
  %s.ReadAsyncMode = 'manual';
  s.BaudRate=57600;
  
  fopen(s);
  flushinput(s);
  readasync(s, 1);
end

