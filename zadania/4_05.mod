option solver cplex;
reset;

# Parametry
param pudelka > 0, integer; 		# Liczba pudełek
param skrzynie > 0, integer; 		# Maksymalna liczba skrzyń, równa liczbie pudełek
param pojemnosc_skrzyn > 0, integer;# Pojemność skrzyń
param rozmiary_pudelek{1..pudelka}; # Rozmiary poszczególnych pudełek

# Zmienne decyzyjne
var czy_pudelko_w_skrzyni{i in 1..pudelka, j in 1..skrzynie} binary; # Zmienna binarna określająca, czy pudełko i znajduje się w skrzyni j
var czy_skrzynia_uzyta{j in 1..skrzynie} binary; 					 # Zmienna binarna określająca, czy skrzynia j została użyta

# Funkcja celu - Minimalizacja liczby użytych skrzyń
minimize liczba_skrzynek: sum {j in 1..skrzynie} czy_skrzynia_uzyta[j];

# Ograniczenia
o_zapakowania_pudelka{i in 1..pudelka}: sum {j in 1..skrzynie} czy_pudelko_w_skrzyni[i,j] = 1; 										# Każde pudełko musi być zapakowane dokładnie do jednej skrzyni
o_limitu_pojemnosci{j in 1..skrzynie}: sum {i in 1..pudelka} czy_pudelko_w_skrzyni[i,j] * rozmiary_pudelek[i] <= pojemnosc_skrzyn;	# Całkowity rozmiar pudełek w każdej skrzyni nie może przekraczać jej pojemności
o_uzytych_skrzynek{j in 1..skrzynie}: pudelka * czy_skrzynia_uzyta[j] >= sum {i in 1..pudelka} czy_pudelko_w_skrzyni[i,j]; 			# Skrzynia jest uznana za używaną, jeśli znajduje się w niej przynajmniej jedno pudełko

data;
param pudelka := 10;
param skrzynie := 10;
param pojemnosc_skrzyn := 12;
param rozmiary_pudelek:=  1 4  2 5  3 1  4 6  5 8  6 7  7 1  8 2  9 3  10 4;

solve;
display liczba_skrzynek, czy_skrzynia_uzyta;
end;