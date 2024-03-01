%%%% Calcul des accélérations [psi2" x"] après intégration : Mq"=f => q"=M\f

function acc = acc_glissement(t,Q,dpsi1,Cr,data)

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

acc = zeros(length(t),1);

for n = 1:length(t)
    Qn   = Q(n,:);
    dpsi2 = Qn(2);
    Crn  = Cr(n);
    M    = C2;
    ff   = Crn + 2*R2*f*abs(2*k*(2*L + 2*R2 - 2*R3 - L0) - m3*(R2 - R3 + a3)* dpsi1(n)*dpsi1(n))*sign(dpsi1(n)-dpsi2);
    ddqn = M\ff;
    acc(n,:) = ddqn.'; %%On le transpose pour mettre notre vecteur colonne en ligne
end
