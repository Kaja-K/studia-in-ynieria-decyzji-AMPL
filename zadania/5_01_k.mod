option solver cplex;
reset;

# Parametry
set wierzcholki; 									# Zbiór wierzchołków w grafie
set krawedzie within wierzcholki cross wierzcholki; # Zbiór krawędzi w grafie, gdzie każda krawędź jest parą wierzchołków
param koszt{krawedzie}; 							# Koszt transportu po krawędziach
param pojemnosc{krawedzie} >= 0; 					# Pojemność każdej krawędzi
param bilans_przeplywu{wierzcholki}; 				# Bilans przepływu towaru w każdym wierzchołku

# Zmienna decyzyjna - Ilość towaru przewożona po każdej krawędzi
var przeplyw{krawedzie} >= 0;

# Funkcja celu - Minimalizacja całkowitego kosztu transportu.  Działa ona poprzez sumowanie kosztów transportu po każdej krawędzi, pomnożonych przez ilość towaru przewożonego tą krawędzią. Ostateczna wartość funkcji celu jest sumą tych kosztów dla wszystkich krawędzi w grafie.
minimize calkowity_koszt: sum{(i,j) in krawedzie} koszt[i,j] * przeplyw[i,j];

# Ograniczenia - Zachowanie bilansu przepływu w każdym wierzchołku oraz gwarancja, że ilość towaru przewożonego po każdej krawędzi nie przekracza jej pojemności.
o_zachowanie_bilansu{i in wierzcholki}: sum{(i,j) in krawedzie} przeplyw[i,j] - sum{(j,i) in krawedzie} przeplyw[j,i] = bilans_przeplywu[i];# Dla każdego wierzchołka, różnica między sumą towaru wchodzącego do wierzchołka a sumą towaru wychodzącego z wierzchołka musi być równa bilansowi przepływu tego wierzchołka.
o_pojemnosc_krawedzi{(i,j) in krawedzie}: przeplyw[i,j] <= pojemnosc[i,j];																	# Dla każdej krawędzi, ilość towaru przewożonego tą krawędzią nie może przekroczyć wartości pojemności tej krawędzi.

data;
set wierzcholki := 1 2 3 4 5;
param bilans_przeplywu := 1 5 2 0 3 0 4 -2 5 -3; 
param: krawedzie: koszt pojemnosc :=1 2   	5   	9
								    1 3   	2   	4
								    2 3   	1   	6
								    2 4   	2   	4
								    3 1   	8   	3
								    3 4   	4   	4
								    3 5   	1   	9
								    4 5   	3   	7;
solve;
display calkowity_koszt, przeplyw;
end;