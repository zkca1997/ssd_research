function [feat_matrix, labels] = GenerateFeatureMatrix( classes, topdir )

  feat_matrix = zeros(0, 300);
  labels      = cell(1,3);

  for i = 1:length(classes)

    % get all relevant files from class file directory
    filelist = FindFiles(strcat(topdir, classes(i)));

    % for each file, compute the feature matrix for that file
    for j = 1:size(filelist,1)

      % load the file and create a feature matrix
      file = [filelist(j).folder, '/', filelist(j).name];
      file_feat = Raw2FeatureMatrix(file, @TrimTails, @FeaturesA);

      % create a cell array for these features and annotate with labels
      % {class string, device ID, trial #, operation, filesize}
      
      file_label = cell(1,3);
      file_label{1} = repmat(classes(i), size(file_feat,1), 1);
      file_label{3} = j * ones(size(file_feat,1),1);

      if mod(file_label{2}, 2) == 1
        file_label{4} = repmat("write", size(file_feat,1), 1);
      else
        file_label{5} = repmat("read", size(file_feat,1), 1);
      end

      % concatenate file's data with global feature and label sets
      feat_matrix = vertcat(feat_matrix, file_feat);
      labels{1}   = vertcat(labels{1}, file_label{1});
      labels{2}   = vertcat(labels{2}, file_label{2});
      labels{3}   = vertcat(labels{3}, file_label{3});

      % report the number of events processed from a file
      fprintf('%d events created from %s\n', size(file_feat,1),...
          filelist(j).name);

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

function feat_matrix = Raw2FeatureMatrix( file, FilterSignal,...
    CreateFeatures )

  % load file, grab the relevant signal, and dump file data
  load( file, 'Recorder4' );
  raw_signal = Recorder4.Channels.Segments.Data.Samples;
  clear 'Recorder4';

  % filter data with FilterSignal function handle
  filtered_signal = FilterSignal(raw_signal);

  % generate feature matrix with CreateFeatures function handle
  feat_matrix = CreateFeatures(filtered_signal);

end
