%%%% 2 �quations de mouvement d'ordre 2 � int�grer en phase d'approche 
%%%% donc 4 �quations du premier ordre Q = [psi2 x psi2' x']

function dQn = EDL_adherence(tn,Qn,data)

%%%% R�cup�ration des donn�es num�riques utiles
C2 = data.C2;
m3 = data.m3;
a3 = data.a3;
k  = data.k;
L  = data.L;
L0 = data.L0;
R2 = data.R2;
f = data.f;
R3 = data.R3;

%%%% mouvement impos�
[psi1,dpsi1,ddpsi1] = mvt_imp(tn);

%%%% couple r�sistant 
Cr = couple_resistant(tn); 

%%%% valeur des param�tres � l'instant courant 
dpsi2 = Qn;

%%%% syst�me diff�rentiel 
dQn = dpsi1;