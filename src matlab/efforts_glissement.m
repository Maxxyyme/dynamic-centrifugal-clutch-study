%%%% Calcul des efforts de liaison

function [X23,Y23] = efforts_glissement(t,Q,dpsi1,ddpsi1,data)

%%%% R�cup�ration des donn�es num�riques utiles
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

X23 = zeros(length(t),1);
Y23 = zeros(length(t),1);

for n = 1:length(t)
 
tn = t(n);
Qn = Q(n,:);
X23(n) = 2*k*(2*L+2*R2-2*R3-L0)-m3*(R2-R3+a3)*dpsi1(n)^2;
Y23(n) = -f*abs(X23(n))*sign(dpsi1(n)-Qn(2));

end
