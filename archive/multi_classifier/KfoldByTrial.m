function index = KfoldByTrial(label, k)

    trials = unique(label{2});
    tindex = crossvalind('Kfold', size(trials,1), k);
    index  = zeros(size(label,1),1);
    
    for i = 1:k
        set = trials(tindex == i);
        mask = false(size(label,1),1);
        for j = 1:length(set)
           a = label{2} == set(j);
           mask = mask | a;
        end
        index(mask,1) = i;
    end
        
end