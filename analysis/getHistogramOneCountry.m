function outHist = getHistogramOneCountry(countryName)

load countryPlusScoreTable.mat

p = (0:20)/20;
outHist = NaN(21,1);
for k=1:21
    outHist(k) = sum(strcmp(tbl.nativeLang,countryName) & tbl.Var4==p(k));
end

end