function [feat_matrix, labels] = ReadBatch( batch_dir )

  trial_files = dir(AbsPath(batch_dir));
  num = 0;
  for file = trial_files'
      if contains(file.name, '.mat')
         num = num + 1; 
      end
  end

  feat_matrix = zeros(0,300);
  labels(num).batch = 'batch';
  labels(num).firmware = 'firmware';
  labels(num).deviceid = 'deviceid';
  labels(num).devicetype = 'devicetype';
  labels(num).operation = 'operation';
  labels(num).filesize = 'filesize';
  labels(num).trial = 0;
  labels = labels';
  counter = 1;

  fprintf(' > ');
  for trial = trial_files'
    if contains(trial.name, '.mat')

      % load file, grab the relevant signal, and dump file data
      load(AbsPath(trial), 'Recorder4');
      recordings = Recorder4.Channels.Segments.Data.Samples;
      filtered_signal = FilterSignal(recordings);
      feat_matrix = [feat_matrix; CreateFeatures(filtered_signal)];

      % apply label based on a ruleset %
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      % infer batch, firmware, and device ID, and device type from filepath
      info = strsplit(trial.folder, filesep);
      lbl.batch = info{end};
      lbl.firmware = info{end-1};
      lbl.deviceid = info{end-2};
      lbl.devicetype = info{end-3};

      % determine read/write operation
      if mod(counter, 2) ~= 0
        lbl.operation = 'write';
      else
        lbl.operation = 'read';
      end

      % determine filesize
      switch counter
        case num2cell(1:10)
          lbl.filesize = '4MB';
        case num2cell(11:20)
          lbl.filesize = '16MB';
        case num2cell(21:30)
          lbl.filesize = '64MB';
        case num2cell(31:40)
          lbl.filesize = '256MB';
        case num2cell(41:50)
          lbl.filesize = '1024MB';
      end

      % determine trial number
      tmp = mod(counter, 10);
      if tmp == 0
        lbl.trial = 5;
      else
        lbl.trial = ceil(mod(counter, 10) / 2);
      end

      labels(counter) = lbl;

      counter = counter + 1;
      fprintf('.');
    end
  end

  fprintf('\n');
end
