function tbl = getHistsAllYrsLessons

load yearsLessonsVsMajorMinorPerformanceData.mat

nSamples = 10000;

names = {'noLessons';'0-1yr';'1-2yrs';'2-4yrs';'4-6yrs';'6-10yrs';'>10yrs'};

tbl = table(noLessonsCounts,outCounts(:,1),outCounts(:,2),outCounts(:,3),outCounts(:,4),outCounts(:,5),outCounts(:,6),'VariableNames',names);

end