%% Create a sidewalk

% Initial parameters
width = 10;
length = 10;
val_litter = 2;
val_obstacle = -50;
val_end = 10;
obstacleNum = 10;
litterNum = 10;

filename = 'sidewalk_3.mat';
filename2 = 'sidewalk_only_obstacle_3.mat';
filename3 = 'sidewalk_only_litter_3.mat';



sidewalk = ones(width, length);

% assign value to the end of the sidewalk
for i=1:width
    sidewalk(i, length) = val_end;
end

% randomly add obstacles

for i=1:obstacleNum
    r = randi([2, width-1]);
    c = randi([2, length-1]);
    while (sidewalk(r, c)~=1)
        r = randi([2, width-1]);
        c = randi([2, length-1]);
    end
    sidewalk(r, c) = val_obstacle;
end

% randomly add litter objects

for i=1:litterNum
    r = randi([2, width-1]);
    c = randi([2, length-1]);
    while (sidewalk(r, c)~=1)
        r = randi([2, width-1]);
        c = randi([2, length-1]);
    end
    sidewalk(r, c) = val_litter;
end

sidewalk_only_obstacle = zeros(width, length);
for i=1:width
    for j=1:length
        if(sidewalk(i, j) == val_obstacle)
            sidewalk_only_obstacle(i, j) = val_obstacle;
        end
    end
end

sidewalk_only_obstacle = ones(width, length);
for i=1:width
    for j=1:length
        if(sidewalk(i, j) == val_obstacle)
            sidewalk_only_obstacle(i, j) = val_obstacle;
        end
    end
end

% assign value to the end of the sidewalk
for i=1:width
    sidewalk_only_obstacle(i, length) = val_end;
end

sidewalk_only_litter = ones(width, length);
for i=1:width
    for j=1:length
        if(sidewalk(i, j) == val_litter)
            sidewalk_only_litter(i, j) = val_litter;
        end
    end
end
% assign value to the end of the sidewalk
for i=1:width
    sidewalk_only_litter(i, length) = val_end;
end


save(filename, 'sidewalk');
save(filename2, 'sidewalk_only_obstacle');
save(filename3, 'sidewalk_only_litter');
