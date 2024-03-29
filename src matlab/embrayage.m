%%%% Etude dynamique de l'embrayage centrifuge en phase d'approche

clear
close all

%%%% Grandeurs g�om�triques (unit�s S.I.)
R2 = 115e-3;
R3 = 110e-3;
R4 = 110e-3;
L  = 39.5e-3;

%%%% G�om�trie des masses (unit�s S.I.)
m1 = 5.38;
C1 = 8.989e-3;

m2 = 9.799;
C2 = 53.873e-3;

m3 = 1.723;
C3 = 4.552e-3;
a3 = 69.48e-3;

%%%% Ressort (unit�s S.I.)
k  = 88.5e3;
L0 = 79e-3;

%%%% Frottement (unit�s S.I.)
f = 0.3;

%%%% Sauvegarde des valeurs num�riques dans la structure data
data = struct('R2',R2,'R3',R3,'R4',R4,'L',L,'m1',m1,'C1',C1,'m2',m2,'C2',C2,'m3',m3,'C3',C3,'a3',a3,'k',k,'L0',L0,'f',f);

%%%% phase de d�part (1 = approche, 2 = glissement, 3 = adh�rence)
phase = 1;

%%%% d�finition de la dur�e de l'analyse
tstart = 0;
tfinal = 120;

%%%% Initialisation des vecteurs de stockage des r�sultats
resultats.t = tstart; % initialisation du vecteur des instants

CI = zeros(4,1); % conditions initiales correspondant � Q(t=tstart) : [psi2 x psi2' x'] = O // Il s'agit d'une matrice colonne de 0 de taille 4x1 // x = x3

resultats.psi2   = CI(1); % tableau de sauvegarde stockant psi2. On initialise avec les valeurs � t = 0
resultats.x      = CI(2);  % tableau de sauvegarde stockant x. On initialise avec les valeurs � t = 0
resultats.dpsi2  = CI(3); % tableau de sauvegarde stockant psi2'. On initialise avec les valeurs � t = 0
resultats.dx     = CI(4); % tableau de sauvegarde stockant x'. On initialise avec les valeurs � t = 0
resultats.ddpsi2 = 0; % tableau de sauvegarde stockant psi2". On initialise � 0 (attention, cette quantit� doit �tre calcul�e si le couple r�sistant n'est pas nul � t=0)
resultats.ddx    = 0; % tableau de sauvegarde stockant x". On initialise � 0 (attention, cette quantit� doit �tre calcul�e si le couple r�sistant n'est pas nul � t=0)

[psi1_0, dpsi1_0, ddpsi1_0] = mvt_imp(0); % Calcul du mouvement impos� � t = 0 (valeurs de psi1, psi1', psi1")

resultats.psi1   = psi1_0; % Stockage des valeurs du mouvement impos� � t=0 (valeur de psi1)
resultats.dpsi1  = dpsi1_0; % Stockage des valeurs du mouvement impos� � t=0 (valeur de psi1')
resultats.ddpsi1 = ddpsi1_0; % Stockage des valeurs du mouvement impos� � t=0 (valeur de psi1")

resultats.Cm = (C1+2*C3+2*m3*(a3+CI(2))^2)*ddpsi1_0; % Stockage de la valeur du couple moteur � t = 0

resultats.Cr = couple_resistant(0); % Stockage de la valeur du couple r�sistant � t = 0;

resultats.X23 = 0; % Stockage de la valeurs de l'effort de contact X23 � t=0
resultats.Y23 = 0; % Stockage de la valeurs de l'effort de contact Y23 � t=0

%%%% initialisation des vecteurs te_out, Qe_out et ie_out finaux
resultats.te = []; % instants de fins de phases
resultats.Qe = []; % valeurs du vecteur d'�tat Q en fins de phases
resultats.ie = []; % valeurs des indices des �v�nements de fins de phases


%while tstart < tfinal


if phase == 1

    disp('phase 1 : approche')

    %%%% options pour la r�solution de la phase d'approche
    options_approche = odeset('Events',@(t,Q) events_approche(t,Q,data),'RelTol',1e-10,'AbsTol',1e-10); %% Events est l'�v�nement de la condition d'arr�t

    %%%% r�solution du syst�me diff�rentiel de la phase d'approche (2 �quations de mvt d'ordre 2 � int�grer)
    [t,Q,te,Qe,ie] = ode45(@(t,Q) eqmvt_approche(t,Q,data),[tstart tfinal],CI,options_approche); %% CI doit etre de la meme taille que le vecteur a integr� // le vecteur t correspond aux instants d'int�gration de la phase d'approche // le vecteur te corresponds aux instants ou ya eu un event
                                                                                                    %%ie c'est l'indice des conditions d'arr�t qui ont �t� d�tect�es // conditions d'arr�t num�ro 1 puis au cours de l'int�gration c'est la num�ro 2 par exemple, ie a donc la m�me taille que te
    nt = length(t); % nombre de composantes du vecteur t apr�s int�gration

    %%%% stockage des r�sultats
    resultats.t     = [resultats.t     ; t(2:nt)  ]; % Concat�nation du vecteur de temps // On commence a 2 car on prend pas la premi�re qui a d�ja �t� calcul�
    resultats.psi2  = [resultats.psi2  ; Q(2:nt,1)]; % Concat�nation psi2
    resultats.x     = [resultats.x     ; Q(2:nt,2)]; % Concat�nation x
    resultats.dpsi2 = [resultats.dpsi2 ; Q(2:nt,3)]; % Concat�nation psi2'
    resultats.dx    = [resultats.dx    ; Q(2:nt,4)]; % Concat�nation x'

    %%%% stockage du mouvement d'entr�e
    [psi1,dpsi1,ddpsi1] = compilation_mvt_entree(t);
   
    resultats.psi1   = [resultats.psi1   ; psi1(2:nt)  ]; % Stockage : concat�nation des valeurs de psi1
    resultats.dpsi1  = [resultats.dpsi1  ; dpsi1(2:nt) ]; % Stockage : concat�nation des valeurs de psi1'
    resultats.ddpsi1 = [resultats.ddpsi1 ; ddpsi1(2:nt)]; % Stockage : concat�nation des valeurs de psi1"

    %%%% stockage du vecteur Cr
    Cr = compilation_Cr(t);
    
    resultats.Cr = [resultats.Cr ; Cr(2:nt)]; % Concat�nation

    %%%% calcul des acc�l�rations [psi2" x"] � partir des r�sultats de l'int�gration temporelle
    acc = acc_approche(t,Q,dpsi1,Cr,data);
    
    resultats.ddpsi2 = [resultats.ddpsi2 ; acc(2:nt,1)]; % Concat�nation psi2"
    resultats.ddx    = [resultats.ddx    ; acc(2:nt,2)]; % Concat�nation x"

    %%%% concat�nation du vecteur Cm
    Cm = Cm_approche(t,Q,dpsi1,ddpsi1,data);
    
    resultats.Cm = [resultats.Cm ; Cm(2:nt)];

    %%%% concat�nation des efforts X23 et Y23
    resultats.X23 = [resultats.X23 ; zeros(nt-1,1)];
    resultats.Y23 = [resultats.Y23 ; zeros(nt-1,1)];

    %%%% concat�nation du vecteur des dates o� ont lieu les �v�nements
    resultats.te = [resultats.te; te];

    %%%% concat�nation du vecteur des indices des fonctions �v�nements
    resultats.ie = [resultats.ie; ie];

    if ~(isempty(ie) || abs(te(end)-tstart)<1e-8)  % s'il y a eu un �v�nement (autre qu'aux conditions initiales) // tild est l'op�rateur de n�gation // LES deux barres c'est ET PAS SUR
        if ie(end) == 1 % si x3 = R2 - R3
            phase = 2;    % alors phase de glissement
        end
    end

    %%%% d�finition du nouveau tstart pour la phase suivante
    tstart = t(nt);

    %%%% d�finition des nouvelles conditions initiales pour la phase suivante
    CI = Q(nt,:).';
end

if phase == 2

    disp('phase 2 : glissement')
    
    
    CI = [CI(1),CI(3)];
    
    
    %%%% options pour la r�solution de la phase d'approche
    options_glissement = odeset('Events',@(t,Q) events_glissement(t,Q,data),'RelTol',1e-10,'AbsTol',1e-10); %% Events est l'�v�nement de la condition d'arr�t

    %%%% r�solution du syst�me diff�rentiel de la phase d'approche (2 �quations de mvt d'ordre 2 � int�grer)
    [t,Q,te,Qe,ie] = ode45(@(t,Q) eqmvt_glissement(t,Q,data),[tstart tfinal],CI,options_glissement); %% CI doit etre de la meme taille que le vecteur a integr� // le vecteur t correspond aux instants d'int�gration de la phase d'approche // le vecteur te corresponds aux instants ou ya eu un event
                                                                                                    %%ie c'est l'indice des conditions d'arr�t qui ont �t� d�tect�es // conditions d'arr�t num�ro 1 puis au cours de l'int�gration c'est la num�ro 2 par exemple, ie a donc la m�me taille que te
    nt = length(t); % nombre de composantes du vecteur t apr�s int�gration
    

    %%%% stockage des r�sultats
    resultats.t     = [resultats.t     ; t(2:nt)  ]; % Concat�nation du vecteur de temps // On commence a 2 car on prend pas la premi�re qui a d�ja �t� calcul�
    resultats.psi2  = [resultats.psi2  ; Q(2:nt,1)]; % Concat�nation psi2
    resultats.x     = [resultats.x     ; ones(nt-1,1).*(R2-R3)]; % Concat�nation x
    resultats.dpsi2     = [resultats.dpsi2     ; Q(2:nt,2)]; % Concat�nation psi2'
    resultats.dx    = [resultats.dx    ; zeros(nt-1,1)]; % Concat�nation x'


    %%%% stockage du mouvement d'entr�e
    [psi1,dpsi1,ddpsi1] = compilation_mvt_entree(t);
   
    resultats.psi1   = [resultats.psi1   ; psi1(2:nt)  ]; % Stockage : concat�nation des valeurs de psi1
    resultats.dpsi1  = [resultats.dpsi1  ; dpsi1(2:nt) ]; % Stockage : concat�nation des valeurs de psi1'
    resultats.ddpsi1 = [resultats.ddpsi1 ; ddpsi1(2:nt)]; % Stockage : concat�nation des valeurs de psi1"

    %%%% stockage du vecteur Cr
    Cr = compilation_Cr(t);
    
    resultats.Cr = [resultats.Cr ; Cr(2:nt)]; % Concat�nation

     %%%% calcul des acc�l�rations [psi2"] � partir des r�sultats de l'int�gration temporelle
     acc = acc_glissement(t,Q,dpsi1,Cr,data);
%     
     resultats.ddpsi2 = [resultats.ddpsi2 ; acc(2:nt,1)]; % Concat�nation psi2"
     resultats.ddx    = [resultats.ddx    ; zeros(nt-1,1)]; % Concat�nation x"
% 
     %%%% concat�nation du vecteur Cm
     Cm = Cm_glissement(t,Q,dpsi1,ddpsi1,data);
%     
     resultats.Cm = [resultats.Cm ; Cm(2:nt)];

     [X23,Y23] = efforts_glissement(t,Q,dpsi1,ddpsi1,data);
%     %%%% concat�nation des efforts X23 et Y23
     resultats.X23 = [resultats.X23 ; X23(2:nt)];
     resultats.Y23 = [resultats.Y23 ; Y23(2:nt)];
% 
%     %%%% concat�nation du vecteur des dates o� ont lieu les �v�nements
     resultats.te = [resultats.te; te];
% 
%     %%%% concat�nation du vecteur des indices des fonctions �v�nements
     resultats.ie = [resultats.ie; ie];
% 
    if ~(isempty(ie) || abs(te(end)-tstart)<1e-8)  % s'il y a eu un �v�nement (autre qu'aux conditions initiales) // tild est l'op�rateur de n�gation // LES deux barres c'est ET PAS SUR
        if ie(end) == 1 % si x3 = R2-R3
            phase = 2;    % alors phase de glissement
        else % si X23=0 si dpsi1 - dpsi2 = 0
            phase = 3;    % alors phase de glissement
        end
    end

    %%%% d�finition du nouveau tstart pour la phase suivante
    tstart = t(nt);

    %%%% d�finition des nouvelles conditions initiales pour la phase suivante
    CI = [Q(nt, 1), R2-R3, Q(nt,2), 0];
end
 
if phase == 3

    disp('phase 3 : adh�rence')
    
    CI = CI(1);
    
    
    %%%% options pour la r�solution de la phase d'approche
    options_adherence = odeset('Events',@(t,Q) events_adherence(t,Q,data),'RelTol',1e-10,'AbsTol',1e-10); %% Events est l'�v�nement de la condition d'arr�t

%     %%%% r�solution du syst�me diff�rentiel de la phase d'approche (2 �quations de mvt d'ordre 2 � int�grer)
    [t,Q,te,Qe,ie] = ode45(@(t,Q) EDL_adherence(t,Q,data),[tstart tfinal],CI,options_adherence); %% CI doit etre de la meme taille que le vecteur a integr� // le vecteur t correspond aux instants d'int�gration de la phase d'approche // le vecteur te corresponds aux instants ou ya eu un event
                                                                                                    %%ie c'est l'indice des conditions d'arr�t qui ont �t� d�tect�es // conditions d'arr�t num�ro 1 puis au cours de l'int�gration c'est la num�ro 2 par exemple, ie a donc la m�me taille que te
    nt = length(t); % nombre de composantes du vecteur t apr�s int�gration
    
     %%%% stockage du mouvement d'entr�e
     [psi1,dpsi1,ddpsi1] = compilation_mvt_entree(t);

%     %%%% stockage des r�sultats
     resultats.t     = [resultats.t     ; t(2:nt)  ]; % Concat�nation du vecteur de temps // On commence a 2 car on prend pas la premi�re qui a d�ja �t� calcul�
     resultats.psi2  = [resultats.psi2  ; Q(2:nt)]; % Concat�nation psi2
     resultats.x     = [resultats.x     ; ones(nt-1,1).*(R2-R3)]; % Concat�nation x
     resultats.dpsi2     = [resultats.dpsi2     ; dpsi1(2:nt)]; % Concat�nation psi2'
     resultats.dx    = [resultats.dx    ; zeros(nt-1,1)]; % Concat�nation x'
% 
% 
%    
%    
     resultats.psi1   = [resultats.psi1   ; psi1(2:nt)  ]; % Stockage : concat�nation des valeurs de psi1
     resultats.dpsi1  = [resultats.dpsi1  ; dpsi1(2:nt) ]; % Stockage : concat�nation des valeurs de psi1'
     resultats.ddpsi1 = [resultats.ddpsi1 ; ddpsi1(2:nt)]; % Stockage : concat�nation des valeurs de psi1"
% 
%     %%%% stockage du vecteur Cr
     Cr = compilation_Cr(t);
%     
     resultats.Cr = [resultats.Cr ; Cr(2:nt)]; % Concat�nation
% 
%      %%%% calcul des acc�l�rations [psi2"] � partir des r�sultats de l'int�gration temporelle
%      acc = acc_glissement(t,Q,dpsi1,Cr,data);
% %     
      resultats.ddpsi2 = [resultats.ddpsi2 ; ddpsi1(2:nt)]; % Concat�nation psi2"
      resultats.ddx    = [resultats.ddx    ; zeros(nt-1,1)]; % Concat�nation x"
% % 
% %      %%%% concat�nation du vecteur Cm
       Cm = Cm_adherence(t,Q,dpsi1,ddpsi1,data);    
       resultats.Cm = [resultats.Cm ; Cm(2:nt)];
% 
      [X23,Y23] = efforts_adherence(t,Q,dpsi1,ddpsi1,data);
% %     %%%% concat�nation des efforts X23 et Y23
      resultats.X23 = [resultats.X23 ; X23(2:nt)];
      resultats.Y23 = [resultats.Y23 ; Y23(2:nt)];
% % 
% %     %%%% concat�nation du vecteur des dates o� ont lieu les �v�nements
      resultats.te = [resultats.te; te];
% % 
% %     %%%% concat�nation du vecteur des indices des fonctions �v�nements
      resultats.ie = [resultats.ie; ie];
% % 
    if ~(isempty(ie) || abs(te(end)-tstart)<1e-8)  % s'il y a eu un �v�nement (autre qu'aux conditions initiales) // tild est l'op�rateur de n�gation // LES deux barres c'est ET PAS SUR
        if ie(end) == 1 % si x3 = R2-R3
            phase = 2;    % alors phase de glissement
        else % si X23=0 si dpsi1 - dpsi2 = 0
            phase = 3;    % alors phase de glissement
        end
    end

    %%%% d�finition du nouveau tstart pour la phase suivante
    tstart = t(nt);

    %%%% d�finition des nouvelles conditions initiales pour la phase suivante
    %CI = [Q(nt, 1), R2-R3, Q(nt,2), 0];
end

%end


 %%%% Trac� de psi2  psi2' psi2"
 figure
 subplot(1,3,1)
 plot(resultats.t,resultats.psi2,'linewidth',1.5)
 title('$$\psi_2$$ en fonction du temps','Interpreter','latex')
 xlabel('t')
 ylabel('$$\psi_2$$','Interpreter','latex')
grid on
subplot(1,3,2)
plot(resultats.t,resultats.dpsi2,'linewidth',1.5)
title('$$\dot\psi_2$$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$\dot\psi_2$$','Interpreter','latex')
grid on
subplot(1,3,3)
plot(resultats.t,resultats.ddpsi2,'linewidth',1.5)
title('$$\ddot\psi_2$$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$\ddot\psi_2$$','Interpreter','latex')
grid on


%%%% Trac� de x x' x"
figure
subplot(1,3,1)
plot(resultats.t,resultats.x,'linewidth',1.5)
title('x en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('x')
grid on
subplot(1,3,2)
plot(resultats.t,resultats.dx,'linewidth',1.5)
title('$$\dot x $$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$\dot x $$','Interpreter','latex')
grid on
subplot(1,3,3)
plot(resultats.t,resultats.ddx,'linewidth',1.5)
title('$$\ddot x $$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$\ddot x $$','Interpreter','latex')
grid on

% % %%%% Trac� de X23 et Y23
figure
subplot(1,2,1)
plot(resultats.t,resultats.X23,'linewidth',1.5)
title('Effort normal $$X_{23}$$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$X_{23}$$','Interpreter','latex')
grid on
subplot(1,2,2)
plot(resultats.t,resultats.Y23,'linewidth',1.5)
title('Effort tangentiel $$Y_{23}$$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$Y_{23}$$','Interpreter','latex')
grid on

%%%% trac� de la vitesse d'entr�e et de la vitesse de sortie
figure
plot(resultats.t,resultats.dpsi2,'b',resultats.t,resultats.dpsi1,'r','linewidth',1.5)
title('$$\dot\psi_2$$ et $$\dot\psi_1$$ en fonction du temps','Interpreter','latex')
legend('dpsi2','dpsi1')
xlabel('t')
ylabel('$$\dot\psi$$','Interpreter','latex')
grid on


% %%%% Trac� du couple moteur et du couple r�sistant
figure
plot(resultats.t,resultats.Cm,'b',resultats.t,resultats.Cr,'r','linewidth',1.5)
legend('Cm','Cr')
title('Cm et Cr en fonction du temps','Interpreter','latex')
xlabel('t')
grid on


%%%% Trac� du mouvement d'entr�e
figure
subplot(1,3,1)
plot(resultats.t,resultats.psi1,'linewidth',1.5)
title('$$\psi_1$$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$\psi_1$$','Interpreter','latex')
grid on
subplot(1,3,2)
plot(resultats.t,resultats.dpsi1,'linewidth',1.5)
title('$$\dot\psi_1$$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$\dot\psi_1$$','Interpreter','latex')
grid on
subplot(1,3,3)
plot(resultats.t,resultats.ddpsi1,'linewidth',1.5)
title('$$\ddot\psi_1$$ en fonction du temps','Interpreter','latex')
xlabel('t')
ylabel('$$\ddot\psi_1$$','Interpreter','latex')
grid on
