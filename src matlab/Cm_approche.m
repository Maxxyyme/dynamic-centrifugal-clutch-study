%%%% Calcul du couple moteur Cm

function Cm = Cm_approche(t,Q,dpsi1,ddpsi1,data)

%%%% Récupération des données numériques utiles
C1 = data.C1;
C3 = data.C3;
m3 = data.m3;
a3 = data.a3; 

Cm = zeros(length(t),1);

for n = 1:length(t)
 
tn = t(n);
Qn = Q(n,:);
Cm(n) = (C1+2*C3+2*m3*(a3+Qn(2))^2)*ddpsi1(n)+4*m3*(a3+Qn(2))*Qn(4)*dpsi1(n);

end
