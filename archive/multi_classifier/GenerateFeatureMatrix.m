function [feat_matrix, labels] = GenerateFeatureMatrix( classes, topdir )

  feat_matrix = zeros(0, 300);
  labels      = cell(1,2);

  for i = 1:length(classes)

    % get all relevant files from class file directory
    filelist = FindFiles([topdir, '/', char(classes(i))]);

    % for each file, compute the feature matrix for that file
    for j = 1:size(filelist,1)

      % load the file and create a feature matrix
      file = [filelist(j).folder, '/', filelist(j).name];
      file_feat = Raw2FeatureMatrix(file, @TrimTails, @FeaturesA);

      % create a cell array for these features and annotate with labels
      file_label = cell(1,2);
      file_label{1} = repmat(classes(i), size(file_feat,1), 1);
      file_label{2} = j * ones(size(file_feat,1),1);

      % concatenate file's data with global feature and label sets
      feat_matrix = vertcat(feat_matrix, file_feat);
      labels{1}   = vertcat(labels{1}, file_label{1});
      labels{2}   = vertcat(labels{2}, file_label{2});
      
      % report the number of events processed from a file
      fprintf('%d events created from %s\n', size(file_feat,1), filelist(j).name);

    end
  end
end

function filelist = FindFiles(in_dir)
  filelist = dir(in_dir);
  delete = [];
  for i = 1:length(filelist)
    if ~contains( filelist(i).name, '.mat' )
      delete = horzcat(delete, i);
    end
  end
  filelist(delete) = [];
end
