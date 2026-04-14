function [outCounts,yrsLessonsResps,noLessonsCounts] = getHeatMapDataAllSubjectsDiscardingInconsistent
% We only want to include subjects who gave consistent responses to the two questions, "Did you ever take music
% lessons?" and "For how many years did you take music lessons?" (i.e., if
% they said "no" to the first one, then they had to not respond to the
% second one.

yrsLessonsFileOrig = '../results/yrsLessons.csv';
musicLessonsFileOrig = '../results/musicLessons.csv';
dataFileOrig = '../results/p_matOrig.csv';

yrsLessonsFileNew = '../results-new/yrsLessonsNew.csv';
musicLessonsFileNew = '../results-new/musicLessonsNew.csv';
dataFileNew = '../results-new/p_matNewData.csv';

yrsLessonsOrigTbl = readtable(yrsLessonsFileOrig,'ReadRowNames',true,'ReadVariableNames',true);
musicLessonsOrigTbl = readtable(musicLessonsFileOrig,'ReadRowNames',true,'ReadVariableNames',true);
dataOrigTbl = readtable(dataFileOrig,'ReadRowNames',true,'VariableNamesLine',1);

yrsLessonsNewTbl = readtable(yrsLessonsFileNew,'ReadRowNames',true,'ReadVariableNames',true);
musicLessonsNewTbl = readtable(musicLessonsFileNew,'ReadRowNames',true,'ReadVariableNames',true);
dataNewTbl = readtable(dataFileNew,'ReadRowNames',true,'ReadVariableNames',1);

yrsLessonsTbl = [yrsLessonsOrigTbl;yrsLessonsNewTbl];
musicLessonsTbl = [musicLessonsOrigTbl;musicLessonsNewTbl];
dataOrigTbl(1,:)=[];
dataNewTbl(1,:)=[];
dataTbl = [dataOrigTbl;dataNewTbl];
scoreTbl = dataTbl(:,4);


%% screen out subjects who responded inconsistently to the music lessons items 

saidTheyTookLessonsTbl = musicLessonsTbl(musicLessonsTbl.musicLessons==1,:);
tmp = intersect(yrsLessonsTbl.Properties.RowNames, saidTheyTookLessonsTbl.Properties.RowNames);
validYrsLessonsTbl = yrsLessonsTbl(tmp,:);
saidNoLessonsTbl = musicLessonsTbl(musicLessonsTbl.musicLessons==false,:);
whichOnes = setdiff(saidNoLessonsTbl.Properties.RowNames,yrsLessonsTbl.Properties.RowNames);
whichOnes = intersect(whichOnes, scoreTbl.Properties.RowNames);

ValidNoLessonsTbl = scoreTbl(whichOnes,:);

yrsLessonsResps = unique(yrsLessonsTbl.yrsLessons);
nClasses = length(yrsLessonsResps);


noLessonsCounts = NaN(21,1);
for n=0:20
    p = n/20;
    noLessonsCounts(n+1) = sum(ValidNoLessonsTbl.task3v4 == p);
end

commonRows = intersect(validYrsLessonsTbl.Properties.RowNames,scoreTbl.Properties.RowNames);
scoresOfListenersWithValidYearsLessons = scoreTbl(commonRows,:);
yearClassesOfListenersWithValidYearsLessons = validYrsLessonsTbl(commonRows,:);
outCounts = NaN(21,nClasses);
for k=1:nClasses
    for n=0:20
        p = n/20;
        outCounts(n+1,k) = sum(scoresOfListenersWithValidYearsLessons.task3v4 == p & strcmp(yearClassesOfListenersWithValidYearsLessons.yrsLessons,yrsLessonsResps{k}));
    end
end
end

