function CompareHist(data, labels, classes, titlestr)
% plot a set of histograms that display the probability distributions of two
% classes for a set of discrete dimensional vectors
    
    for i = 1:size(data,2)
        hold on;
        for k = 1:length(classes)
            mask = strcmp(labels, classes(k));
            histogram(data(mask,i));
            str = [titlestr, ': Projection ', num2str(i)];
            title(str);
        end
        figure;
    end
end
