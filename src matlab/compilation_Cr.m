%%%% Calcul du couple r�sistant Cr aux pas de temps souhait�s

function Cr = compilation_Cr(t)

Cr = zeros(length(t),1);

for n = 1:length(t)
    tn = t(n);
    Cr(n) = couple_resistant(tn);
end
