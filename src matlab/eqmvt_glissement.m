%%%% 2 équations de mouvement d'ordre 2 à intégrer en phase d'approche 
%%%% donc 4 équations du premier ordre Q = [psi2 x psi2' x']

function dQn = eqmvt_glissement(tn,Qn,data)

%%%% Récupération des données numériques utiles
C2 = data.C2;
m3 = data.m3;
a3 = data.a3;
k  = data.k;
L  = data.L;
L0 = data.L0;
R2 = data.R2;
f = data.f;
R3 = data.R3;

%%%% mouvement imposé
[psi1,dpsi1,ddpsi1] = mvt_imp(tn);

%%%% couple résistant 
Cr = couple_resistant(tn); 

%%%% valeur des paramètres à l'instant courant 
psi2  = Qn(1);
dpsi2 = Qn(2);

%%%% système différentiel 
M  = C2;
U  = [1, 0;0, M];
ff = Cr + 2*R2*f*abs(2*k*(2*L + 2*R2 - 2*R3 - L0) - m3*(R2 - R3 + a3)* dpsi1*dpsi1)*sign(dpsi1-dpsi2);
F  = [dpsi2;ff];
dQn = U\F;


