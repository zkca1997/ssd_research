function out = CompareHist(set, label, dim, fig)
% plot a set of histograms that display the probability distributions of two
% classes for a set of discrete dimensional vectors

  [~, S, ~] = pca(set);

  SA = S(label,:);
  SB = S(~label,:);

  out = figure(fig);
  num = length(dim);
  horz = 2;
  vert = ceil(num / horz);

  for i = 1:num
    PlotHist(SA(:,dim(i)), SB(:,dim(i)), dim(i), i);
  end

  function PlotHist(setA, setB, x, i)
    subplot(vert, horz, i);
    histogram(setA);
    hold on;
    histogram(setB);
    str = num2str(x);
    str = ['Principal Component ', str];
    xlabel(str);
    ylabel('Number of Events');
  end

end
