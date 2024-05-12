option solver cplex;
reset;

# Parametry
set Wierzchołki;                                    # Zbiór wierzchołków w grafie
set Krawędzie within Wierzchołki cross Wierzchołki; # Zbiór krawędzi w grafie
param Odległość{Krawędzie};                         # Odległość każdej krawędzi

# Zmienna decyzyjna - czy dana krawędź jest wykorzystywana w ścieżce
var Użyta{(i,j) in Krawędzie} binary;

# Funkcja celu - Minimalizacja całkowitej odległości
minimize CałkowitaOdległość: sum{(i,j) in Krawędzie} Odległość[i,j] * Użyta[i,j];

# Ograniczenia - ścieżka musi zaczynać się w wierzchołku A i kończyć się w wierzchołku E
o_Początek: sum{j in Wierzchołki: ("A",j) in Krawędzie} Użyta["A",j] == 1; # Ścieżka musi zaczynać się w wierzchołku A
o_Koniec: sum{i in Wierzchołki: (i,"E") in Krawędzie} Użyta[i,"E"] == 1;   # Ścieżka musi kończyć się w wierzchołku E

# Dane
data;
set Wierzchołki := A B C D E;
param: Krawędzie: Odległość :=  A B 6 A C 9 B C 1 B D 4 C D 1 C E 5 D C 4 D E 2;

solve;
display Użyta, CałkowitaOdległość;
# Wynik:CałkowitaOdległość = 8
# Ścieżka: A - B - D - E 

end;