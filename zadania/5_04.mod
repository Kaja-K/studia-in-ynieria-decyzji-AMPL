option solver cplex;
reset;

# Parametry
set wierzcholki; # Zbiór wierzchołków w grafie
set krawedzie within wierzcholki cross wierzcholki; # Zbiór krawędzi (para wierzchołków) 
param przepustowosc{krawedzie} >= 0; # Przepustowość dla każdej krawędzi
param zrodlo; # Wierzchołek źródłowy
param ujscie; # Wierzchołek ujściowy

# Zmienna decyzyjna - Ilość przepływu na każdej krawędzi
var przeplyw{(pw,kw) in krawedzie} >= 0, <= przepustowosc[pw,kw];

# Funkcja celu - Minimalizacja kosztu (przepływu ze źródła do ujścia)
minimize koszt: -przeplyw[ujscie, zrodlo]; 

# Ograniczenia - Bilans przepływu w każdym wierzchołku
o_bilans_przeplywu{pw in wierzcholki}: sum{(pw,kw) in krawedzie} przeplyw[pw,kw] - sum{(kw,pw) in krawedzie} przeplyw[kw,pw] = 0;

data;
param zrodlo := 1;  
param ujscie := 5;
set wierzcholki := 1 2 3 4 5;
param: krawedzie: przepustowosc := 1 2 5 1 3 4 2 4 4 3 2 6 3 4 4 3 5 4 4 5 7 5 1 10;

solve;   
display koszt, przeplyw;
end;