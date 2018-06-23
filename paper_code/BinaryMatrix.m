directory = '/run/media/tiberius/MediaDrive/Research/data/';

% RawToFeatureFile("040h", [directory, '040h'], [directory, 'features/040h.mat']);
% RawToFeatureFile("0309", [directory, '0309'], [directory, 'features/0309.mat']);
% RawToFeatureFile("070h", [directory, '070h'], [directory, 'features/070h.mat']);
% RawToFeatureFile("010g", [directory, '010g'], [directory, 'features/010g.mat']);
% RawToFeatureFile("000f", [directory, '000f'], [directory, 'features/000f.mat']);

directory = [directory, 'features/'];
cd(directory);

firms = ["000f.mat", "010g.mat", "070h.mat", "0309.mat", "040h.mat"];
iter = 10;
Ls = length(firms);
maxnum = 30;
looptime = [];

tic;
results = zeros(Ls);

for i = 1:Ls
   for j = i+1:Ls
       for n = 1:iter
           tmp(n) = FirmwareClassifier([firms(i), firms(j)]);
           fprintf('i=%d\tj=%d\tn=%d\n',i,j,n);
       end
       results(j,i) = mean(tmp);
       results(i,j) = results(j,i);
   end
end

for i = 1:Ls
   for n = 1:iter
      tmp(n) = FirmwareClassifier(firms(i));
      fprintf('i=%d\tn=%d\n',i,n);
   end
   results(i,i) = mean(tmp);
end

disp(results)

% unary(numneigh) = 0;
% for i = 1:length(firms); unary(numneigh) = unary(numneigh) + results(i,i); end
% binary(numneigh) = (sum(sum(results)) - (unary(numneigh))) / (Ls^2 - Ls);
% unary(numneigh) = unary(numneigh) / Ls;

% save current progress
% save('tmp_save.mat', 'binary', 'unary');

% estimate time remaining
% looptime = [looptime, toc];
% timeleft = mean(looptime) * (maxnum - numneigh);
% minutes = floor(timeleft / 60);
% seconds = floor(timeleft - (minutes * 60));
% fprintf('Estimated Time Remaining: %d minutes %d seconds\n', minutes, seconds);

% figure(1);
% plot(1:maxnum, binary);
% title('Nearest Neighbors Parameter Sweep - Binary Test');
% xlabel('Nearest Neighbors');
% ylabel('Binary Classification Accuracy');
%
% figure(2);
% plot(1:maxnum, unary);
% title('Nearest Neighbors Parameter Sweep - Unary Test');
% xlabel('Nearest Neighbors');
% ylabel('Unary Classification Accuracy');
