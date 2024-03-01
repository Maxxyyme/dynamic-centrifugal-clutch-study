%%%% Calcul du couple moteur Cm

function Cm = Cm_glissement(t,Q,dpsi1,ddpsi1,data)

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

Cm = zeros(length(t),1);

for n = 1:length(t)
 
tn = t(n);
Qn = Q(n,:);
Cm(n) = (C1+2*C3+2*m3*(R2-R3+a3)^2)*ddpsi1(n)+2*R2*f*abs(2*k*(2*L+2*R2-2*R3-L0)-m3*(R2-R3+a3)*dpsi1(n)^2)*sign(dpsi1(n)-Qn(2));

end
