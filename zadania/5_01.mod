option solver cplex;
reset;

# Parametry
set Wierzcholki; 									# Zbiór wierzchołków w grafie
set Krawedzie within Wierzcholki cross Wierzcholki; # Zbiór krawędzi w grafie, gdzie każda krawędź jest parą wierzchołków
param Koszt{Krawedzie}; 							# Parametry kosztu transportu po krawędziach
param pojemnosc{Krawedzie} >= 0; 					# Parametry pojemności każdej krawędzi
param bilans_przeplywu{Wierzcholki}; 				# Bilans przepływu towaru w każdym wierzchołku

# Zmienna decyzyjna - Ilość towaru przewożona po każdej krawędzi
var przeplyw{Krawedzie} >= 0;

# Funkcja celu - Minimalizacja całkowitego kosztu transportu
minimize CałkowityKoszt: sum{(i,j) in Krawedzie} Koszt[i,j] * przeplyw[i,j];

# Ograniczenia - Zachowanie bilansu przepływu w każdym wierzchołku
o_zachowanie_bilansu{i in Wierzcholki}: sum{(i,j) in Krawedzie} przeplyw[i,j] - sum{(j,i) in Krawedzie} przeplyw[j,i] = bilans_przeplywu[i];
o_pojemnosc_krawedzi{(i,j) in Krawedzie}: przeplyw[i,j] <= pojemnosc[i,j];

data;
set Wierzcholki := 1 2 3 4 5;
param bilans_przeplywu := 1 5 2 0 3 0 4 -2 5 -3; 
param: Krawedzie: Koszt pojemnosc :=
		    1 2   	5   	9
		    1 3   	2   	4
		    2 3   	1   	6
		    2 4   	2   	4
		    3 1   	8   	3
		    3 4   	4   	4
		    3 5   	1   	9
		    4 5   	3   	7;

solve;
display CałkowityKoszt, przeplyw;
# Wynik: CałkowityKoszt = 22
# przeplyw
# 1 2   1
# 1 3   4
# 2 4   1
# 3 4   1
# 3 5   3

end;