option solver cplex;
reset;

# Parametry
set wierzcholki;									# Zbiór wierzchołków w grafie
set krawedzie within wierzcholki cross wierzcholki;	# Zbiór krawędzi w grafie
param odleglosc{krawedzie};							# Odległość każdej krawędzi
param roznica_strumieni{wierzcholki};				# Parametr różnica strumieni dla każdego wierzchołka

# Zmienna decyzyjna - Czy dana krawędź jest wykorzystywana w ścieżce, zmienna binarna. 
var uzyta{(i,j) in krawedzie} binary;

# Funkcja celu - Minimalizacja całkowitej odległości. Sumuje ona odległości każdej krawędzi w grafie pomnożone przez zmienną decyzyjną uzyta, która wskazuje, czy dana krawędź jest wykorzystywana w ścieżce.
minimize calkowita_odleglosc: sum{(i,j) in krawedzie} odleglosc[i,j] * uzyta[i,j];

# Ograniczenie - Różnica strumieni dla każdego wierzchołka, Dla każdego wierzchołka, różnica między sumą krawędzi wchodzących do wierzchołka a sumą krawędzi wychodzących z wierzchołka musi być równa parametrowi roznica_strumieni tego wierzchołka.
o_strumieni{i in wierzcholki}: sum{(i,j) in krawedzie} uzyta[i,j] - sum{(j,i) in krawedzie} uzyta[j,i] = roznica_strumieni[i];

data;
set wierzcholki := 'A' 'B' 'C' 'D' 'E';
param roznica_strumieni:= 'A' 1 'B' 0 'C' 0 'D' 0 'E' -1;
param: krawedzie: odleglosc := 	'A','B' 6 'A','C' 9 'B','C' 1 'B','D' 4 'C','D' 1 'C','E' 5 'D','C' 4 'D','E' 2;

solve;
display calkowita_odleglosc, uzyta;
end;