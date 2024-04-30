option solver cplex;
reset;

# Parametry 
param czas_podrozy > 0, integer;  								# Czas podróży
param liczba_posterunkow > 0, integer;  						# Liczba posterunków
param liczba_dzielnic > 0, integer;  							# Liczba dzielnic
param macierz_czasow{1..liczba_posterunkow, 1..liczba_dzielnic};# Macierz czasów podróży

# Zmienna decyzyjna - Czy posterunek jest w dzielnicy i
var czy_posterunek_w_dzielnicy{i in 1..liczba_posterunkow} binary;  

# Funkcja celu - Minimalizacja liczby posterunków
minimize posterunki: sum{i in 1..liczba_posterunkow} czy_posterunek_w_dzielnicy[i];  

# Ograniczenie
o_rozmieszczenie{i in 1..liczba_posterunkow}: sum{j in 1..liczba_dzielnic: macierz_czasow[i,j] <= czas_podrozy} czy_posterunek_w_dzielnicy[j] * macierz_czasow[i,j] >= 1;  

# Dane  
data;
param czas_podrozy:=10;
param liczba_posterunkow:=10;
param liczba_dzielnic:=10;
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
display czy_posterunek_w_dzielnicy, posterunki;
# Wynik: posterunki = 5
# czy_posterunek_w_dzielnicy
#  1  0
#  2  1
#  3  0
#  4  1
#  5  0
#  6  0
#  7  1
#  8  1
#  9  0
# 10  1

end;