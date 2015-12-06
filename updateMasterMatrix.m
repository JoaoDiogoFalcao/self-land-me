function updateMasterMatrix(frame, heading, cols, rows, center_frame, origin, droneSize)

    MasterMatrix = zeros(1000,1000,2);
    

 



            total_votes[abs(int((grid_origin[0] - shifted_lat_y) / lat_degrees_per_LZ_y)), abs(int((grid_origin[1] - shifted_lon_x) / lon_degrees_per_LZ_x))] += 1

    origin_frame = zeros(2,1);
    Beta = 360-heading;
    d=sqrt(((cols)/2)^2+((rows)/2)^2);
    Teta = atand(cols/rows);
    alpha = 180 - (Teta+Beta);
    x_distance = d*sind(alpha);
    y_distance = d*cosd(alpha);

    lat_degrees_per_LZ_y = droneSize(1) * (1 / (110.54 * 1000));
    lon_degrees_per_LZ_x = droneSize(2) * (1 / (111.320 * cosd(origin(1)) * 1000));

    if(0 <= heading < 90)
        origin_frame(2) = center_frame(2) - lon_degrees_per_LZ_x*x_distance;
        origin_frame(1) = center_frame(1) + lat_degrees_per_LZ_y*y_distance;
    end
    if(90 <= heading < 180)
        origin_frame(2) = center_frame(2) - lon_degrees_per_LZ_x*x_distance;
        origin_frame(1) = center_frame(1) - lat_degrees_per_LZ_y*y_distance;
    end
    if(180 <= heading < 270)
        origin_frame(2) = center_frame(2) + lon_degrees_per_LZ_x*x_distance;
        origin_frame(1) = center_frame(1) - lat_degrees_per_LZ_y*y_distance;
    end
    if(270 <= heading < 360)
        origin_frame(2) = center_frame(2) + lon_degrees_per_LZ_x*x_distance;
        origin_frame(1) = center_frame(1) + lat_degrees_per_LZ_y*y_distance;
    end

    
    
    pos_index = zeros(2,1);
    for i=0:rows-1
        for j=0:cols-1
            pos_index(2) = (j*lon_degrees_per_LZ_x) * cosd(360-alpha) - (i*lat_degrees_per_LZ_y) * sind(360-alpha) + origin_frame(2);
            pos_index(1) = (j*lon_degrees_per_LZ_x) * sind(360-alpha) + (i*lat_degrees_per_LZ_y) * cosd(360-alpha) + origin_frame(1);
            
            index_y = abs(floor(( origin(1) - pos_index(1) ) / lat_degrees_per_LZ_y));
            index_x = abs(floor(( origin(2) - pos_index(2) ) / lon_degrees_per_LZ_x));
            
            if(index_x < 1001)
            
           MasterMatrix(y, x, 1) = MasterMatrix(y, x, 1) + map(row, col); 
            
        end
    end
    
    
       total_flight_area[abs(int((grid_origin[0] - shifted_lat_y) / lat_degrees_per_LZ_y)), abs(int((grid_origin[1] - shifted_lon_x) / lon_degrees_per_LZ_x))] += not not decision_grid[row, col]
    
    
end
