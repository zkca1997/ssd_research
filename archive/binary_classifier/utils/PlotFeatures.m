function PlotFeatures(set, label, dim, fig)
%USAGE: PlotFeatures(set, label, dim, fig)
%set: matrix that contains variables in columns and samples in rows
%label: a column vector containing labels
%dim: a vector that contains the three dimensions to plot to
%fig: the figure number to plot on
  
  if length(dim) ~= 3
    fprintf('PlotFeatures for Figure %d has invalid dimension set\n', fig);
    return;
  end

  [~, S, ~] = pca(set);

  SA = S(label,  dim);
  SB = S(~label, dim);

  x = ['Principal Component ', num2str(dim(1))];
  y = ['Principal Component ', num2str(dim(2))];
  z = ['Principal Component ', num2str(dim(3))];

  figure(fig);
  plot3(SA(:,1), SA(:,2), SA(:,3), 'r.');
  hold on;
  plot3(SB(:,1), SB(:,2), SB(:,3), 'b.');

  title('3D Plot of Feature Space');
  xlabel(x);
  ylabel(y);
  zlabel(z);
end
