function success = HoldOneTest(trainSet, trainLabel, holdIndex, D)
%USAGE: success = HoldOneTest(trainSet, trainLabel, holdIndex)
%success: boolean (true / false) of whether the classifier trial was accurate
%trainSet: n x m matrix of n trials and m variables
%trainLabel: nx1 vector of boolean labels (Class A or NOT Class A)
%holdIndex: the index of the trial (row) to be tested
%D: number of dimensions to retain

  testVal  = trainSet(holdIndex,:);     % pull one out of the training set
  testResult = trainLabel(holdIndex);   % its correct classification

  trainSet(holdIndex,:) = [];   % delete the held trial from the training set
  trainLabel(holdIndex) = [];   % delete its corresponding label

  % Generate the model
  [model, set_mean, S, C, E] = CreateModel(trainSet, trainLabel, D);

  % take the withheld data point and classify it with the new model
  testVal = testVal - set_mean;  % first normalize the data
  testVal = testVal * C;         % then rotate onto the eigenbasis

  Prediction = predict(model, testVal(1:D));  % make a prediction
  success = (testResult == Prediction); % return whether it was correct

end
