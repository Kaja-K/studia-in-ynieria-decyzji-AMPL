option solver cplex;
reset;

# Parametry
set wierzcholki;									# Zbiór wierzchołków w grafie
set krawedzie within wierzcholki cross wierzcholki; # Zbiór krawędzi (para wierzchołków) 
param przepustowosc{krawedzie} >= 0; 				# Przepustowość dla każdej krawędzi
param zrodlo; 										# Wierzchołek źródłowy
param ujscie;										# Wierzchołek ujściowy

# Zmienna decyzyjna - Ilość przepływu na każdej krawędzi
var przeplyw{(i,j) in krawedzie} >= 0, <= przepustowosc[i,j];

# Funkcja celu - Minimalizacja kosztu (przepływu ze źródła do ujścia)
minimize koszt: -przeplyw[ujscie, zrodlo]; 

# Ograniczenia - Bilans przepływu w każdym wierzchołku
o_bilans_przeplywu{i in wierzcholki}: sum{(i,j) in krawedzie} przeplyw[i,j] - sum{(j,i) in krawedzie} przeplyw[j,i] = 0;

data;
param zrodlo := 1;  
param ujscie := 5;
set wierzcholki := 1 2 3 4 5;
param: krawedzie: przepustowosc := 1 2 5 1 3 4 2 4 4 3 2 6 3 4 4 3 5 4 4 5 7 5 1 10;

solve;   
display koszt, przeplyw;
end;