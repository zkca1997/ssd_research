function predicted = model_IPCA_KNN(X_train, Y_train, X_test)
    
    % apply PCA to training data
    proj = ipca(X_train, 0.9);
    Xp_train = X_train * proj;
    Xp_test  = X_test * proj;
    
    % train a quadratic discriminant model
    model = fitcknn(Xp_train, Y_train, 'NumNeighbors', 3);
    
    % use model to generate predictions on test data
    predicted = predict(model, Xp_test);

end
