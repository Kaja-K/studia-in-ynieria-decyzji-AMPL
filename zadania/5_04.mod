option solver cplex;
reset;

# Parametry
set Wierzchołki;                                     # Zbiór wierzchołków w grafie
set Krawędzie within Wierzchołki cross Wierzchołki;  # Zbiór krawędzi w grafie, gdzie każda krawędź jest parą wierzchołków
param PrzepływStartowy{Krawędzie};                   # Przepływ początkowy na każdej krawędzi
param Pojemność{Krawędzie} >= 0;                     # Pojemność każdej krawędzi - maksymalny przepływ, który może przez nią przejść

# Zmienna decyzyjna - przepływ na każdej krawędzi
var Przepływ{Krawędzie} >= 0;

# Funkcja celu - maksymalizacja przepływu na krawędziach wychodzących ze źródła
maximize MaksymalnyPrzepływ: sum{(s,j) in Krawędzie} Przepływ[s,j];

# Ograniczenia:
o_Pojemności {(i,j) in Krawędzie}: Przepływ[i,j] <= Pojemność[i,j];
o_Bilansu {j in Wierzchołki: j!= s and j!= t}: sum{(i,j) in Krawędzie} Przepływ[i,j] - sum{(j,k) in Krawędzie} Przepływ[j,k] = 0;
o_PrzepływŹródła {j in Wierzchołki: (s,j) in Krawędzie}: Przepływ[s,j] = PrzepływStartowy[s,j]; 

# Dane
data;
set Wierzchołki := s 2 3 4 t;  
set Krawędzie := (s, 2) (s, 3) (3, 2) (2, 4) (3, 4) (3, t) (4, t);  
param PrzepływStartowy := s 2 5 s 3 4 3 2 6 2 2 4 4 3 4 4 3 t 4 4 4 t 7;
param Pojemność := s 2 4 s 3 4 3 2 6 2 2 4 4 3 4 4 3 t 4 4 4 t 7; 

solve;
display Przepływ, MaksymalnyPrzepływ;

end;
