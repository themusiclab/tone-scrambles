function [badRowsOrig,badRowsNew] = getBadSubjectIDs

targString20 = cell(9,1);
for k=1:21
    targString20{k} = num2str((k-1)/20);
end

newDataFile = '../results-new/p_matNewData.csv';
origDataFile = '../results/p_matOrig.csv';
tblNew = readtable(newDataFile,'ReadRowNames',true,'ReadVariableNames',0);
tblNew(1,:) = [];
tblNew.Properties.VariableNames = {'sameDiff','task1v2','task2v3','task3v4','task4v5','task5v6','task8v9','task9v10','task10v11'};
tblOrig = readtable(origDataFile,'ReadRowNames',true,'ReadVariableNames',0);
tblOrig(1,:) = [];
tblOrig.Properties.VariableNames = {'sameDiff','task1v2','task2v3','task3v4','task4v5','task5v6','task8v9','task9v10','task10v11'};

%% Get the bad rows in tblNew
badRowsNew = [];
uVals = unique(tblNew.task3v4);
badVals = setdiff(uVals,(0:20)/20);
nBadVals = length(badVals);
for k=1:nBadVals
    fprintf('bad value in tblNew.task3v4 = %0.4f\n',badVals(k));
    badRowsNew = [badRowsNew;tblNew.Properties.RowNames(tblNew.task3v4 == badVals(k))];
end

uVals = unique(tblNew.sameDiff);
badVals = setdiff(uVals,(0:16)/16);
nBadVals = length(badVals);
for k=1:nBadVals
    fprintf('bad value in tblNew.sameDiff = %0.4f\n',badVals(k));
    badRowsNew = [badRowsNew;tblNew.Properties.RowNames(tblNew.sameDiff == badVals(k))];
end

%% get the bad rows in tblOrig
badRowsOrig = [];
uVals = unique(tblOrig.task3v4);
badVals = setdiff(uVals,(0:20)/20);
nBadVals = length(badVals);
for k=1:nBadVals
    fprintf('bad value in tblOrig.task3v4 = %0.4f\n',badVals(k));
    badRowsOrig = [badRowsOrig;tblOrig.Properties.RowNames(tblOrig.task3v4 == badVals(k))];
end

uVals = unique(tblOrig.sameDiff);
badVals = setdiff(uVals,(0:16)/16);
nBadVals = length(badVals);
for k=1:nBadVals
    fprintf('bad value in tblOrig.sameDiff = %0.4f\n',badVals(k));
    badRowsOrig = [badRowsOrig;tblOrig.Properties.RowNames(tblOrig.sameDiff == badVals(k))];
end

end

