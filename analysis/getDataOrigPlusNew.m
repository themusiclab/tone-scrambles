function [histTbl,allSubjsTbl] = getDataOrigPlusNew

[histTblOrig,allSubjsTblOrig] = getDataOrig;
[histTblNew,allSubjsTblNew] = getDataNew;
histTbl = histTblOrig+histTblNew;
allSubjsTbl = [allSubjsTblOrig;allSubjsTblNew];
end