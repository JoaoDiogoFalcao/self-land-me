function updateMasterMatrix(frame, heading, cols, rows, center_frame, droneSize, ls1, ls2, Origin)
global MasterMatrix
    origin_frame = zeros(2,1);
    heading = double(heading);
    tform = affine2d([cosd(heading) -sind(heading) 0; sind(heading) cosd(heading) 0; 0 0 1]);
    frame = imwarp(frame, tform);
    
%     x_distance = ((-double(cols)/2)*cosd(360-heading))+((double(rows)/2)*sind(360-heading));
%     y_distance = ((-double(cols)/2)*sind(360-heading))-((double(rows)/2)*cosd(360-heading));
%     
     lat_degrees_per_LZ_y = droneSize(1) * (1 / (110.54 * 1000));
     lon_degrees_per_LZ_x = abs(droneSize(2) * (1 / (111.320 * cosd(Origin(1)) * 1000)));
%     
     origin_frame(2) = center_frame(2) - lon_degrees_per_LZ_x*(double(cols)/2);
     origin_frame(1) = center_frame(1) - lat_degrees_per_LZ_y*(double(rows)/2);
    
    pos_index = zeros(2,1);
    for i=0:size(frame,2)-1
        for j=0:size(frame,1)-1
            pos_index(2) =  double(i)*lon_degrees_per_LZ_x + origin_frame(2);
            pos_index(1) = double(j)*lat_degrees_per_LZ_y + origin_frame(1);
            
            index_y = abs(floor(( Origin(1) - pos_index(1) ) / lat_degrees_per_LZ_y))+1;
            index_x = abs(floor(( Origin(2) - pos_index(2) ) / lon_degrees_per_LZ_x))+1;
            
            if(index_x < 1001 && index_y < 1001)
                    MasterMatrix(index_y, index_x, 1) = MasterMatrix(index_y, index_x, 1) + frame(j+1, i+1);
            end
            
        end
        
    end
    pause(0.0001);
    set(ls1, 'ZData', MasterMatrix(:,:,1));
    %set(ls1, 'ZData', frame);
    set(ls2, 'ZData', frame);
    
end
