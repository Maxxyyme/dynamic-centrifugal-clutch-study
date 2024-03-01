%%%% Calcul du couple moteur Cm

function Cm = Cm_adherence(t,Q,dpsi1,ddpsi1,data)

%%%% Récupération des données numériques utiles
C1 = data.C1;
C3 = data.C3;
m3 = data.m3;
a3 = data.a3;
L  = data.L;
L0 = data.L0;
R2 = data.R2;
f = data.f;
R3 = data.R3;
k  = data.k;
C2 = data.C2;

Cm = zeros(length(t),1);

for n = 1:length(t)
 
tn = t(n);
Qn = Q(n);
Cr = couple_resistant(tn); 
Cm(n) = (C1 + 2*C3 + 2*m3*(R2-R3+a3)^2)*ddpsi1(n) - Cr + C2*ddpsi1(n);

end