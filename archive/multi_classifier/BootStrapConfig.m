function runinfo = BootStrapConfig()
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

    runinfo.directory = '/home/tkirk/Research/data/';
    runinfo.firmwareA = 'firmwareA/';
    runinfo.firmwareB = 'firmwareB/';
    runinfo.outputdir = 'output';
    runinfo.samp_freq = 200000;
    runinfo.threshhold = 0.3;
    runinfo.num_vars = 300;
    runinfo.trial_length = 0.05;
    runinfo.slide_window = 0.01;
    runinfo.dimension = 7;
    runinfo.plot_dims = [1,2,3];
    runinfo.num_test = 500;
    runinfo.hold1_test = 'No';
    runinfo.gen_fmatrix = 'No';
    
end