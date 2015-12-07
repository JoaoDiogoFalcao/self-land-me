function updateMasterMatrix(frame, heading, cols, rows, center_frame, droneSize, ls1, ls2, MasterMatrix, Origin)
    origin_frame = zeros(2,1);
    Beta = 360-heading;
    d=sqrt(((double(cols))/2)^2+((double(rows))/2)^2);
    Teta = atand(double(cols)/double(rows));
    alpha = 180 - (Teta+Beta);
    x_distance = d*sind(double(alpha));
    y_distance = d*cosd(double(alpha));

    lat_degrees_per_LZ_y = droneSize(1) * (1 / (110.54 * 1000));
    lon_degrees_per_LZ_x = droneSize(2) * (1 / (111.320 * cosd(Origin(1)) * 1000));
    if(0 <= heading && heading < 90)
        origin_frame(2) = center_frame(2) - lon_degrees_per_LZ_x*x_distance;
        origin_frame(1) = center_frame(1) + lat_degrees_per_LZ_y*y_distance;
    end
    if(90 <= heading && heading < 180)
        origin_frame(2) = center_frame(2) - lon_degrees_per_LZ_x*x_distance;
        origin_frame(1) = center_frame(1) - lat_degrees_per_LZ_y*y_distance;
    end
    if(180 <= heading && heading < 270)
        origin_frame(2) = center_frame(2) + lon_degrees_per_LZ_x*x_distance;
        origin_frame(1) = center_frame(1) - lat_degrees_per_LZ_y*y_distance;
    end
    if(1)%270 <= heading && heading < 360)
        origin_frame(2) = center_frame(2) + lon_degrees_per_LZ_x*x_distance;
        origin_frame(1) = center_frame(1) + lat_degrees_per_LZ_y*y_distance;
    end
    
    pos_index = zeros(2,1);
    for i=0:rows-1
        for j=0:cols-1
            pos_index(2) = (double(j)*lon_degrees_per_LZ_x) * cosd(double(360-alpha)) - (double(i)*lat_degrees_per_LZ_y) * sind(double(360-alpha)) + origin_frame(2);
            pos_index(1) = (double(j)*lon_degrees_per_LZ_x) * sind(double(360-alpha)) + (double(i)*lat_degrees_per_LZ_y) * cosd(double(360-alpha)) + origin_frame(1);
            
            index_y = abs(floor(( Origin(1) - pos_index(1) ) / lat_degrees_per_LZ_y))+1;
            index_x = abs(floor(( Origin(2) - pos_index(2) ) / lon_degrees_per_LZ_x))+1;
            
            if(index_x < 1001 && index_y < 1001)
                
                MasterMatrix(index_y, index_x, 1) =  frame(j+1, i+1);
            end
            
        end
        
    end
        pause(0.0001);
        %delete(ls1)
        %ls1 = surf(MasterMatrix(:,:,1));
        set(ls1, 'ZData', MasterMatrix(:,:,1));
        set(ls2, 'ZData', frame);
        %delete(ls2)
        %ls2 = surf(frame);
    
end
