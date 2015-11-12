close all;
clear;
%% Meta Data
Altitude = 40; %meters
DroneSize = 1; %meters diagonal span
FOV_V = 94.4; %degrees 4x3W Vertical
FOV_H = 122.6; %degrees 4x3W Horizontal

%% Image input
RGB = imread('G0071040X.JPG');
I = rgb2gray(RGB); % improvement with edge detection for RGB
BW = edge(I, 'Canny', 0.3, 0.7);
imshow(RGB);
figure;
imshow(BW);

%% Split the Image

imageSizeY = size(I, 1);
imageSizeX = size(I, 2);
pixelSize = (Altitude*tand(FOV_V/2))/(imageSizeX/2); %meters

%% FishEye Distortion Matrix (TODO)
FishEyeDistortion = ones(imageSizeY, imageSizeX);

%% Create Grid
gridSize = ceil(imageSizeX/(DroneSize/pixelSize));
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
figure;
mesh(decisionMap)

%% Apply threshold
edgeThreshold = 1;
aboveTheshold = (decisionMap >= edgeThreshold);
belowThreshold = (decisionMap < edgeThreshold);
decisionMap(aboveTheshold) = 1;
decisionMap(belowThreshold) = 0;

figure;
mesh(decisionMap);