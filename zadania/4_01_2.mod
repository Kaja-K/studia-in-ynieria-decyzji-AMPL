option solver cplex; 
reset;

# Parametry
param n = 7; # Liczba działów
param min_liczba_pracowników{1..n}; # Minimalna liczba dla każdego działu

# Zmienna decyzyjna: liczba pracowników do zatrudnienia w każdym z działów
var liczba_do_zatrudnienia{i in 1..n} >= 0, integer;

# Funkcja celu: minimalizacja sumy liczby pracowników zatrudnionych w każdym z działów
minimize liczba_pracowników: sum{i in 1..n} liczba_do_zatrudnienia[i];

# Ograniczenie: każdy dział musi mieć odpowiednią liczbę pracowników, zakładając cykliczność
o_odpowiednia_liczba_pracowników{i in 1..n}: min_liczba_pracowników[i] <= liczba_do_zatrudnienia[i] + 
    sum{j in (i+3)..(i+6)} if j > 7 then liczba_do_zatrudnienia[j - 7] else liczba_do_zatrudnienia[j];

# Dane
data;
param: min_liczba_pracowników := [1] 17 [2] 13 [3] 15 [4] 19 [5] 14 [6] 16 [7] 11;

solve; 
display liczba_pracowników, liczba_do_zatrudnienia;
# Wynik: Zatrudnieni = 23
# liczba_zatrudnionych_pracownikow
# 	1  6
# 	2  4
# 	3  1
# 	4  8
# 	5  0
# 	6  4
# 	7  0

end; 
