
function [T,Permitido,Fin_Union] =  Unir2(A, B)

%% Función Unir2(A,B)
% Une dos redes A,B de acuerdo al criterio de ganar centralidad (>)
% Para que la centralidad de la mayor sea 1 y la de la pequeña sea 0, se
% unen primero por bloques siendo el primer bloque el de la mayor y el
% segundo el de la menor.
% Inputs:
%   A,B: Matrices de adyacencia de las redes.
% Outputs:
%   T: Matriz de adyacencia de la red final.
%   Permitido: Vale 0 si no se han unido y 1 si se han unido.

%%%%%%  VARIABLES QUE ANTES DEVOLVIA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Ms: Acciones realizadas (0 si el link no se ha unido, 1 si se ha unido y
%      2 si la unión ha llegado al final).
%	R: Matriz con las centralidades de los nodos que se dan en cada unión.
%   Terminar: 1 Si terminó por lista, 2 Si terminó por contador y 3 si por bucle.


%% Variables iniciales
[na,~] = size(A);
[nb,~] = size(B);

T_Contador = (na+nb)^3;


%% Unimos la redes por primera vez
if na < nb
    A1 = B;
    A2 = A;
    T = blkdiag(A1, A2);
else 
    A1 = A;
    A2 = B;
    T = blkdiag(A1,A2);
end

%% Contadores de parada
[na,~] = size(A1);
[nb,~] = size(A2);

%%Generamos la lista y la permutamos.
L1 = 1:1:na; 
L2 = 1:1:nb;
[L1,L2] = ndgrid(L1,L2);
Lista = [L1(:),L2(:)];
Lista = Lista';
[~,Len_Lista] = size(Lista);


%% Bucle Principal  
%Banderas de parada
Flag_List = 0;
Flag_Counter = 0; 
Flag_Bucle = 0; 
Flag_azar = 1;
Parada_Bucle = 0;
%Variables
% Ms = [];
Contador = 0;
R = []; %Matriz con las centralidades

% Ms = [Ms,M]; %Vector con las acciones de cada Link, acierto o fallo ya no
% lo necesito

while  Flag_List == 0 && Flag_Counter == 0 && Flag_Bucle == 0    
    if Flag_azar == 1 %Lanzamos links primero
        for i = 1:2
            x = randi(na);
            y = randi(nb);
            [T,Flag_Bucle,M,R,Acierto,Parada_Bucle]=LanzarLinks(na,nb,T,x,y,R,Parada_Bucle,Contador);
%             Ms = [Ms,M]; 
            Contador = Contador + M;    
            %%Puede acabar por bucle
            if Flag_Bucle == 1
               Fin_Union = 3;
                break
            end
            %%Puede acabar por contador
            if Contador > T_Contador
               Flag_Counter = 1;
               Fin_Union = 2;
               break
            end  
        end 
        Flag_azar = 0;
        
    elseif Flag_azar == 0
        %%Reordenamos la lista
        x1 = randperm(Len_Lista);
        Lista(1,:) = Lista(1,x1);
        Lista(2,:) = Lista(2,x1);
        %%Seguimos la lista
        for i = 1:Len_Lista
            x = Lista(1,i);
            y = Lista(2,i);
            [T,Flag_Bucle,M,R,Acierto,Parada_Bucle]=LanzarLinks(na,nb,T,x,y,R,Parada_Bucle,Contador);
            Contador = Contador +M;
            %%Si hay un bucle hay que parar
            if Flag_Bucle == 1
                Fin_Union = 3;
                break
            end
            
            if Contador > T_Contador
                Flag_Counter = 1;
                Fin_Union = 2;
                break
            end           
            %%Si hay un acierto hay que salir y continuar eligiendo al azar
            if M ==1
                Flag_azar = 1;    
                break
            end
            %%Si se acaba la lista hay que poner la badera de fin a 1
            if i == Len_Lista
                Flag_List = 1;
                Fin_Union = 1;
            end
        end   
    end
end

%% Comprogamos que las redes se han unido
if isequal(T,blkdiag(A1, A2)) == 1
    Permitido = 0;
else 
    Permitido = 1;
end

% Ms =[Ms,2]; % Termina el proceso.
% R = array2table(R);
end

