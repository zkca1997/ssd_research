function report = CrossValKNN(X, Y, k, proj)

    % compute performance report for KNN model
    K = 10;
    kfold_index = KfoldByTrial(Y,10);
    Y1 = Y{1}; Y2 = cellstr(Y1);
    performance = classperf(Y2);

    for j = 1:K
        test = (kfold_index == j); train = (kfold_index ~= j);

        % generate a model
        proj_matrix = proj(X(train,:), Y1(train,:));
        tmp_model = fitcknn(X(train,:) * proj_matrix, Y1(train),...
            'NumNeighbors', k);

        % run model on test set
        predicted = tmp_model.predict(X(test,:) * proj_matrix);
        classperf(performance, predicted, test);
    end

    report = performance;

end