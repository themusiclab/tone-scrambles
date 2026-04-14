function getAllDataForRMarkdown(genData)

% generate .csv files containing for use by .R functions in ../writing.
% These are:
%
% allTaskHistsAllData.csv
% allTaskHistsNew.csv
% allTaskHistsOrig.csv
% allTasksIndividualSubjsAllData.csv
% country20Histograms.csv
% dataFor20CountryTable.csv
% dataFor20NativeLangTable.csv
% dipTestPValsAllTasksAllData.csv
% dipTestPValsYrsLessons.csv
% heatMapCounts.csv
% languageClassHists.csv
% NativeLang20Histograms.csv
% nativeLangPlusTask3v4.csv
% noLessonsCounts.csv
% yrsLessonsHists.csv

letRun = true;
if nargin < 1
    genData = false;
end


%% generate .csv file for table showing dips test p-values for 20 most populous native languages in our sample
if (~exist("dataFor20NativeLangTable.csv",'file') || genData) && letRun
    doDipTests = true;
    [allNames,~,~,allPs,allDipsFromData,~] = processLanguages(genData,doDipTests);
    tmp = table(allNames,allDipsFromData,allPs);
    writetable(tmp,'dataFor20NativeLangTable.csv');
end
if (~exist("NativeLang20Histograms.csv",'file') || genData) && letRun
    doDipTests = false;
    [allNames,allHists] = processLanguages(genData,doDipTests);
   
    tmp = table(allHists(:,1),allHists(:,2),allHists(:,3),allHists(:,4),allHists(:,5),...
        allHists(:,6),allHists(:,7),allHists(:,8),allHists(:,9),allHists(:,10),...
        allHists(:,11),allHists(:,12),allHists(:,13),allHists(:,14),allHists(:,15),...
        allHists(:,16),allHists(:,17),allHists(:,18),allHists(:,19),allHists(:,20),'VariableNames',allNames);
    writetable(tmp,'NativeLang20Histograms.csv');
end

%% generate .csv file for table showing dips test p-values for 20 most populous countries in our sample
if (~exist("dataFor20CountryTable.csv",'file') || genData) && letRun
    [allNames,~,~,allPs,allDipsFromData,~] = processCountrys(genData,1);
    tmp = table(allNames,allDipsFromData,allPs);
    writetable(tmp,'dataFor20CountryTable.csv');
end
if (~exist("country20Histograms.csv",'file') || genData) && letRun
    doDipTests = false;
    [allNames,allHists] = processCountrys(genData,doDipTests);
   
    tmp = table(allHists(:,1),allHists(:,2),allHists(:,3),allHists(:,4),allHists(:,5),...
        allHists(:,6),allHists(:,7),allHists(:,8),allHists(:,9),allHists(:,10),...
        allHists(:,11),allHists(:,12),allHists(:,13),allHists(:,14),allHists(:,15),...
        allHists(:,16),allHists(:,17),allHists(:,18),allHists(:,19),allHists(:,20),'VariableNames',allNames);
    writetable(tmp,'country20Histograms.csv');
end

if (~exist("yrsLessonsHists.csv",'file') || genData) && letRun
    tbl = getHistsAllYrsLessons;
    writetable(tbl,'yrsLessonsHists.csv');
end

%% Generate allTaskHistsAllData.csv and allTasksIndividualSubjsAllData.csv
[tblBoth,tblBothAllSubjs] = getDataOrigPlusNew;
writetable(tblBoth,'allTaskHistsAllData.csv')
writetable(tblBothAllSubjs,'allTasksIndividualSubjsAllData.csv')


%% Generate heat map counts and write results to heatMapCounts.csv
if genData && letRun
    [outCounts,yrsLessonsResps,noLessonsCounts] = getHeatMapDataAllSubjectsDiscardingInconsistent;
    save('yearsLessonsVsMajorMinorPerformanceData.mat','outCounts','noLessonsCounts','yrsLessonsResps');
end
load('yearsLessonsVsMajorMinorPerformanceData.mat','outCounts','noLessonsCounts');

tmp = array2table(outCounts);
writetable(tmp,'heatMapCounts.csv');

tmp = array2table(noLessonsCounts);
writetable(tmp,'noLessonsCounts.csv');

%% get data for figure showing histograms for different language classes
if genData && letRun
    if ~exist('langPlusScoreTable.mat','file')
        tbl = getLangPlusScoreTable;
        save('langPlusScoreTable.mat','tbl');
    end
    [histTbl,pValTbl] = getNativeLanguageClassData;
    save('languageClassHists.mat','pValTbl','histTbl');
end
load('languageClassHists.mat','histTbl');
writetable(histTbl,'languageClassHists.csv')

%% Generate allDipTestResults and write the results to dipTestPValsAllTasks.csv
if genData && letRun
    tbl = doAllDipTestsAllData;
    save dipTestTableForAllTasksAllData tbl
end
load('dipTestTableForAllTasksAllData.mat','tbl')
tbl.Properties.VariableNames={'dips','pVals'};
writetable(tbl,'dipTestPValsAllTasksAllData.csv','WriteRowNames',true)


if genData && letRun
    tbl = doDipTestsOnYearsVsScore;
    save('dipTestTableForYrsLessons.mat','tbl')
end 
load('dipTestTableForYrsLessons.mat','tbl')
tbl.Properties.VariableNames={'dips','pVals'};
writetable(tbl,'dipTestPValsYrsLessons.csv','WriteRowNames',true)

end 