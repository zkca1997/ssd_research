%% Header
close all;  % close old figures
tic;        % start timer

% relevant directories
code_dir = '/home/tkirk/Research/code/classification';	% location of MATLAB scripts on filesystem
data_dir = '/home/tkirk/Research/data/test_1';			% location of dataset on filesystem
work_dir = '/home/tkirk/Research/work/test_1';			% output directory
classes = ["000f", "010g", "040h", "070h", "0309"];		% string names of each class (correspond to directory names in data_dir)
datafile = [work_dir, '/features.mat'];					% this is the location of the feature matrix generated from the raw data files

% generate feature matrix if it doesn't exist

% check if the feature matrix and labels are already variables in the workspace
if( ~exist('feat_matrix','var') || ~exist('labels','var') )
	% if they are not, but a features.mat file exists, load it
   if exist(datafile, 'file')
       load(datafile);
	% if no file exists, generate it from the raw data files (this takes a long time)
   else
		% all signal preprocessing and feature selection is implemented in GenerateFeatureMatrix
       [feat_matrix, labels] = GenerateFeatureMatrix( classes, data_dir );
       save(datafile, 'feat_matrix', 'labels');
   end
end

% dimensional information of dataset
k = length(classes);
n = size(feat_matrix, 1);
p = size(feat_matrix, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPLEMENT YOUR MACHINE LEARNING ALGORITHM HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Footer
toc;    % stop timer