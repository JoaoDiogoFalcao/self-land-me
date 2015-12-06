function align_images(firstImage, marker, Timestamp, mission)

period = (Timestamp(marker)-Timestamp(marker-1))*24*3600;
period_images = 0.665;%(12*60)/1071;

travel = 0;
iterator = marker;
    while iterator<size(Timestamp, 1)
        source = sprintf('Drone1/Raw/G%07i.JPG', firstImage);
        destination = sprintf('Drone1/Aligned/%i-%i.JPG', mission, iterator);
        copyfile(source, destination);

        iterator = iterator + period_images/period + travel;
        travel = iterator;
        iterator = floor(iterator);
        travel = travel - iterator;
        fprintf(1,'%i\n', iterator);
        %datestr(Timestamp(iterator))
        firstImage = firstImage + 1;
    end
    
    
    
end