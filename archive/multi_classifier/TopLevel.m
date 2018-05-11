close all;
topdir = '/home/tkirk/Research/data/active';
classes = ["000f", "010g", "040h", "070h", "0309"];
datafile = [topdir, '/features.mat'];

tic;    % start timer

%% generate feature matrix if it doesn't exist
if( exist('feat_matrix','var') && exist('labels','var') )
elseif( exist(datafile, 'file') ); load(datafile); 
else
   [feat_matrix, labels] = GenerateFeatureMatrix( classes, topdir );
   save(datafile, 'feat_matrix', 'labels');
end

%% dimensional information of dataset
k = length(classes);
n = size(feat_matrix, 1);
p = size(feat_matrix, 2);
p1 = (k^2 - k)/2;

%% evaluate performance of classifiers
tic; report_plda_qda = CrossValQDA(feat_matrix, labels, @plda); t_plda_qda = toc
tic; report_mlda_qda = CrossValQDA(feat_matrix, labels, @mlda); t_mlda_qda = toc
tic; report_pcai_qda = CrossValQDA(feat_matrix, labels, @pcai); t_pcai_qda = toc
tic; report_plda_knn = CrossValKNN(feat_matrix, labels, 5, @plda); t_plda_knn = toc
tic; report_mlda_knn = CrossValKNN(feat_matrix, labels, 5, @mlda); t_mlda_knn = toc
tic; report_pcai_knn = CrossValKNN(feat_matrix, labels, 5, @pcai); t_pcai_knn = toc


%% demonstrate difference between PCA and PLDA
% plda_proj = feat_matrix * plda(feat_matrix, labels{1});
% mlda_proj = feat_matrix * mlda(feat_matrix, labels{1});
% pca_proj  = feat_matrix * pca(feat_matrix);
% CompareHist(plda_proj(:,1:4), labels{1}, classes, 'Pairwise LDA');
% CompareHist(pca_proj(:,1:4), labels{1}, classes, 'Multiclass LDA');
% CompareHist(mlda_proj(:,1:4), labels{1}, classes, 'PCA');

%% ROC curve
% N = 1000; 
% resol = 2000;
% str1 = '/home/tkirk/Research/unknown_detect/';
% str2 = '_unknown_detect.png';
% 
% for i = 1:length(classes)
%     
%    % training data and validation set
%    test = strcmp(labels{1},classes(i)); train = ~test;
%    proj_matrix = plda(feat_matrix(train,:), labels{1}(train));
%    
%    % train QDA model
%    model = fitcdiscr(feat_matrix(train,:) * proj_matrix,...
%        labels{1}(train), 'DiscrimType', 'quadratic');
%         
%    % compute log probabilities of each original test point
%    deviant = model.logP(feat_matrix(test,:) * proj_matrix);
%    null    = model.logP(feat_matrix(train,:)* proj_matrix);
% 
%    step = linspace(quantile(null,0.05), quantile(null,0.95), resol);
%    true_positive = zeros(1,resol); false_positive = zeros(1,resol);
%    for j = 1:resol
%       threshold = step(j);
%       for k = 1:10
%          null_sample = datasample(null, N, 'Replace', false);
%          deviant_sample = datasample(deviant, N, 'Replace', false);
%          tmp_t = mean(deviant_sample < threshold);
%          tmp_f = mean(null_sample < threshold);
%       end
%       true_positive(j) = mean(tmp_t);
%       false_positive(j) = mean(tmp_f);
%    end
%    
%    figure(i);
%    hold on;
%    plot(false_positive, true_positive, '.');
%    title(classes(i));
%    xlabel('false positive');
%    ylabel('true positive');
%    saveas(gcf, strcat(str1, classes(i), str2));
%    
% end
%%
toc;    % report runtime