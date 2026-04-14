function outHist = getHistogramOneNativeLang(langName)

load nativeLangPlusScoreTable.mat

p = (0:20)/20;
outHist = NaN(21,1);
for k=1:21
    outHist(k) = sum(strcmp(tbl.nativeLang,langName) & tbl.Var4==p(k));
end

end