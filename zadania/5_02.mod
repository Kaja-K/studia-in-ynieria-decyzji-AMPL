option solver cplex;
reset;

# Parametry
set Wierzchołki;                                    # Zbiór wierzchołków w grafie
set Krawędzie within Wierzchołki cross Wierzchołki; # Zbiór krawędzi w grafie
param Odległość{Krawędzie};                         # Odległość każdej krawędzi
param RóżnicaStrumieni{Wierzchołki};                # Parametr różnica strumieni dla każdego wierzchołka

# Zmienna decyzyjna - czy dana krawędź jest wykorzystywana w ścieżce
var Użyta{(i,j) in Krawędzie} binary;

# Funkcja celu - Minimalizacja całkowitej odległości
minimize CałkowitaOdległość: sum{(i,j) in Krawędzie} Odległość[i,j] * Użyta[i,j];

# Ograniczenie - różnica strumieni dla każdego wierzchołka
o_Strumieni{i in Wierzchołki}: sum{(i,j) in Krawędzie} Użyta[i,j] - sum{(j,i) in Krawędzie} Użyta[j,i] = RóżnicaStrumieni[i]; # Ograniczenie równoważności strumieni

# Dane
data;
set Wierzchołki := A B C D E;
param RóżnicaStrumieni:= A 1 B 0 C 0 D 0 E -1;
param: Krawędzie: Odległość :=  A B 6 A C 9 B C 1 B D 4 C D 1 C E 5 D C 4 D E 2;
 
solve;
display Użyta, CałkowitaOdległość;
# Wynik: CałkowitaOdległość = 10
# Użyta 
# A B   1
# A C   0
# B C   1
# B D   0
# C D   1
# C E   0
# D C   0
# D E   1
# Ścieżka: A - B - C - D - E 

end;
