%%%% Calcul du couple résistant Cr aux pas de temps souhaités

function Cr = compilation_Cr(t)

Cr = zeros(length(t),1);

for n = 1:length(t)
    tn = t(n);
    Cr(n) = couple_resistant(tn);
end
