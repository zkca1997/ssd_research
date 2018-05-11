function [model, set_mean, S, C, E, D] = LogisticModel(train, var)

  % normalize training data before Prinpical Component Analysis
  set_mean = mean(train.X);
  train.X = train.X - repmat(set_mean, size(train.X,1), 1);

  % Principal Component Analysis
  [C, S, E] = pca(train.X);

  % Find the minimum number of principal components to retain in order
  % to capture 'var' variance of the data set
  for i = 1:size(E,1)
    var_ratio = sum(E(1:i)) / sum(E);
    if (var_ratio > var)
      D = i;
      break;
    end
  end

  % Reduce the dimensionality of the data set to the 1st D principal components
  S = S(:,1:D);

  % train a logistic regression classifier model
  model = fitclinear(S, train.label, 'Learner', 'logistic');

end
