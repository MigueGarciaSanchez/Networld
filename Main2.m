function [K,L,Flags]=Main2(N)
%% La función Main será nuestra función principal 
% Realiza la unión de redes desde nodos sueltos.
% Se comienza con N nodos sueltos
% Variables:

%%Inputs:
%   N: Número de nodos iniciales

%%Outputs:
%   K: Contiene todas las matrices de distintos tamaños que surgen. Esto será
%      de utilidad para un programa donde veremos el número de configuraciones
%   L: Matriz final (en principio deberían unirse todas)
%   Flags: Vector que contiene como termino cada union. 1: Lista,
%   2:Contador, 3:Bucle.
%%%%%%%%%%% Variables que antes Devolvia %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% W: Es una variable que guarda los pasos que se han realizado en cada
% unión. 0 (rechazado el link), 1 (aceptado el link), 2 (la unión ha
% parado).

%% Variables K, L, W inciales
% W =[];
K{N} = []; % K llevará todas las matrices de distintos tamaños
for i = 1: N
    L{i} = 0; % Nodos sueltos
    K{1}{i} = L{i}; %Las matrices iniciales son de tamaño 1 (nodos)
end
Flags = [];


%% Bucle principal
P = eye(N); % Matriz deparada
while isequal(P,ones(N))==0  
%Elegimos dos redes aleatorias distintos
[R1, R2] = ElegirRedes(P);
A = L{R1};
B = L{R2};
%Unimos las redes
[T,Permitido,Fin_Union] =  Unir2(A, B);
Flags = horzcat(Flags,Fin_Union);

% W = horzcat(W,M);
if Permitido == 1
%Si la unión es posible, se realiza
    L{R1} = T;
    L(R2) = [];
    n = max(size(T)); %Tamaño de la T
    m = max(size(K{n})); 
    K{n}{m+1} = T;
    N = max(size(L));
    P = eye(N);
else
    %Se ha intentado la unión y no ha sido posible.
    P(R1,R2) = 1;
    P(R2,R1) = 1;
%Flags = horzcat(Flags, 4);
end
end