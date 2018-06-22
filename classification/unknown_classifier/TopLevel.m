%% ROC curve
N = 1000; 
resol = 2000;
str1 = 'G:\Team Drives\SSD Research\Walker - Reproduce Johnson Work, 2018-06\work\test_1\unknown_detect/';
str2 = '_unknown_detect.png';

for i = 1:length(classes)
    
   % training data and validation set
   test = strcmp(labels{1},classes(i)); train = ~test;
   proj_matrix = pfda(feat_matrix(train,:), labels{1}(train));  % TOWIII: change plda to pfda
   
   % train QDA model
   model = fitcdiscr(feat_matrix(train,:) * proj_matrix,...
       labels{1}(train), 'DiscrimType', 'quadratic');
        
   % compute log probabilities of each original test point
   deviant = model.logP(feat_matrix(test,:) * proj_matrix);
   null    = model.logP(feat_matrix(train,:)* proj_matrix);

   step = linspace(quantile(null,0.05), quantile(null,0.95), resol);
   true_positive = zeros(1,resol); false_positive = zeros(1,resol);
   for j = 1:resol
      threshold = step(j);
      for k = 1:10
         null_sample = datasample(null, N, 'Replace', false);
         deviant_sample = datasample(deviant, N, 'Replace', false);
         tmp_t = mean(deviant_sample < threshold);
         tmp_f = mean(null_sample < threshold);
      end
      true_positive(j) = mean(tmp_t);
      false_positive(j) = mean(tmp_f);
   end
   
   figure(i);
   hold on;
   plot(false_positive, true_positive, '.');
   title(classes(i));
   xlabel('false positive');
   ylabel('true positive');
   saveas(gcf, strcat(str1, classes(i), str2));
   
end