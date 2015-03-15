%Programa principal Dijstra

% ----- Inicializacion ----------------------------------
% function [mdistmin, mrutasmin, tam] = Dijkstra(mdist)  ---> Quitar comentario cuando se solucione el problema de la matriz de rutas minimas
function [mdistmin, tam] = dijkstra(mdist)

tam=size(mdist,1);   % Tamaño de matriz de distancias
mdistmin=zeros(tam);    %Crea matriz de distancias minimas
% mrutasmin=cell(tam);   %Crea matriz de rutas minimas       ---> Quitar comentario cuando se solucione el problema de la matriz de rutas minimas

verticesConectados = darVerticesConectados(mdist);
tamCon = size(verticesConectados, 2);

%---------------------------------------------------------
% 1º for que recorre los nodos de partida
for i=1:tam
    

    nodopartida = i;

    vdist(1:tam)=Inf;
    vdist(nodopartida)=0;
    
    if ismember(i,verticesConectados)
       vvisit(1:tam)=0;
       vparental=zeros(1,tam);
       vparental(1)=i;

       nodoactual = nodopartida;
       distminnodoactual = 0;

           % 2º for que recorre los pasos hacia adelante
           for cont2=1:tamCon
               h = verticesConectados(cont2);
               menordist = Inf;
               menordistdirecta = Inf;
               if h~= 1
                   distminnodoactual = vdist(nodoactual);
               end

               % 3º for que recorre conexiones proximas a nodoactual
               for cont3=1:tamCon
                  j = verticesConectados(cont3); 
                  if distminnodoactual + mdist(nodoactual,j) < vdist(j) && mdist(nodoactual,j) ~= 0 && vvisit(j) == 0
                       vdist(j) = distminnodoactual+mdist(nodoactual,j);
                       vparental(j) = nodoactual;
                   end
                   if vdist(j) < menordist && vdist(j) ~= 0 && vvisit(j) == 0 && j ~= nodoactual
                       menordist = vdist(j);
                       iproxnodo = j;
                   end
               end

               vvisit(nodoactual)=1;
               nodoactual = iproxnodo;        
           end
    end
        mdistmin(i,:) = vdist;
        %----------------------------------------------------------
        % Elaboracion de celda de vectores de rutas minimas
        
        %{
        
        for nodofinal=tam:-1:1
            k=nodofinal;
            vruta=zeros(1,tam);
            cont = 1;
            vruta(1)=k;   
            while k ~= nodopartida              
                    k=vparental(k);
                    %k=sigindice;
                    cont = cont +1;
                    vruta(cont)= k;
            end
            vruta = flipdim(vruta,2);       %Invierte el orden del vector ruta
            vruta(vruta==0)=[];              %Remueve ceros iniciales de vector
            mrutasmin{nodopartida, nodofinal}= vruta;
        end
        
        %}
end

end

function verticesConectados = darVerticesConectados(mdist)
tam=size(mdist,1);   % Tamaño de matriz de distancias
cont=1;

for i=1:tam
   if sum(mdist(i,:)) ~= 0 || sum(mdist(:,i)) ~= 0   % Si el vertice i esta conectado al menos unidireccionalmente a otro
      verticesConectados(cont) = i;
      cont = cont + 1;
   end
end
end



