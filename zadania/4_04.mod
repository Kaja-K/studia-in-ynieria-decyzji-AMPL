option solver cplex;
reset;

# Parametry 
param p > 0, integer;  				# Liczba posterunków
param d > 0, integer;  				# Liczba dzielnic
param czas_podrozy > 0, integer;  	# Czas podróży
param macierz_czasow{1..p, 1..d};	# Macierz czasów podróży

# Zmienna decyzyjna - Czy posterunek jest w dzielnicy i
var czy_posterunek{i in 1..p} binary;  

# Funkcja celu - Minimalizacja liczby posterunków w każdej z dzielnic
minimize posterunki: sum{i in 1..p} czy_posterunek[i];  

# Ograniczenie
o_rozmieszczenie{i in 1..p}: sum{j in 1..d: macierz_czasow[i,j] <= czas_podrozy} czy_posterunek[j] * macierz_czasow[i,j] >= 1;  

data;
param p:=10;
param d:=10;
param czas_podrozy:=10;
param macierz_czasow: 
					    1   2   3   4   5   6   7   8   9   10 :=
					1   0  10  20  30  30  20  30  18  12  20
					2  10   0  25  35  20  10   9  12  18  10
					3  20  25   0  15  30  20  10  20  30  19
					4  30  35  15   0  15  25  30   5  20  12
					5  30  20  30  15   0  14  20  20  10  10
					6  20  10  20  25  14   0   8  15  20  15
					7  30   9  10  30  20   8   0  12  30  25
					8  18  12  20   5  20  15  12   0  16  25
					9  12  18  30  20  10  20  30  16   0   6
					10 20  10  19  12  10  15  25  25   6   0;

solve;
display posterunki, czy_posterunek;
# Wynik: posterunki = 5
# czy_posterunek
#  2  1
#  4  1
#  7  1
#  8  1
# 10  1

end;