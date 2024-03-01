%%%% Calcul du mvt d'entree [psi1 psi1' psi1"] aux pas de temps souhaités

function [psi1,dpsi1,ddpsi1] = compilation_mvt_entree(t)

psi1   = zeros(length(t),1); %%On initialise puis on va remplir par apres
dpsi1  = zeros(length(t),1);
ddpsi1 = zeros(length(t),1);

for n = 1:length(t)
    tn = t(n);
    [psi1(n),dpsi1(n),ddpsi1(n)] = mvt_imp(tn);
end
