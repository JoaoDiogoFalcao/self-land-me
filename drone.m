function drone(mission, Edge_low, Edge_high)
    close all;
    figure;
    h1 = 1;
    ls = mesh([0 0;0 0]);
    pause(0.1);
    hold on;
    %% Meta Data
    %Edge_low = 0.3
    %Edge_high = 0.7
    [Lat, Lng, Altitude, LR_Altitude, Timestamp] = importLog(sprintf('Drone1/Logs Raw/%i%s', mission, '.mat'));
    DroneSize = 1; %meters diagonal span
    FOV_V = 94.4; %degrees 4x3W Vertical
    FOV_H = 122.6; %degrees 4x3W Horizontal

    for time_frame=1:size(Lat)
        %% Image input
        if ( exist(fullfile(cd, sprintf('Drone1/Corrected/%i-%i%s', mission, time_frame, '.JPG')), 'file') == 2)
            RGB = imread(sprintf('Drone1/Corrected/%i-%i%s', mission, time_frame, '.JPG')); % Elapsed time is 0.328312 seconds.
            I = rgb2gray(RGB); % improvement with edge detection for RGB   Elapsed time is 0.021736 seconds.
            I = medfilt2(I); % Elapsed time is 0.269730 seconds.
            BW = edge(I, 'Canny', Edge_low, Edge_high); %% Elapsed time is 0.526820 seconds.

            %figure;
            %imshow(BW);
            
            %% Split the Image
            
            imageSizeY = size(I, 1);
            imageSizeX = size(I, 2);
            pixelSize = (Altitude(time_frame)*tand(FOV_V/2))/(imageSizeX/2); %meters
            
            
            
            %% FishEye Distortion Matrix (TODO)
            FishEyeDistortion = ones(imageSizeY, imageSizeX);

            %% Create Grid
            
            gridSize = ceil((DroneSize/pixelSize));
            decisionMap = zeros(floor(imageSizeX/gridSize));

            for i=1:floor(imageSizeX/gridSize)
                subX0 = ((i-1)*gridSize)+1;
                subX1 = subX0+gridSize;

                for j=1:floor(imageSizeX/gridSize)
                    subY0 = ((j-1)*gridSize)+1;
                    subY1 = subY0+gridSize;
                    if(subX1 > imageSizeX)
                        if(subY1 > imageSizeY)
                            aux = BW(subY0:end, subX0:end);
                        else
                            aux = BW(subY0:subY1, subX0:end);
                        end
                    else
                        if(subY1 > imageSizeY)
                            aux = BW(subY0:end, subX0:subX1);
                        else
                            aux = BW(subY0:subY1, subX0:subX1);
                        end
                    end

                    decisionMap(i,j) = sum(aux(:));
                end

            end
            
            %% Plot 2D Decision map
           % figure;
            %surf(decisionMap);
            
            
             pause(0.00001)
             delete(ls)
             ls = surf(decisionMap);
            


            %% Apply threshold
            
            edgeThreshold = 1;
            aboveTheshold = (decisionMap >= edgeThreshold);
            belowThreshold = (decisionMap < edgeThreshold);
            decisionMap(aboveTheshold) = 1;
            decisionMap(belowThreshold) = 0;
            
            %% Plot decision Image
            %figure;
            
%             layer = uint8(ones(size(I,1 ), size(I,2),3));
% 
%             for i=1:floor(imageSizeX/gridSize)
%                 subX0 = ((i-1)*gridSize)+1;
%                 subX1 = subX0+gridSize;
% 
%                 for j=1:floor(imageSizeX/gridSize)
%                     subY0 = ((j-1)*gridSize)+1;
%                     subY1 = subY0+gridSize;
%                     if(subX1 > imageSizeX)
%                         if(subY1 > imageSizeY && decisionMap(i,j) == 1)
%                             layer(subY0:end, subX0:end,1)=256;
%                         else
%                             if(decisionMap(i,j) == 1)
%                                 layer(subY0:subY1, subX0:end,1)=256;
%                             end
%                         end
%                     else
%                         if(subY1 > imageSizeY && decisionMap(i,j) == 1)
%                             layer(subY0:end, subX0:subX1,1)=256;
%                         else
%                             if(decisionMap(i,j) == 1)
%                                 layer(subY0:subY1, subX0:subX1,1)=256;
%                             end
%                         end
%                     end
% 
%                 end
% 
%             end    
%             pause(0.01);
%             delete(h1)
%             RGB = insertText(RGB,[100 100],sprintf('Altitude: %d\nPixel Size: %d\nGridSize: %d\nLat: %f Lng: %f',Altitude(time_frame), pixelSize, gridSize, Lat(time_frame), Lng(time_frame)),'FontSize',60,'BoxColor','blue','BoxOpacity',0.4,'TextColor','white');
%             h1 = imshow(RGB);    
%             hold on;
%             h = imshow(layer);
%            set(h, 'AlphaData', 0.3);
           
        end
    end
end



%%

















%% Real-time visualizer
% the data
 %    nt=5; % <- traces
  %   np=100000; % <- data/trace
% prepare the plot
  %   axes('xlim',[1,np],'ylim',[-2,5]);
  %   x=1:np;
  %   y=-inf*ones(size(x));
  %   lh=line(x,y,...
  %          'marker','.',...
  %          'markersize',5,...
  %          'linestyle','none');
  %   lb=line([inf,inf],[-2,5]);
  %   shg;
% gather the data and plot in <real-time>...



