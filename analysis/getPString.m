function pString = getPString(p)

if p == 0
    pString = '<0.0001';
elseif p == 1
    pString = '>0.9999';
else
    pString = sprintf('%0.4f',p);
end

end