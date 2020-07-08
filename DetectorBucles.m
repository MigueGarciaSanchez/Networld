function bucle = DetectorBucles(R)
n_bucle = 4;
 %cuantos bucles quiero que se deban repetir para asimilar que es estable. Debe ser 3 o mas.
R2=R(end,:);
x =bsxfun(@minus,R,R2);
[nx,mx] = size(x);
for i = 1:nx
    for j = 1:mx
        if x(i,j) < 1e-12
            x(i,j) = 0;
        end
    end
end
    
comp=any(x,2);
D=find(~comp);%D es la lista de filas iguales a la ultima.
tamD=size(D,1);
if tamD>n_bucle %para ahorrar tiempo solo compara si ha hecho n_bucle bucles   
    D=D(end-n_bucle:end); %Ultimos (n_buclesI indideces
    % Imaginate que los indices son 5,7,9,11,13. Entonces el módulo de D
    % con 13-11 va a ser un vector 1,1,1,1,1
    B=mod(D,D(end)-D(end-1)); %Si todo B es igual entonces hay que parar.
    if size(unique(B))==1 %Numero de elementos distintos en B
    bucle=D(end)-D(end-1);
%     fprintf('Hay %d bucles de longitud %d \n',n_bucle,bucle)
    else
        %fprintf('Hay al menos %d bucles pero irregulares\n',n_bucle)
        bucle = -1; %Tamaño Irregular
    end
else 
% fprintf(' Hay menos de %d bucles  \n',tamD)  
bucle = 0;
end
end