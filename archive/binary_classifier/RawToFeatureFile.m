function RawToFeatureFile( firmware, in_dir, out_file )

  tic;

  % Define Feature Creation Function Parameters Here in Struct 'info'
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  info.fs = 200000;
  info.trial_length = 0.05;
  info.window = 0.01;
  info.num_vars = 300;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  filelist = FindFiles(in_dir);

  for i = 1:length(filelist)
    tmp = ReadTrial(filelist(i));
    data(i).feat_matrix = FeaturesA(tmp, info);
  end

  save(out_file, 'firmware', 'data');

  runtime = toc;
  minutes = floor(runtime / 60);
  seconds = floor( runtime - (minutes * 60));
  fprintf('%s feature creation time: %d minutes %d seconds\n', firmware, minutes, seconds);

end

function output = ReadTrial( file )
  load( [file.folder, '/', file.name], 'Recorder4' );
  output = Recorder4.Channels.Segments.Data.Samples;
  clear 'Recorder4';              % clear the data
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
