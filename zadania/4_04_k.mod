option solver cplex;
reset;

# Parametry 
param posterunki > 0, integer; # Liczba posterunków
param dzielnice > 0, integer; # Liczba dzielnic
param czas_podrozy > 0, integer; # Maksymalny czas podróży
param macierz_czasow{1..posterunki, 1..dzielnice}; # Macierz czasów podróży

# Zmienna decyzyjna - Binarna zmienna określająca, czy posterunek i jest obecny w danej dzielnicy.
var czy_posterunek{i in 1..posterunki} binary;  

# Funkcja celu - Minimalizacja liczby posterunków w każdej z dzielnic.
minimize liczba_posterunkow: sum{i in 1..posterunki} czy_posterunek[i];  

# Ograniczenie - Zapewnia, że dla każdego posterunku suma czasów podróży do każdej dzielnicy, spełniających warunek czasu podróży mniejszego lub
# 				 równego maksymalnemu czasowi podróży, musi być większa lub równa 1, jeśli posterunek jest obecny w tej dzielnicy.
o_rozmieszczenie{i in 1..posterunki}: sum{j in 1..dzielnice: macierz_czasow[i,j] <= czas_podrozy} czy_posterunek[j] * macierz_czasow[i,j] >= 1;  

data;
param posterunki:=10;
param dzielnice:=10;
param czas_podrozy:=10;
param macierz_czasow:  1   2   3   4   5   6   7   8   9   10 :=
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
display liczba_posterunkow, czy_posterunek;
end;