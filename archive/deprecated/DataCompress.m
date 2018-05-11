function data = DataCompress( directory, threshhold )
%USAGE: data = dataCompress( directory, threshhold )
%data: a struct that contains each sample of that firmware run (labeled)
%directory: the directory path of the raw trials to be compressed

% dataCompress decends into the directory passed to it and strips the
% relevant oscilloscope samples out of the raw oscilloscope MATLAB export.
% Next, all "idle" time is removed from each trial,
% meaning that only "active" time is retained.  All the trials are then
% stored in a struct array and returned. (See trimIdle for additional
% information on the parameters of idle vs active).

  fileList = dir(directory);    % fetch all the files in the folder
  counter = 1;       % file counter
  lastfile = length(fileList);

  while ~contains( fileList(counter).name, '.mat' )
    counter = counter + 1;
  end

  data = [];

  for i = counter:lastfile
    tmp = TrimIdle( readTrial(i), threshhold );
    data = horzcat(data, tmp);
  end

  function output = readTrial( findex )
    file = fileList(findex).name;   % fetch filename to be loaded
    load( [directory, file], 'Recorder4' );      % load recorder with our information
    output = Recorder4.Channels.Segments.Data.Samples;
    clear 'Recorder4';              % clear the data
  end

end
