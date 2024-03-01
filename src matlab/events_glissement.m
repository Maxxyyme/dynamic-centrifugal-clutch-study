%%%% d�finition des fonctions �v�nement d�tectant la sortie de la phase
%%%% d'approche

function [value,isterminal,direction]=events_glissement(tn,Qn,data)

%%%% R�cup�ration des donn�es num�riques utiles
R2 = data.R2;
R3 = data.R3;
L0 = data.L0;
L = data.L;
k = data.k;
m3 = data.m3;
a3 = data.a3;
% f = data.f;

%%%% mouvement impos�
[psi1,dpsi1,ddpsi1] = mvt_imp(tn);

X23 = 2*k*(2*L + 2*R2 - 2*R3 - L0) - m3*(R2 - R3 + a3)*dpsi1*dpsi1;
% Y23 = -f*abs(X23)* sign(dpsi1 - dpsi2);

%%%% Valeur de x au pas courant
% x = Qn(2);

%%%% Valeur de dpsi1 et de dpsi2 au pas courant

dpsi2 = Qn(2);

value = [X23; dpsi1-dpsi2]; % x atteint la valeur R2 - R3 TJRS FONCTION EGALE A 0 // SI plusieurs conditions d'arrets alors value est un vecteur colonne

isterminal = [1; 1]; % arret de l'int�gration si l'�v�nement est d�tect� // Vaut soit 0 soit 1 // IDEM si plusieurs conditions d'arret, vecteur colonne

direction = [1; 1]; % l'�v�nement n'est d�tect� que si la fonction �v�nement est croissante // IDEM si plusieurs conditions d'arret, vecteur colonne
end

% Extrait de la documentation :
% For ODEs: The event function specified by the function handle must have the general form
% 
% [value,isterminal,direction] = myEventsFcn(t,y)
% 
% value, isterminal, and direction are vectors whose ith element corresponds to the ith event function:
% 
% value(i) is the value of the ith event function.
% isterminal(i) = 1 if the integration is to terminate at a zero of this event function. Otherwise, it is 0.
% direction(i) = 0 if all zeros are to be located (the default). A value of +1 locates only zeros where the event function is increasing, and -1 locates only zeros where the event function is decreasing.
