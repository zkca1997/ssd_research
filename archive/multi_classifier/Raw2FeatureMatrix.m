function feat_matrix = Raw2FeatureMatrix( file, FilterSignal, CreateFeatures )

  % load file, grab the relevant signal, and dump file data
  load( file, 'Recorder4' );
  raw_signal = Recorder4.Channels.Segments.Data.Samples;
  clear 'Recorder4';

  % filter data with FilterSignal function handle
  filtered_signal = FilterSignal(raw_signal);

  % generate feature matrix with CreateFeatures function handle
  feat_matrix = CreateFeatures(filtered_signal);

end
