% reduction technique performance battery
% polychotomous

topdir = '/home/tkirk/Research/data/active';
classes = ["000f", "010g", "040h", "070h", "0309"];
datafile = [topdir, '/features.mat'];

tic;    % start timer

% generate feature matrix if it doesn't exist
if( exist('feat_matrix','var') && exist('labels','var') )
elseif( exist(datafile, 'file') ); load(datafile);
else
   [feat_matrix, labels] = GenerateFeatureMatrix( classes, topdir );
   save(datafile, 'feat_matrix', 'labels');
end

error = bootstrp(1000, @MyClassifier, feat_matrix, labels{1});

function error = MyClassifier(X,Y)
    tic;
    % generate a model with training set
    proj_matrix = plda(X, Y);
    tmp_model = fitcdiscr(X * proj_matrix, Y, 'DiscrimType', 'quadratic');

    % run model on test set
    predicted = tmp_model.predict(X * proj_matrix);
    error = 1 - mean(strcmp(predicted, cellstr(Y)));
    toc
end
