function [train, test] = LoadSelfTest(class_files)

  train.X = [];
  test.X  = [];
  train.label = [];
  test.label  = [];

  class = load(class_files(1));

  num_events = length(class.data);
  num_class  = floor(num_events / 2);
  filesA = ismember(1:num_events, randperm(num_events, num_class));
  filesB = ~filesA;

  verA.data = class.data(filesA);
  verA.firmware = "verA";
  verB.data = class.data(filesB);
  verB.firmware = "verB";

% Ver A
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % load class file
  class = verA;

  % pick events to be part of test set
  num_events = length(class.data);
  test_events = floor(num_events / 10);
  test_set = sort(randperm(num_events, test_events), 'descend');

  % Create Test Set Submatrix
  test_X = double.empty(0,size(class.data(1).feat_matrix,2));
  for i = test_set
    test_X = vertcat(test_X, class.data(i).feat_matrix);
  end
  test_label = repmat(class.firmware, size(test_X, 1), 1);

  % Create Training Set Submatrix
  train_X = double.empty(0,size(class.data(1).feat_matrix,2));
  for i = 1:length(class.data)
    if ~any(i==test_set)
        train_X = vertcat(train_X, class.data(i).feat_matrix);
    end
  end
  train_label = repmat(class.firmware, size(train_X, 1), 1);

  % push submatrices to global training and test sets
  train.X = vertcat(train.X, train_X);
  test.X  = vertcat(test.X,  test_X );
  train.label = vertcat(train.label, train_label);
  test.label  = vertcat(test.label,  test_label );

  % Ver B
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % load class file
  class = verB;

  % pick events to be part of test set
  num_events = length(class.data);
  test_events = floor(num_events / 10);
  test_set = sort(randperm(num_events, test_events), 'descend');
  % Create Test Set Submatrix
  test_X = double.empty(0,size(class.data(1).feat_matrix,2));
  for i = test_set
    test_X = vertcat(test_X, class.data(i).feat_matrix);
  end
  test_label = repmat(class.firmware, size(test_X, 1), 1);

  % Create Training Set Submatrix
  train_X = double.empty(0,size(class.data(1).feat_matrix,2));
  for i = 1:length(class.data)
    if ~any(i==test_set)
        train_X = vertcat(train_X, class.data(i).feat_matrix);
    end
  end
  train_label = repmat(class.firmware, size(train_X, 1), 1);

  % push submatrices to global training and test sets
  train.X = vertcat(train.X, train_X);
  test.X  = vertcat(test.X,  test_X );
  train.label = vertcat(train.label, train_label);
  test.label  = vertcat(test.label,  test_label );

end
