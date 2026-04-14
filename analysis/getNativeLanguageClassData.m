function [histTbl,dipTable] = getNativeLanguageClassData

nSamples = 10000;
tbl = getNativeLanguageClasses;
uLangClasses = unique(tbl.langClass);
nLangClasses = length(uLangClasses);
histPA = zeros(21,1);
histTonal = zeros(21,1);
histMixed = zeros(21,1);
histOther = zeros(21,1);
dips = NaN(nLangClasses,1);
pVals = NaN(nLangClasses,1);
for k=1:nLangClasses
    langClassName = uLangClasses{k};
    whichOnes = strcmp(tbl.langClass,langClassName);
    crntScores = tbl.task3v4(whichOnes);
    crntHist = NaN(1,21);
    for h=0:20
        crntHist(h+1) = sum(crntScores==h/20);
    end
    [dipFromData,allSimDipsFromUniformDist] = doDipTest(crntHist,nSamples);
    pVals(k) = mean(dipFromData<allSimDipsFromUniformDist);
    dips(k) = dipFromData;
    
    if strcmp(langClassName,'PA')
        histPA = crntHist(:);
    elseif strcmp(langClassName,'tonal')
        histTonal = crntHist(:);
    elseif strcmp(langClassName,'mixed')
        histMixed = crntHist(:);
    else
        histOther = crntHist(:);
    end
end

histTbl = table(histTonal,histPA,histMixed,histOther);
histTbl.Properties.VariableNames = {'tonal','pitch accented','mixed','other'};
dipTable = table(dips,pVals);
dipTable.Properties.RowNames = {'tonal','pitch accented','mixed','other'};
end

function genHist(crntScores,langClassName)

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
text(1,.135,langClassName,'fontsize',35)
text(1,.115,['\itN\rm = ' num2str(nTot)],'fontsize',35)
box on
grid on
xlim([.5 21.5])
ylim([0 0.15]);
% title(langName)
end