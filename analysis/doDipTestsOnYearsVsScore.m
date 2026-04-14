function tbl = doDipTestsOnYearsVsScore

load yearsLessonsVsMajorMinorPerformanceData.mat

nSamples = 10000;

names = {'noLessons';'0-1yr';'1-2yrs';'2-4yrs';'4-6yrs';'6-10yrs';'>10yrs'};

allDips = NaN(7,1);
allNs = NaN(7,1);
allPs = cell(7,1);
[dipFromData,~,p] = doDipTest(noLessonsCounts,nSamples);
allPs{1} = getPString(p);
allDips(1)=dipFromData;

for k=2:7
    dataHist = outCounts(:,k-1);
    [dipFromData,~,p] = doDipTest(dataHist,nSamples);
    allDips(k)=dipFromData;
    allPs{k} = getPString(p);
end
tbl = table(allDips,allPs);
tbl.Properties.RowNames = names;
end