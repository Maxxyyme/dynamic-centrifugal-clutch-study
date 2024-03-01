%%%% Calcul des accélérations [psi2" x"] après intégration : Mq"=f => q"=M\f

function acc = acc_approche(t,Q,dpsi1,Cr,data)

%%%% Récupération des données numériques utiles
C2 = data.C2;
m3 = data.m3;
a3 = data.a3;
k  = data.k;
L  = data.L;
L0 = data.L0;

acc = zeros(length(t),2);

for n = 1:length(t)
    Qn   = Q(n,:);
    x    = Qn(2);
    Crn  = Cr(n);
    M    = diag([C2;m3]);
    ff   = [Crn;m3*(x+a3)*dpsi1(n)^2-2*k*(2*L+2*x-L0)];
    ddqn = M\ff;
    acc(n,:) = ddqn.'; %%On le transpose pour mettre notre vecteur colonne en ligne
end
