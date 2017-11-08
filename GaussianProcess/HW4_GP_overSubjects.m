clear; close all; clc;
root = './data_GP';
Root=dir(root);
x = [];
frame = [];
sample_rate = 10;
real_data = [];

for i=4:length(Root)
   cur_path = strcat(root, '/',Root(i).name);
   Blocks = dir(cur_path);
   for j=4:length(Blocks)
       cur_path2 = strcat(cur_path, '/',Blocks(j).name);
       data = dir(cur_path2);
       data_path = strcat(cur_path2, '/',data(length(data)).name);
       cur_data = csvread(data_path, 1, 0);
       Marker1_x = cur_data(:, 12);
       frame_cur = cur_data(:, 1);
       
       Marker1_x_Train = downsample(Marker1_x, sample_rate);
       frame_Train = downsample(frame_cur, sample_rate);
       
       x = vertcat(x, Marker1_x_Train);
       frame = vertcat(frame, frame_Train);
       real_data = horzcat(real_data, Marker1_x_Train);
   end
   
end

%% GP
sigma = [1, 0.2, 1];
kfcn = @(t1,t2,sigma) (exp(sigma(1)))*exp(-(pdist2(t1,t2).^2)*(0.5*exp(sigma(2)))) + exp(sigma(3));

frame_train = frame(:, 1);
x_train = x(:, 1);

gprMdl = fitrgp(frame_train, x_train,...
      'FitMethod','exact','PredictMethod','exact', ...
      'KernelFunction',kfcn,'KernelParameters', sigma); 
%{  
gprMdl = fitrgp(frame, x,...
      'FitMethod','exact','PredictMethod','exact', ...
      'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',...
      struct('AcquisitionFunctionName','expected-improvement-plus'),...
      'KernelFunction',kfcn,'KernelParameters', sigma);  
      %}
  
%% 
% Predict the response corresponding to the rows of |x| (resubstitution
% predictions) using the trained model. 
[ypred,~,yci] = predict(gprMdl, frame_Train);  

%% 
% Plot the true response with the predicted values. 

hold on;
plot(frame_Train, ypred,'b','LineWidth',1.5);
for i=1:size(real_data, 2)
    plot(frame_Train, real_data(:, i),'r');
end


%plot(frame_train, yci(:, 1), 'g--');
%plot(frame_train, yci(:, 2), 'g--');
xlabel('input');
ylabel('output');
legend('GPR predictions', 'Data');
hold off 