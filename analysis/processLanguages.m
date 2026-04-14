function [allNames,allHists,allNs,allPs,allDipsFromData,allSimDips] = processLanguages(genData,doDipTests,genHistFigs)

if nargin < 3
    genHistFigs = false;
end
if nargin < 2
    genHistFigs = false;
end
if nargin < 1
    genData = false;
end
nSamples = 10000;
if genData
    tblLangNew = readtable('../results-new/nativeLanguage.csv','ReadRowNames',true);
    tblLangOrig = readtable('../results/nativeLanguage.csv','ReadRowNames',true);
    tblTaskNew = readtable('../results-new/p_matNewData.csv','ReadRowNames',true);
    tblTaskOrig = readtable('../results/p_matOrig.csv','ReadRowNames',true);
    
    commonRows = intersect(tblLangOrig.Properties.RowNames,tblTaskOrig.Properties.RowNames);
    langOrig = tblLangOrig(commonRows,:);
    scoreOrig = tblTaskOrig(commonRows,4);
    tblOrig = [langOrig scoreOrig];
    
    commonRows = intersect(tblLangNew.Properties.RowNames,tblTaskNew.Properties.RowNames);
    langNew = tblLangNew(commonRows,:);
    scoreNew = tblTaskNew(commonRows,4);
    tblNew = [langNew scoreNew];
    
    tbl = [tblOrig;tblNew];
    tbl.Properties.VariableNames = {'nativeLang','task3v4'};
    save('langPlusScoreTable.mat','tbl');
end
load langPlusScoreTable.mat
writetable(tbl,'nativeLangPlusTask3v4.csv','WriteRowNames',true);

uLangs = unique(tbl.nativeLang);
nLangs = length(uLangs);
nSpeakers = NaN(nLangs,1);
for k=1:nLangs
    nSpeakers(k) = sum(strcmp(tbl.nativeLang,uLangs{k}));
end
[sortedNSpeakers,ndx] = sort(nSpeakers,'descend');
if doDipTests
    allPs = NaN(20,1);
    allSimDips = NaN(20,nSamples);
    allDipsFromData = NaN(20,1);
else
    allPs = [];
    allDipsFromData=[];
    allSimDips =[];
end
allNs = NaN(20,1);
allHLRatios = NaN(20,1);
allNames = cell(20,1);
allHists = NaN(21,20);
for k=1:20
    langName = uLangs{ndx(k)};
    whichOnes = strcmp(tbl.nativeLang,langName);
    crntScores = tbl.task3v4(whichOnes);
    crntHist = NaN(1,21);
    for h=0:20
        crntHist(h+1) = sum(crntScores==h/20);
    end
    if genHistFigs
        figure
        genHist(crntScores,langName);
    end
    if doDipTests
        [dipFromData,allSimDipsFromUniformDist] = doDipTest(crntHist,nSamples);
        allPs(k) = mean(dipFromData<allSimDipsFromUniformDist);
        allSimDips(k,:)=allSimDipsFromUniformDist;
        allDipsFromData(k) = dipFromData;
    end
    allHists(:,k) = crntHist(:);
    allNs(k) = sum(crntHist);
    allNames{k}=langName;
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
set(gca,'xTick',1:21,'xticklabel',[],'linewidth',2,'fontsize',16,'PlotBoxAspectRatio',[1 .7 1])
box on
grid on
text(1,.135,langName,'fontsize',35)
text(1,.115,['\itN\rm = ' num2str(nTot)],'fontsize',35)
box on
grid on
xlim([.5 21.5])
ylim([0 0.15]);
end