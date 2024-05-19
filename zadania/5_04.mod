option solver cplex;
reset;

# Parametry
set Wierzcholki;       								# Zbiór wierzchołków
set Krawedzie within Wierzcholki cross Wierzcholki; # Zbiór krawędzi (para wierzchołków) 
param przepustowosc{Krawedzie} >= 0;  				# przepustowosc dla każdej krawędzi
param zrodlo;                          				# Wierzchołek źródłowy
param ujscie;                          				# Wierzchołek ujściowy

# Zmienna decyzyjna - Ilość przepływu na każdej krawędzi
var przeplyw{(i,j) in Krawedzie} >= 0, <= przepustowosc[i,j];

# Funkcja celu - Minimalizacja kosztu (maksymalizacja przepływu ze źródła do ujścia)
minimize koszt: -przeplyw[ujscie, zrodlo]; 

# Ograniczenia - bilans przepływu w każdym wierzchołku
o_bilans_przeplywu{i in Wierzcholki}: sum{(i,j) in Krawedzie} przeplyw[i,j] - sum{(j,i) in Krawedzie} przeplyw[j,i] = 0;

data;
param zrodlo := 1;  
param ujscie := 5;
set Wierzcholki := 1 2 3 4 5;
param: Krawedzie: przepustowosc := 1 2 5 1 3 4  2 4 4 3 2 6 3 4 4 3 5 4 4 5 7 5 1 10;

solve;   
display koszt, przeplyw;
# Wynik: koszt = -8
# przeplyw
# 1 2   4
# 1 3   4
# 2 4   4
# 3 5   4
# 4 5   4
# 5 1   8

end;