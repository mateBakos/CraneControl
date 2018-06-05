function criterion = featureTest(Xtrain, Ytrain, Xtest, Ytest)

    % Template and fit
    t = templateTree('MinLeaf',1);
    tbfit = fitensemble(Xtrain,Ytrain,'Bag',40,t,'type','regression');
    yfitTBLS = predict(tbfit,Xtest);

    resid = yfitTBLS - Ytest;

    % Square residuals
    resid_sqrd = resid.*resid;

    % Take the sum of the squared residuals
    criterion = sum(resid_sqrd);

end

