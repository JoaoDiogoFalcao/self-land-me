shuttleVideo = VideoReader('JIFX.mp4');
%ii = 1;
name_min = 0;
while hasFrame(shuttleVideo)
name = shuttleVideo.CurrentTime;
%if name>230
 %   break;
name_all = name*10000;
%name_all = cast(name_all,'uint64');
name_all = name_all/10;
name_all = floor(name_all);
name_ms = mod(name_all,1000);
name_s = (name_all-name_ms)/1000;
name_min = floor(name_s/60);
name_s = mod(name_s,name_min*60);
img = readFrame(shuttleVideo);
filename = [sprintf('%0.2d_%0.2d_%0.3d',name_min,name_s,name_ms) '.jpg'];
fullname = fullfile(workingDir,'images',filename);
imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
%ii = ii+1;
end