%%Programa Lanzar Links:
%Variables 
%na, nb, T, x,y

function [T,Flag_Bucle,M,R,Acierto,Parada_Bucle]=LanzarLinks(na,nb,T,x,y,R,Parada_Bucle,Contador)
W = zeros(1,na+nb);
Flag_Bucle = 0; 
Acierto = 0;
%% Tenemos que mirar si algun nodo ya está conectado
        % T1 va a ser la matriz cambiada y T con los nodos sin cambiar de pos.
        % Es decir, T1 es la nueva y T la antigua.
        T1 = T; 
        if max(T(x, na+1:na+nb)) == 1 %Si es 1 el nodo x de la red A está conectado a la red B
            nx = find(T(x, na+1:na+nb));
            T1(x, na + nx) = 0;
            T1(nx+na, x ) = 0;
        end
        if max(T(na + y, 1:na)) == 1 %Si es 1 el nodo y de la red B está conectado a la red A
            ny = find(T(na +y, 1:na));
            T1(na + y, ny) = 0;
            T1(ny, na + y ) = 0;
        end

        %Unimos las redes por el Nodo
        T1(x, na + y) = 1;
        T1(na + y, x) = 1;

        % Comprobamos si ha mejorado la centralidad 
        [u_T, lambda_T] = Autov2(T);
        [u_T1, lambda_T1] = Autov2(T1);
        cx_T  = Centrality2(u_T,lambda_T, x);
        cy_T  = Centrality2(u_T,lambda_T, na+y);
        cx_T1 = Centrality2(u_T1,lambda_T1, x);
        cy_T1 = Centrality2(u_T1,lambda_T1, na +y);
        Mejora = min(cx_T1-cx_T, cy_T1-cy_T);
        if Mejora > 1e-6 %Condición de union
         %% Acierto
            T = T1;
            Acierto = 1;
            M = 1; %El link se ha anadido
            %%Matriz de Centralidades
            for j = 1:na+nb
                C = Centrality2(u_T1,lambda_T1, j);
                W(j) = C;
            end
            W = sort(W);
            R = vertcat(R,W);
            %%Vemos si hay bucles para los ultimos 100 aciertos y aumentamos el contador de aciertos	
            if Parada_Bucle == 0
                Long_Bucle = DetectorBucles(R); %R(end-100:end,:)
                if Long_Bucle ~= 0 
                    r = poissrnd(5);
                    Parada_Bucle = r+Contador;
                end
            elseif Contador == Parada_Bucle
                Flag_Bucle = 1;
            end
            
        else
           M = 0; % El link no se ha anadido
        end
end