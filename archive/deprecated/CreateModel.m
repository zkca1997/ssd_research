function [model, set_mean, S, C, E] = CreateModel(trainSet, trainLabel, D)
%USAGE: model = createModel(trainSet, trainLabel, D)
%model: a MATLAB object that can be used in the "predict" function
%trainSet:  n x m matrix of n samples and m variables
%trainLabel: nx1 vector of boolean labels (Class A or NOT Class A)
%D: number of dimension of trainSet to train on

  % normalize the training set to have variable means of zero (This is actually
  % redundant, PCA will do this in the next step, it is explicitly defined here
  % in order to make clear why we normalize the testVal later)
  set_mean = mean(trainSet);
  trainSet = trainSet - repmat(set_mean, size(trainSet,1), 1);

  [C, S, E] = pca(trainSet); % Principle Component Analysis

  S = S(:,1:D);  % retain only D dimension of score matrix to train on

  model = fitclinear(S, trainLabel, 'Learner', 'logistic');  % generate the model

end
