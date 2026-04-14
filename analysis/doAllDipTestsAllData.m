function tbl = doAllDipTestsAllData

nSamples = 10000;
[histTbl,~] = getDataOrigPlusNew;
rowNames = {'samediff';'task1v2';'task2v3';'task3v4';'task4v5';'task5v6';'task8v9';'task9v10';'task10v11'};
varNames = {'dip','pVal'};
allDips = NaN(9,1);
allPs = cell(9,1);
for k=1:9
    if k==1  % same-different task
        dataHist = histTbl.samediff(1:17);
    else
        eval(['dataHist = histTbl.' rowNames{k} ';']);
    end
    [dipFromData,~,p] = doDipTest(dataHist,nSamples);
    allDips(k)=dipFromData;
    allPs{k} = getPString(p);
end
tbl = table(allDips,allPs,'VariableNames',varNames,'RowNames',rowNames);
end