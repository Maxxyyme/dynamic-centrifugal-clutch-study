function [psi,dpsi,ddpsi]=mvt_imp(tn)

%%%% mouvement impos� avec acc�l�ration constante
gamma = pi;
ddpsi = gamma;
dpsi  = gamma*tn;
psi   = 0.5*gamma*tn^2;
