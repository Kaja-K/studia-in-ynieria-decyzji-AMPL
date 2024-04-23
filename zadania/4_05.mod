option solver cplex;
reset;

# Parametry
param liczba_pudelek > 0, integer; 				# Liczba pudełek
param pojemnosc_skrzynki > 0, integer;	 		# Pojemność skrzyń
param maksymalna_liczba_skrzynek > 0, integer; 	# Maksymalna liczba skrzyń, równa liczbie pudełek
param rozmiary_pudelek{1..liczba_pudelek}; 		# Rozmiary poszczególnych pudełek

# Zmienne decyzyjne
var czy_pudelko_w_skrzyni{i in 1..liczba_pudelek, j in 1..maksymalna_liczba_skrzynek} binary; 	# Zmienna binarna określająca, czy pudełko i znajduje się w skrzyni j
var czy_skrzynia_uzyta{j in 1..maksymalna_liczba_skrzynek} binary; 								# Zmienna binarna określająca, czy skrzynia j została użyta

# Funkcja celu - minimalizacja liczby użytych skrzyń
minimize liczba_skrzynek: sum {j in 1..maksymalna_liczba_skrzynek} czy_skrzynia_uzyta[j];

# Ograniczenia
o_zapakowania_pudelka{i in 1..liczba_pudelek}: sum {j in 1..maksymalna_liczba_skrzynek} czy_pudelko_w_skrzyni[i,j] = 1; 									# Każde pudełko musi być zapakowane dokładnie do jednej skrzyni
o_limit_pojemnosci{j in 1..maksymalna_liczba_skrzynek}: sum {i in 1..liczba_pudelek} czy_pudelko_w_skrzyni[i,j] * rozmiary_pudelek[i] <= pojemnosc_skrzynki;# Całkowity rozmiar pudełek w każdej skrzyni nie może przekraczać jej pojemności
o_uzytych_skrzynek{j in 1..maksymalna_liczba_skrzynek}: liczba_pudelek * czy_skrzynia_uzyta[j] >= sum {i in 1..liczba_pudelek} czy_pudelko_w_skrzyni[i,j]; 	# Skrzynia jest uznana za używaną, jeśli znajduje się w niej przynajmniej jedno pudełko

# Dane
data;
param liczba_pudelek := 10;
param maksymalna_liczba_skrzynek := 10;
param pojemnosc_skrzynki := 12;
param rozmiary_pudelek:=  1 4  2 5  3 1  4 6  5 8  6 7  7 1  8 2  9 3  10 4;

solve;
display liczba_skrzynek, czy_pudelko_w_skrzyni, czy_skrzynia_uzyta;
# Wynik :liczba_skrzynek = 4
# czy_pudelko_w_skrzyni
#      1   2   3   4   5   6   7   8   9  10 
# 1    1   0   0   0   0   0   0   0   0   0
# 2    1   0   0   0   0   0   0   0   0   0
# 3    1   0   0   0   0   0   0   0   0   0
# 4    0   1   0   0   0   0   0   0   0   0
# 5    0   0   1   0   0   0   0   0   0   0
# 6    0   0   0   1   0   0   0   0   0   0
# 7    1   0   0   0   0   0   0   0   0   0
# 8    0   1   0   0   0   0   0   0   0   0
# 9    0   1   0   0   0   0   0   0   0   0
# 10   0   0   1   0   0   0   0   0   0   0

# czy_skrzynia_uzyta
#  1  1
#  2  1
#  3  1
#  4  1
#  5  0
#  6  0
#  7  0
#  8  0
#  9  0
# 10  0

end;