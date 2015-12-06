function s = visualizer(port)
%% Prepare Image
figure;
hold on;
ls = surf([0 0;0 0]);

%% Open Serial Ports
  delete(instrfind)
  s = serial(port);
  
  s.BytesAvailableFcnCount = 1;
  s.BytesAvailableFcnMode = 'byte';
  s.BytesAvailableFcn = {'instrread', 1,80, 20, ls}; % 1 for header
  %s.ReadAsyncMode = 'manual';
  s.BaudRate=57600;
  
  fopen(s);
  flushinput(s);
  readasync(s, 1);
end

