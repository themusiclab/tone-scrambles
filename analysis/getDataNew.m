function [histTbl,allSubjTbl] = getDataNew

varNames = {'samediff','task1v2','task2v3','task3v4','task4v5','task5v6','task8v9','task9v10','task10v11'};
targString20 = cell(9,1);
for k=1:21
    targString20{k} = num2str((k-1)/20);
end

nTasks = 9;
dataFile = '../results-new/p_matNewData.csv';
allSubjTbl = readtable(dataFile,'ReadRowNames',true,'ReadVariableNames',1);
allSubjTbl.Properties.VariableNames = varNames;

for k=1:nTasks
    if k==1  % same-different task
        tmp = zeros(1,17);
        column = table2array(allSubjTbl(:,k));
        for n=0:16
            tmp(n+1) = sum(column==n/16);
        end
        samediff = [tmp(:);NaN;NaN;NaN;NaN];
    elseif k==4
        tmp = zeros(1,21);
        column = table2array(allSubjTbl(:,k));
        for n=0:20
            tmp(n+1) = sum(column==n/20);
        end
        task3v4 = tmp(:);
    else
        tmp = zeros(1,21);
        column = table2array(allSubjTbl(:,k));
        for n=1:20
            tmp(n+1) = sum(strcmp(column,targString20{n}));
        end
        eval([varNames{k} '= tmp(:);']);
    end
end
histTbl = table(samediff,task1v2,task2v3,task3v4,task4v5,task5v6,task8v9,task9v10,task10v11);
end

