runinfo = BootStrapConfig();

% RUN4 Changing Variable Number Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

runinfo.directory = '/home/tkirk/Research/data/RUN4/';
runinfo.num_test = 1000;
runinfo.threshhold = 0.3;
runinfo.dimension = 3;
runinfo.plot_dims = [1,2,3];
runinfo.hold1_test = 'Yes';
runinfo.gen_fmatrix = 'Yes';

% 070H vs 0309 Test
runinfo.firmwareA = 'trial_1/0309/';
runinfo.firmwareB = 'trial_1/070h/';
runinfo.outputdir = '0309V070h/';
BinaryClassifier(runinfo);

% 070H vs 000F Test
runinfo.firmwareA = 'trial_1/000f/';
runinfo.firmwareB = 'trial_1/070h/';
runinfo.outputdir = '000fV070h/';
BinaryClassifier(runinfo);

% 070H vs 070H Test
runinfo.firmwareA = 'trial_1/070h/';
runinfo.firmwareB = 'trial_2/070h/';
runinfo.outputdir = '070hSelfTest/';
BinaryClassifier(runinfo);
