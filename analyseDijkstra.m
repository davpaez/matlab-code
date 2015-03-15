% Analizar tiempo algoritmo Dijkstra
clc
clear

% Parámetros análisis
maxTamRed = 500;
paso = 10;

% Cuerpo Programa
elem=2:paso:maxTamRed;
nelem = size(elem,2);
time = zeros(nelem,1);

for i=1:size(elem,2)
    mdist = rand(elem(i)).*not(eye(elem(i)));
    tic;
    mdistmin = dijkstra(mdist);
    time(i) = toc;
    
end

totalTime = sum(time)
plot(elem',time)
