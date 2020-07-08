
function [u_T, lambda_T] = Autov2(A)
[W, D] = eig(A);% V autovector columna % D matriz diagonal con autovalores
[lambda_T,Ind] =max(max(D)); % Autovalor maximo
V = W(:,Ind)';
u_T = abs(V); % Autovector asociado a Lambda_T
end