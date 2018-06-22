%%  Print out classifier results

for i = 1:10
   L1 = performance(i).ClassLabels(1);
   L2 = performance(i).ClassLabels(2);
   R = performance(i).CorrectRate;
   S = [L1, L2, R];
   disp(S);
   %performance(i).CountingMatrix
end
