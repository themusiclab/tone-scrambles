function [dipFromData,allSimDipsFromUniformDist,p] = doDipTest(dataHist,nSimSamples)

% dataHist is a vector of length 21, where dataHist(k) that gives the 
% number of subjects who got k-1 correct.

if nargin < 2
    nSimSamples = 100000;
end
nSubjects = sum(dataHist);
nPossibleScores = length(dataHist);
xpdf = [];
for k=1:nPossibleScores
    xpdf = [xpdf k*ones(1,dataHist(k))-rand(1,dataHist(k))];  
    % subtract a uniform random variable from 
    % each integer-valued random variable to make the empirical cdf
    % continuous (as required by the Hartigan dips test). Possible values
    % now range continuously from 0 to nPossibleScores+1
end

dipFromData = HartigansDipTest(xpdf);

allSimDipsFromUniformDist = NaN(nSimSamples,1);
for k=1:nSimSamples
    if mod(k,1000)==0
        fprintf('k=%d\n',k)
    end
    xpdfSim= rand(1,nSubjects);
    tmpDip = HartigansDipTest(xpdfSim);
    allSimDipsFromUniformDist(k) = tmpDip;
end

p = mean(dipFromData < allSimDipsFromUniformDist);
end