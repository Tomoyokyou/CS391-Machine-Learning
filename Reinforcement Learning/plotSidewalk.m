%% Plot a sidewalk
function plotSidewalk(sidewalk, w, l, val_litter, val_obstacle, path)
    figure;
    hold on;
    
    for i = 1:w
        for j = 1:l
            if(sidewalk(i, j)==val_litter)
                plot(j, i, 'r*', 'DisplayName','litter')
            elseif(sidewalk(i, j)==val_obstacle)
                plot(j, i, 'bo', 'DisplayName','obstacle');
            end
        end
    end
    
    if exist('path','var')
     % third parameter does not exist, so default it to something
      pathX = zeros(length(path), 1);
      pathY = zeros(length(path), 1);
      for i = 1:length(path)
          pathX(i) = ceil(path(i)/w);
          pathY(i) = mod(path(i), w);
          if(pathY(i)==0)
              pathY(i) = w;
          end
      end
      
      plot(pathX, pathY, 'g-', 'DisplayName','Path')
    end
    
    axis([0 l 0 w])
    title('Sidewalk');
    xlabel('x');
    ylabel('y');
    %legend('show');
    hold off;
end
