option solver cplex; 
reset;

# Parametry
param n ; 							# Liczba działów
param min_liczba_pracownikow{1..n}; # Minimalna liczba dla każdego działu

# Zmienna decyzyjna - Liczba pracownikow do zatrudnienia w każdym z działów
var liczba_do_zatrudnienia{i in 1..n} >= 0, integer;

# Funkcja celu -  Minimalizacja sumy liczby pracownikow zatrudnionych w każdym z działów
minimize liczba_pracownikow: sum{i in 1..n} liczba_do_zatrudnienia[i];

# Ograniczenie - Każdy dział musi mieć odpowiednią liczbę pracownikow, zakładając cykliczność
o_odpowiednia_liczba_pracownikow{i in 1..n}: min_liczba_pracownikow[i] <= liczba_do_zatrudnienia[i] + sum{j in (i+3)..(i+6)} 
											if j > 7 then liczba_do_zatrudnienia[j - 7] else liczba_do_zatrudnienia[j];
data;
param n := 7;
param: min_liczba_pracownikow := [1] 17 [2] 13 [3] 15 [4] 19 [5] 14 [6] 16 [7] 11;

solve; 
display liczba_pracownikow, liczba_do_zatrudnienia;
# Wynik: liczba_pracownikow = 23
# liczba_do_zatrudnienia
# 	1  6
# 	2  4
# 	3  1
# 	4  8
# 	5  0
# 	6  4
# 	7  0

end;