function [accuracy, traintime, testtime] = FirmwareClassifier(class_files)

  close all;

% Create Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  var = 0.95;   % variance of data to capture in prediction model
  numneigh = 5; % 3 nearest neighbors

  % Load in relevant data into a training and test set
  [train, test] = LoadFeatures(class_files);

  % Create a Model from the Training Set
  tic;
  %[model, set_mean, S, C, E, D] = LogisticModel(train, var);
  %[model, set_mean, S, C, E, D] = DiscriminantModel(train, var);
  [model, set_mean, S, C, E, D] = KnnModel(train, var, numneigh);
  traintime = toc;
  %fprintf("Dimension #: %d\t", D);

% Test Classifier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  tic;
  % transform feature space to PCA basis
  test.X = test.X - set_mean;  % first normalize the data
  test.X = test.X * C;         % then rotate onto the eigenbasis

  % estimate the accuracy of the classifier model
  class = predict(model, test.X(:,1:D));  % predict class of test points
  success = (class == test.label);       % logical array of results
  accuracy = sum(success) / length(success);  % compute accuracy of model

  testtime = toc;

% Gemerate Reports and Visuals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  label = strcmp(test.label, test.label(1));
  CompareHist(test.X, label, [1,2,3,4], 1);
  PlotFeatures(test.X, label, [1,2,3], 2);

  %fprintf('Retained Principal Components: %d\n', D);
  %fprintf('ACCURACY ESTIMATE: %g\n', accuracy);

end
