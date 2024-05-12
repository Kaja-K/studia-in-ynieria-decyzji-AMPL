option solver cplex;
reset;

# Parametry
set Wierzchołki; 									# Zbiór wierzchołków w grafie
set Krawędzie within Wierzchołki cross Wierzchołki; # Zbiór krawędzi w grafie, gdzie każda krawędź jest parą wierzchołków
param Odległość{Krawędzie}; 						# Parametry odległości dla każdej krawędzi

# Zmienna decyzyjna - długość najkrótszej ścieżki od wierzchołka A do każdego innego wierzchołka
var DługośćŚcieżki{Wierzchołki} >= 0;

# Minimalizacja długości najkrótszej ścieżki od wierzchołka A do wierzchołka E
minimize DługośćNajkrótszejŚcieżki: DługośćŚcieżki['E'];

# Ograniczenia najkrótszej ścieżki:
OgraniczenieNajkrótszejŚcieżki{(i,j) in Krawędzie}: DługośćŚcieżki[j] <= DługośćŚcieżki[i] + Odległość[i,j];

# Dane
data;
set Wierzchołki := A B C D E;
param: Krawędzie: Odległość := A B 6 A C 9 B C 1 B D 4 C D 1 C E 5 D E 2 D C 4;

solve;
display DługośćŚcieżki;
# Wynik:
# DługośćŚcieżki 
# A  0
# B  3
# C  4
# D  0
# E  0

end;
