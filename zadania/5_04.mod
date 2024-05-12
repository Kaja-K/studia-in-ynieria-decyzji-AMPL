option solver cplex;
reset;

# Parametry
set Wierzchołki;       								# Zbiór wierzchołków
set Krawędzie within Wierzchołki cross Wierzchołki; # Zbiór krawędzi (para wierzchołków) 
param Przepustowość{Krawędzie} >= 0;  				# Przepustowość dla każdej krawędzi
param Źródło;                          				# Wierzchołek źródłowy
param Ujście;                          				# Wierzchołek ujściowy

# Zmienna decyzyjna - ilość przepływu na każdej krawędzi
var Przepływ{(i,j) in Krawędzie} >= 0, <= Przepustowość[i,j];

# Funkcja celu - Minimalizacja kosztu (maksymalizacja przepływu ze źródła do ujścia)
minimize Koszt: -Przepływ[Ujście, Źródło]; 

# Ograniczenia - bilans przepływu w każdym wierzchołku
o_BilansPrzepływu{i in Wierzchołki}: sum{(i,j) in Krawędzie} Przepływ[i,j] - sum{(j,i) in Krawędzie} Przepływ[j,i] = 0;

# Dane
data;
param Źródło := 1;  
param Ujście := 5;
set Wierzchołki := 1 2 3 4 5;
param: Krawędzie: Przepustowość := 1 2 5 1 3 4  2 4 4 3 2 6 3 4 4 3 5 4 4 5 7 5 1 10;

solve;   
display Przepływ;
# Wynik:Przepływ
# 1 2   4
# 1 3   4
# 2 4   4
# 3 2   0
# 3 4   0
# 3 5   4
# 4 5   4
# 5 1   8

end;