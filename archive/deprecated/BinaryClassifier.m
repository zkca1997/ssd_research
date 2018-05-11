function BinaryClassifier(runinfo)
% Takes in raw power signal recordings and trains a classifier model
% runinfo is a struct that contains all run parameters
%
% runinfo.directory    -- string of working directory path
% runinfo.firmwareA    -- string of firmware A directory path
% runinfo.firmwareB    -- string of firmware B directory path
% runinfo.outputdir    -- string of output directory path
% runinfo.fs           -- sampling frequency
% runinfo.threshhold   -- point below which data is "idle" and cut
% runinfo.num_vars     -- number of freq bin variables
% runinfo.trial_length -- seconds that compose one signal trial "slice"
% runinfo.window       -- pwelch window
% runinfo.dim          -- dimensions to reduce to from num_vars
% runinfo.plotdim      -- three dimensions to plot in space
% runinfo.num_test     -- number of hold one tests to run (0 = max)
% runinfo.TEST         -- 'Yes' to run Hold One Test, 'No' otherwise
% runinfo.TRIM         -- 'Yes' to force retrimming of raw, 'No' otherwise

  % CLASSIFIER PARAMETERS
  directory = runinfo.directory;
  firmwareA = runinfo.firmwareA;
  firmwareB = runinfo.firmwareB;
  outputdir = runinfo.outputdir;
  fs = runinfo.samp_freq;
  threshhold = runinfo.threshhold;
  num_vars = runinfo.num_vars;
  trial_length = runinfo.trial_length;
  window = runinfo.slide_window;
  dim = runinfo.dimension;
  plotdim = runinfo.plot_dims;
  num_test = runinfo.num_test;
  TEST = runinfo.hold1_test;
  TRIM = runinfo.gen_fmatrix;

  % make output directory
  if ~exist([directory, outputdir], 'dir')
      mkdir([directory, outputdir]);
  end

  % make output files
  outputdir = [directory, outputdir];
  savefile = [outputdir, 'feature_matrix.mat'];
  modelfile = [outputdir, 'model.mat'];
  resulttxt = [outputdir, 'results.txt'];
  varfig = [outputdir, 'varfig.png'];
  spacefig = [outputdir, 'spacefig.png'];

  % print out run parameters to output file
  tmp1 = struct2table(runinfo);
  tmp1 = tmp1.Properties.VariableNames';
  tmp2 = struct2cell(runinfo);
  tmp = array2table(horzcat(tmp1, tmp2));
  writetable(tmp, resulttxt, 'Delimiter', '\t');
  fid = fopen(resulttxt, 'a');

  close all;  % clean up

  % TAKE THE RAW DATA, LABEL IT, AND SAVE IT IN A USABLE FORMAT
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Check to see if a file of trimmed data already exists
  fileList = dir(outputdir);
  fileValid = false;
  for i = 1:length(fileList)
     if contains(fileList(i).name, 'feature_matrix.mat')
         fileValid = true;
         break;
     end
  end

  % if the data is already loaded, move on
  if exist('binA', 'var') && exist('binB', 'var') && strcmp(TRIM, 'No')
  % else if the file exists and is desired, load it
  elseif fileValid && strcmp(TRIM, 'No')
      load(savefile);
  % else compress and trim the data from raw input
  else
      tic;

      % compress firmwares and create feature matrix
      firmA = DataCompress( [directory, firmwareA], threshhold );
      binA  = SignalToFeatureMatrix( firmA, num_vars, trial_length, window, fs);
      clear firmA;

      firmB = DataCompress( [directory, firmwareB], threshhold );
      binB  = SignalToFeatureMatrix( firmB, num_vars, trial_length, window, fs);
      clear firmB;

      % save the data for next time
      save(savefile, 'binA', 'binB', '-V7.3');

      printTime('Featuring');
  end
  % CREATE A GLOBAL TRAINING SET
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  tic;

  globalSet = vertcat(binA, binB);
  globalLabel = vertcat(true(size(binA,1),1), false(size(binB,1),1));

  % CREATE A MODEL FROM THE GLOBAL DATA
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  [MODEL, NORM, S, C, E] = CreateModel(globalSet, globalLabel, 7);

  % SAVE ALL RELEVANT INFORMATION INTO A DUMP FILE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  save(modelfile, 'MODEL', 'NORM', 'S', 'C', 'E');

  printTime('Training');
  tic;

  % RUN A "HOLD ONE" CLASSIFIER TEST ON EACH DATA POINT
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if strcmp(TEST, 'Yes')
    results = TestClassifier(globalSet, globalLabel, num_test, dim);
    accuracy = mean(results);
    fprintf(fid, 'Number of Hold-One Tests: %g\n', num_test);
    fprintf(fid, 'Mean Accuracy of Classification: %g\n', accuracy);
  end

  % GENERATE RESULT REPORT AND VISUALS
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %close all;
  CompareHist(globalSet, globalLabel, [1,4,6,7], 1);
  % CompareHist(globalSet, globalLabel, 1:(dim+1), 1);
  %saveas(gcf, varfig, 'png');

  %close all;
  %PlotFeatures(globalSet, globalLabel, plotdim, 1);
  %saveas(gcf, spacefig, 'png');

  fprintf(fid, '%s Data Points: %g\n', firmwareA, size(binA,1));
  fprintf(fid, '%s Data Points: %g\n', firmwareB, size(binB,1));
  fprintf(fid, '\n');

  type(resulttxt);

  % end of script / Nested Functions to Follow
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  function results = TestClassifier(set, label, n, dim)

    if n == 0; test_set = 1:length(set);
    else; test_set = randi(length(set), 1, n); end
    num_test = length(test_set);

    h = waitbar(0, 'Model Testing Status');
    tic;

    for i = 1:num_test
      results(i) = HoldOneTest(set, label, test_set(i), dim);
      waitbar(i / num_test);
    end

    close(h);
    printTime('Testing');
  end

  function printTime(name)
    tmp = toc;
    minutes = floor(tmp / 60);
    seconds = floor( tmp - (minutes * 60));
    fprintf(fid, '%s Runtime: %d minutes %d seconds\n', name, minutes, seconds);
  end

end
