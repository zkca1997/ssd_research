The contents of this directory are responsible for data collection using the experimental design described in [enter conference paper title].

CONTENTS:

run_trial.py		This is a python 2.7 script that automates a series of SSD read and write operations.
EmptyStandbyList.exe	This is a Windows executable that clears the RAM cache of the host operating system that runs it.  This is used to guarantee independence between consecutive trials.

Oscilloscope Setup (using Gen3 High Speed Recorder):

1.  Open "Perception" application on Gen3 High Speed 

2.  File -> Open Virtual Workspace: Select "MIDN_RESEARCH.vwb"

3.  Configure the output folder and file type as appropriate (Automation -> Automatic Batch Recording...)

4.  Ensure the TCPA300 Amplifier is configured correctly (green light next to "Probe Degauss Autobalance")

OPERATION:

1.	Move the contents of this directory to the test SSD

2.	Open 'run_trial.py' in an editor and scroll to the main function (line 72)

3.	Edit Trial Parameters (all variables in comment box) as such:
	a. trigger_on:	the serial port that triggers the Data Recorder to begin recording
	b. trigger_off:	the serial port that triggers the Data Recorder to end recording
	c. trials:	the number of trials to run (if this is 10, then 10 read trials and 10 write trials will be recorded for each file size tested)
	d. sizes:	the files sizes to test (enter values in MB)
	e. floc:	the directory of the test SSD (generally the location of this script)
	f. rloc:	the directory where the SSD will read and write to (must not be on the SSD's path). generally the C:\ directory
	g. start:	the number of seconds to begin recording prior to the SSD operation being triggered
	h. stop:	the number of seconds to continue recording after the python script receives a return value from the SSD operation (assume that this is immediately)
	j. wait:	the number of seconds to idle between trials (must be sufficiently long for the EmptyStandbyList.exe executable to clear the RAM cache)

4.	Open a command prompt (cmd or PowerShell) in administrator mode

5.	Navigate to the directory of run_trial.py and run ./run_trial.py
	
