close all;
top_dir = '/home/tkirk/Research/data/proto/';

%% load in dataset if not already loaded
if exist('feat_matrix', 'var') && exist('labels', 'var')
elseif exist(fullfile(top_dir, 'dataset.mat'), 'file')
	load(fullfile(top_dir, 'dataset.mat'));
else
	[feat_matrix, labels] = ParseFileHeirarchy(top_dir);
	save(fullfile(top_dir, 'dataset.mat'), 'feat_matrix', 'labels');
end

%% compress feature space via PCA
% tic;
% C = ipca(feat_matrix, 0.9);
% figure(1);
% heatmap(C');
% colormap(jet);
% pca_time = toc;
% fprintf("PCA Time: %g\n", pca_time);

%% compress feature space via autoencoder
%tic;
%autoenc = trainAutoencoder(feat_matrix', 10);
%autoenc_time = toc;
%save('autoenc10.mat', 'autoenc');
% load('autoenc10.mat');
% figure(2);
% heatmap(autoenc.EncoderWeights);
% colormap(jet);
% fprintf("Autoencoder Time: %g\n", autoenc_time);