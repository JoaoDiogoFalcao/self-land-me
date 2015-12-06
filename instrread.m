function instrread(s, event, mode, cur_cols, cur_rows, ls)
    if(mode==1 && s.BytesAvailable > 22) % Header
        cur_altitude = fread(s, 1, 'uint8');
        cur_heading = fread(s, 1, 'uint16');
        cur_heading = swapbytes(uint16(cur_heading));
        cur_rows = fread(s, 1, 'uint16');
        cur_rows = swapbytes(uint16(cur_rows));
        cur_cols = fread(s, 1, 'uint16');
        cur_cols = swapbytes(uint16(cur_cols));
        cur_lat = fread(s, 1, 'float64');
        cur_lat = swapbytes(cur_lat);
        cur_lng  = fread(s, 1, 'float64');
        cur_lng = swapbytes(cur_lng);
        
        % Print Output
        %fprintf('Incoming Packet\n-----------------\nAltitude: %i\nHeading: %i\nMap: %i x %i (%i)\nLocation: %0.04d,%0.04d\n-----------------\n', ...
        %    cur_altitude,cur_heading,cur_rows,cur_cols, ceil((double(cur_rows)*double(cur_cols))/8),cur_lat,cur_lng);
        
        % Ready for the Map
        s.BytesAvailableFcn = {'instrread', 2,cur_cols,cur_rows, ls}; % 2 for Map
    else
        %fprintf('Bytes Available: %i, ColsxRows: %i x %i = %i\n', s.BytesAvailable, cur_cols, cur_rows,cur_cols*cur_rows);
        if(s.BytesAvailable > ((cur_cols*cur_rows)/8)-1)
            %fprintf('Available: %i\nReading Map: %i\n', s.BytesAvailable, ceil((double(cur_rows)*double(cur_cols))/8));
            map_s = fread(s, ceil((double(cur_rows)*double(cur_cols))/8), 'uint8');            
            map_b = dec2bin(map_s, 8);
            map_n = uint8(zeros(cur_cols*cur_rows, 1));
    
            for i=1:size(map_b, 1)
              for j=1:size(map_b, 2)
                  index = j+((i-1)*size(map_b, 2));
                  if(index-1 < cur_cols*cur_rows)
                    map_n(index) = uint8(map_b(i,j))-48;
                  end
              end
            end 
            map = vec2mat(map_n, cur_cols)';
            delete(ls);
            ls = surf(map);
            pause(0.000001);
            s.BytesAvailableFcn = {'instrread', 1,80,20,ls}; % 1 for New Header
        end
    end
    
end