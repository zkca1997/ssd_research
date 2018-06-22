%% Header

% relevant directories
code_dir = 'G:\Team Drives\SSD Research\Walker - Reproduce Johnson Work, 2018-06\ssd_research-master_Johnson-Walker\classification';
data_dir = 'G:\Team Drives\SSD Research\Walker - Reproduce Johnson Work, 2018-06\test_1';
work_dir = 'G:\Team Drives\SSD Research\Walker - Reproduce Johnson Work, 2018-06\test_1';
classes = ["000f", "010g", "040h", "070h", "0309"];
datafile = [work_dir, '/features.mat'];

% generate feature matrix if it doesn't exist
if( ~exist('feat_matrix','var') || ~exist('labels','var') )
   if exist(datafile, 'file')
       load(datafile);
   else
       [feat_matrix, labels] = GenerateFeatureMatrix( classes, data_dir );
       save(datafile, 'feat_matrix', 'labels');
   end
end

% dimensional information of dataset
k = length(classes);
n = size(feat_matrix, 1);
p = size(feat_matrix, 2);

close all;  % close old figures
tic;        % start timer

%% Evaluate the Performance of Each Binary Classification Pair

comb = combnk(classes, 2);

for i = 1:size(comb,1)
    
    % reduce features to selected classes
    mask = false(n,1);
    for j = 1:size(comb,2)
        mask = mask | strcmp(labels{1}, comb(i,j));
    end
    X = feat_matrix(mask,:); Y = labels{1}(mask);
    
    % report performance of binary classifier on subset of classes
    % This is where we choose the classifier and reduction technique
    performance(i) = CrossValTest(X, Y, @model_IPCA_QDA);
end

%% Footer
toc;    % stop timer