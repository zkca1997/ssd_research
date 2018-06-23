directory = '/run/media/tiberius/MediaDrive/Research/data/';

directory = [directory, 'features/'];
cd(directory);

firms = ["000f.mat", "010g.mat"];
iter = 10;

for i = 1:iter
  [accuracy(i), traintime(i), testtime(i)] = FirmwareClassifier(firms);
  fprintf("Trial %d: %g\n", i, tmp(i));
end

fprintf("\nResults:\n");
fprintf("Accuracy:\t%g\n", mean(accuracy));
fprintf("Train Time:\t%s\n", HumanTime(mean(traintime)));
fprintf("Test Time:\t%s\n", HumanTime(mean(testtime)));

function str = HumanTime(raw)
  minutes = floor(raw / 60);
  seconds = raw - (minutes * 60);
  str = sprintf('%d minutes %d seconds', minutes, seconds);
end
