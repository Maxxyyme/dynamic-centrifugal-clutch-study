%%%% 2 équations de mouvement d'ordre 2 à intégrer en phase d'approche 
%%%% donc 4 équations du premier ordre Q = [psi2 x psi2' x']

function dQn = eqmvt_approche(tn,Qn,data)

%%%% Récupération des données numériques utiles
C2 = data.C2;
m3 = data.m3;
a3 = data.a3;
k  = data.k;
L  = data.L;
L0 = data.L0;

%%%% mouvement imposé
[psi1,dpsi1,ddpsi1] = mvt_imp(tn);

%%%% couple résistant 
Cr = couple_resistant(tn); 

%%%% valeur des paramètres à l'instant courant 
psi2  = Qn(1);
x     = Qn(2);
dpsi2 = Qn(3);
dx    = Qn(4);


%%%% système différentiel 
M  = diag([C2;m3]);
U  = [eye(2) zeros(2);zeros(2) M];
ff = [Cr;m3*(x+a3)*dpsi1.^2-2*k*(2*L+2*x-L0)]; 
F  = [dpsi2;dx;ff];
dQn = U\F;


