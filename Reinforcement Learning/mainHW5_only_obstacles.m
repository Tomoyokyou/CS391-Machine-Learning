%% HW5 Main - Only Obstacles
clc; clear; close all;
inputPath = 'sidewalk_only_obstacle.mat';

load(inputPath);
[r, c] = size(sidewalk_only_obstacle);
val_litter = 50;
val_obstacle = -50;
plotSidewalk(sidewalk_only_obstacle, r, c, val_litter, val_obstacle);


% Creating Reward Matrix for the Maze 
% Possible actions are:
% 
% * Up     (i-r)
% * Down   (i+r)
% * Left   (i-1)
% * Right  (i+1)
% * Diagonally SE (i+n+1)
% * Diagonally SW (i+n-1)
% * Diagonally NE (i-n+1)
% * Diagonally NW (i-n-1)
% 
% Reward  is -Inf (~No reward) for any other actions. Thus any other action 
% other then above action will not occur.
%
reward=[];
total = r*c;

for i=1:total
    reward=[reward;reshape(sidewalk_only_obstacle, 1, total);];
end
n = r;
for i=1:total
    for j=1:total
        if j~=i-n && j~=i+n && j~=i-1 && j~=i+1 && j~=i+n+1 && j~=i+n-1 && j~=i-n+1 && j~=i-n-1
            reward(i,j)=-Inf;
        end
    end
end

% SARSA algorithm
% * Initialize the Q-matrix.
% * Setting the goal state to be 'n*n'. 
% * Gamma=0.5 and alpha=0.5 (Selected after several runs)
% * Maximum number of iterations (for convergence)
%
q=zeros(size(reward));
gamma=0.5; alpha=0.5; maxItr=200;

% 
% * Repeat until Convergence OR Maximum Iterations
% * cs => current state
% * ns => next state
%
for i=1:maxItr
    
    % Starting from any Random state    
    cs=randi([1 length(reward)],1,1);
    
    % Repeat until Goal state is reached
    while(1)

        % Possible Actions from current state        
        actions=find(reward(cs,:)>0);
    
        % Next State due to possible actions
        ns=actions(randi([1 length(actions)]));
        
        % Possible Actions from Next State
        actions=find(reward(ns,:)>0);
            
        % q value, for action is choosen randomly from all possible actions
        randq=q(ns,actions(randi([1,length(actions)])));

        % Updation of Action-Value Function (SARSA)      
        q(cs,ns)=q(cs,ns)+alpha*(reward(cs,ns)+gamma*randq -q(cs,ns));

        % Break, if Goal state is reached
        if(cs > total-r)
            break;
        end
    
        % Else Current-state is Next-State
        cs=ns;
    end  
end
i
% Solving the maze i.e, finding a path (optimal) from START to GOAL
% * Starting from the first postion
%
maxPathLen = 300;
start=ceil(r/2);move=0;
path = [start];
% 
% * Iterating until Goal-State is reached
%
while(move<=total-r && length(path)<maxPathLen)
    [~,move]=max(q(start,:));
    
    % Deleting chances of getting stuck in small loops    
    if ismember(move,path)
        [~,x]=sort(q(start,:),'descend');
        move=x(2); 
        if ismember(move,path)
            [~,x]=sort(q(start,:),'descend');
            move=x(3);  
        end
    end
    
    % Appending next action/move to the path
    path=[path,move];
    start=move;
end
% Solution of maze i.e, Optimal Path between START to GOAL
%
fprintf('Final Path: %s',num2str(path))
plotSidewalk(sidewalk_only_obstacle, r, c, val_litter, val_obstacle, path);
