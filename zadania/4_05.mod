option solver cplex;
reset;

# Parametry
param p > 0, integer; 			# Liczba pudełek
param pojemnosc_s > 0, integer;	# Pojemność skrzyń
param maks_s > 0, integer; 		# Maksymalna liczba skrzyń, równa liczbie pudełek
param rozmiary_pudelek{1..p}; 	# Rozmiary poszczególnych pudełek

# Zmienne decyzyjne
var czy_pudelko_w_skrzyni{i in 1..p, j in 1..maks_s} binary; 	# Zmienna binarna określająca, czy pudełko i znajduje się w skrzyni j
var czy_skrzynia_uzyta{j in 1..maks_s} binary; 					# Zmienna binarna określająca, czy skrzynia j została użyta

# Funkcja celu - minimalizacja liczby użytych skrzyń
minimize liczba_skrzynek: sum {j in 1..maks_s} czy_skrzynia_uzyta[j];

# Ograniczenia
o_zapakowania_pudelka{i in 1..p}: sum {j in 1..maks_s} czy_pudelko_w_skrzyni[i,j] = 1; 									# Każde pudełko musi być zapakowane dokładnie do jednej skrzyni
o_limitu_pojemnosci{j in 1..maks_s}: sum {i in 1..p} czy_pudelko_w_skrzyni[i,j] * rozmiary_pudelek[i] <= pojemnosc_s;	# Całkowity rozmiar pudełek w każdej skrzyni nie może przekraczać jej pojemności
o_uzytych_skrzynek{j in 1..maks_s}: p * czy_skrzynia_uzyta[j] >= sum {i in 1..p} czy_pudelko_w_skrzyni[i,j]; 			# Skrzynia jest uznana za używaną, jeśli znajduje się w niej przynajmniej jedno pudełko

# Dane
data;
param p := 10;
param maks_s := 10;
param pojemnosc_s := 12;
param rozmiary_pudelek:=  1 4  2 5  3 1  4 6  5 8  6 7  7 1  8 2  9 3  10 4;

solve;
display liczba_skrzynek, czy_skrzynia_uzyta;
# Wynik :liczba_skrzynek = 4
# czy_skrzynia_uzyta
#  1  1
#  2  1
#  3  1
#  4  1

end;