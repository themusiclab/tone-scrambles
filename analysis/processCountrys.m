function [allNames,allHists,allNs,allPs,allDipsFromData,allSimDips] = processCountrys(genData,doDipTests,genHistFigs)

if nargin < 3
    genHistFigs = false;
end
if nargin < 2
    doDipTests = false;
end
if nargin < 1
    genData = false;
end

nSamples = 10000;
if genData
    tblCountryNew = readtable('../results-new/countryNew.csv','ReadRowNames',true);
    tblCountryOrig = readtable('../results/country.csv','ReadRowNames',true);
    tblTaskNew = readtable('../results-new/p_matNewData.csv','ReadRowNames',true);
    tblTaskOrig = readtable('../results/p_matOrig.csv','ReadRowNames',true);
    
    commonRows = intersect(tblCountryOrig.Properties.RowNames,tblTaskOrig.Properties.RowNames);
    countryOrig = tblCountryOrig(commonRows,:);
    scoreOrig = tblTaskOrig(commonRows,4);
    tblOrig = [countryOrig scoreOrig];
    
    commonRows = intersect(tblCountryNew.Properties.RowNames,tblTaskNew.Properties.RowNames);
    countryNew = tblCountryNew(commonRows,:);
    scoreNew = tblTaskNew(commonRows,4);
    tblNew = [countryNew scoreNew];
    
    tbl = [tblOrig;tblNew];
else
    load countryPlusScoreTable.mat
end

uCountrys = unique(tbl.country);
nCountrys = length(uCountrys);
nSpeakers = NaN(nCountrys,1);
for k=1:nCountrys
    nSpeakers(k) = sum(strcmp(tbl.country,uCountrys{k}));
end
[sortedNSpeakers,ndx] = sort(nSpeakers,'descend');
allNs = NaN(20,1);
if doDipTests
    allSimDips = NaN(20,nSamples);
    allDipsFromData = NaN(20,1);
    allPs = NaN(20,1);
else
    allSimDips = [];
    allDipsFromData = [];
    allPs = [];
end
allNames = cell(20,1);
allHists = NaN(21,20);
for k=1:20
    countryName = uCountrys{ndx(k)};
    whichOnes = strcmp(tbl.country,countryName);
    crntScores = tbl.task3v4(whichOnes);
    crntHist = NaN(21,1);
    for h=0:20
        crntHist(h+1) = sum(crntScores==h/20);
    end
    if genHistFigs
        figure
        genHist(crntScores,countryName);
    end
    if doDipTests
        [dipFromData,allSimDipsFromUniformDist] = doDipTest(crntHist,nSamples);
        allPs(k) = mean(dipFromData<allSimDipsFromUniformDist);
        allSimDips(k,:)=allSimDipsFromUniformDist;
        allDipsFromData(k) = dipFromData;
    end
    allHists(:,k) = crntHist;
    allNs(k) = sum(crntHist);
    allNames{k}=countryName;
end

end

function genHist(crntScores,langName)

counts = NaN(21,1);
for k=1:21
    p= (k-1)/20;
    counts(k) = sum(crntScores==p);
end
nTot = sum(counts);
probs = counts/sum(counts);
b = bar(probs,1,'LineWidth',2,'EdgeColor',[0 0 0], 'FaceColor',0.9*[1 1 1]);
% set(gca,'xTick',1:21,'xticklabel',[],'linewidth',2,'fontsize',16)
set(gca,'xTick',1:21,'xticklabel',[],'linewidth',2,'fontsize',16,'PlotBoxAspectRatio',[1 .7 1])
box on
grid on
text(1,.135,langName,'fontsize',35)
text(1,.115,['\itN\rm = ' num2str(nTot)],'fontsize',35)
box on
grid on
xlim([.5 21.5])
ylim([0 0.15]);
% title(langName)
end