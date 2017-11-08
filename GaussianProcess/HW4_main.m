clc; clear; close all;
% HW4 Main
file = './data_GP/AG/block1-UNWEIGHTED-SLOW-NONDOMINANT-RANDOM/20161213203046-59968-right-speed_0.500.csv';
M = csvread(file, 1, 0);
%0_x column
Marker1_x = M(:, 12);
frame = M(:, 1);
sample_rate = 10;
Marker1_x_Train = downsample(Marker1_x, sample_rate);
frame_Train = downsample(frame, sample_rate);


%% 
% Fit a GPR model using a linear basis function and the exact fitting method
% to estimate the parameters. Also use the exact prediction method. 

% sigma(0) = sigma_f, sigma(1) = sigma_l and sigma(2) = sigma_n respectively
sigma = [1, 0.2, 1];
kfcn = @(t1,t2,sigma) (exp(sigma(1)))*exp(-(pdist2(t1,t2).^2)*(0.5*exp(sigma(2)))) + exp(sigma(3));

gprMdl = fitrgp(frame_Train, Marker1_x_Train,...
      'FitMethod','exact','PredictMethod','exact', ...
      'KernelFunction',kfcn,'KernelParameters', sigma);  
gprMdl2 = fitrgp(frame_Train, Marker1_x_Train,...
      'FitMethod','exact','PredictMethod','exact', ...
      'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',...
      struct('AcquisitionFunctionName','expected-improvement-plus'),...
      'KernelFunction',kfcn,'KernelParameters', sigma); 

%% 
% Predict the response corresponding to the rows of |x| (resubstitution
% predictions) using the trained model. 
[ypred,~,yci] = resubPredict(gprMdl);  
[ypred2,~,yci2] = resubPredict(gprMdl2); 

%% 
% Plot the true response with the predicted values. 
plot(frame_Train, Marker1_x_Train,'b.');
hold on;
plot(frame_Train, ypred2,'r','LineWidth',1.5);
%plot(frame_Train, ypred2,'y','LineWidth',1.5);
plot(frame_Train, yci2(:, 1), 'r--');
plot(frame_Train, yci2(:, 2), 'r--');
%plot(frame_Train, yci2(:, 1), 'y--');
%plot(frame_Train, yci2(:, 2), 'y--');
xlabel('input');
ylabel('output');
legend('Data','GPR predictions','95% lower', '95% upper');
hold off 

%% HW4_3
file2 = './data_GP/EK/block1-UNWEIGHTED-SLOW-NONDOMINANT-RANDOM/20161219122022-59968-right-speed_0.500.csv';
M = csvread(file2, 1, 0);
%0_x column
Marker1_x = M(:, 12);
frame = M(:, 1);
sample_rate = 10;
Marker1_x_Train = downsample(Marker1_x, sample_rate);
frame_Train = downsample(frame, sample_rate);

gprMdl = fitrgp(frame_Train, Marker1_x_Train,...
      'FitMethod','exact','PredictMethod','exact', ...
      'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',...
      struct('AcquisitionFunctionName','expected-improvement-plus'),...
      'KernelFunction',kfcn,'KernelParameters', sigma); 
[ypred,~,yci] = resubPredict(gprMdl); 
plot(frame_Train, Marker1_x_Train,'b.');
hold on;
plot(frame_Train, ypred,'r','LineWidth',1.5);
plot(frame_Train, yci(:, 1), 'r--');
plot(frame_Train, yci(:, 2), 'r--');
xlabel('input');
ylabel('output');
legend('Data','GPR predictions', '95% lower', '95% upper');
hold off 