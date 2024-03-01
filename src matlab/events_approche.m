%%%% définition des fonctions évènement détectant la sortie de la phase
%%%% d'approche

function [value,isterminal,direction]=events_approche(tn,Qn,data)

%%%% Récupération des données numériques utiles
R2 = data.R2;
R3 = data.R3;

%%%% Valeur de x au pas courant
x = Qn(2);

value = x - R2  + R3; % x atteint la valeur R2 - R3 TJRS FONCTION EGALE A 0 // SI plusieurs conditions d'arrets alors value est un vecteur colonne

isterminal = 1; % arret de l'intégration si l'évènement est détecté // Vaut soit 0 soit 1 // IDEM si plusieurs conditions d'arret, vecteur colonne

direction = 1; % l'évènement n'est détecté que si la fonction évènement est croissante // IDEM si plusieurs conditions d'arret, vecteur colonne
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
