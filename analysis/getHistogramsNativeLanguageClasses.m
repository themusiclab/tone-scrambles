function [allPs,allSimDips,allDipsFromData] = getHistogramsNativeLanguageClasses

nSamples = 10000;
tbl = getNativeLanguageClasses;
uLangClasses = unique(tbl.langClass);
nLangClasses = length(uLangClasses);
allPs = NaN(nLangClasses,1);
allSimDips = NaN(nLangClasses,nSamples);
allDipsFromData = NaN(nLangClasses,1);
for k=1:nLangClasses
    langClassName = uLangClasses{k};
    whichOnes = strcmp(tbl.langClass,langClassName);
    crntScores = tbl.Var4(whichOnes);
    crntHist = NaN(1,21);
    for h=0:20
        crntHist(h+1) = sum(crntScores==h/20);
    end
    figure
    genHist(crntScores,langClassName);
    [dipFromData,allSimDipsFromUniformDist] = doDipTest(crntHist,nSamples);
    allPs(k) = mean(dipFromData<allSimDipsFromUniformDist);
    allSimDips(k,:)=allSimDipsFromUniformDist;
    allDipsFromData(k) = dipFromData;
end

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