function [psi,dpsi,ddpsi]=mvt_imp(tn)

%%%% mouvement imposé avec accélération constante
gamma = pi;
ddpsi = gamma;
dpsi  = gamma*tn;
psi   = 0.5*gamma*tn^2;
