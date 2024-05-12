option solver cplex;
reset;

# Parametry
set Wierzchołki; 									# Zbiór wierzchołków w grafie
set Krawędzie within Wierzchołki cross Wierzchołki; # Zbiór krawędzi w grafie, gdzie każda krawędź jest parą wierzchołków
param Koszt{Krawędzie}; 							# Parametry kosztu transportu po krawędziach
param Pojemność{Krawędzie} >= 0; 					# Parametry pojemności każdej krawędzi
param BilansPrzepływu{Wierzchołki}; 				# Bilans przepływu towaru w każdym wierzchołku

# Zmienna decyzyjna - ilość towaru przewożona po każdej krawędzi
var Przepływ{Krawędzie} >= 0;

# Minimalizacja całkowitego kosztu transportu
minimize CałkowityKoszt: sum{(i,j) in Krawędzie} Koszt[i,j] * Przepływ[i,j];

# Ograniczenia:  - Zachowanie bilansu przepływu w każdym wierzchołku
o_ZachowanieBilansu{i in Wierzchołki}: sum{(i,j) in Krawędzie} Przepływ[i,j] - sum{(j,i) in Krawędzie} Przepływ[j,i] = BilansPrzepływu[i];
o_PojemnościKrawędzi{(i,j) in Krawędzie}: Przepływ[i,j] <= Pojemność[i,j];

# Dane
data;
set Wierzchołki := 1 2 3 4 5;
param: Krawędzie: Koszt Pojemność :=
    1 2   5   9
    1 3   2   4
    2 3   1   6
    2 4   2   4
    3 1   8   3
    3 4   4   4
    3 5   1   9
    4 5   3   7;
param BilansPrzepływu := 1 5 2 0 3 0 4 -2 5 -3; 

solve;
display CałkowityKoszt, Przepływ;
# Wynik: CałkowityKoszt = 22
# Przepływ
# 1 2   1
# 1 3   4
# 2 3   0
# 2 4   1
# 3 1   0
# 3 4   1
# 3 5   3
# 4 5   0

end;
