option solver cplex;
reset;

# Parametry
param pudelka > 0, integer; # Liczba pudełek
param skrzynie > 0, integer; # Maksymalna liczba skrzyń, równa liczbie pudełek
param pojemnosc_skrzyn > 0, integer; # Pojemność skrzyń
param rozmiary_pudelek{p in 1..pudelka}; # Rozmiary poszczególnych pudełek

# Zmienne decyzyjne
# Zmienna binarna określająca, czy pudełko p znajduje się w skrzyni s
var czy_pudelko_w_skrzyni{p in 1..pudelka, s in 1..skrzynie} binary;
# Zmienna binarna określająca, czy skrzynia s została użyta 
var czy_skrzynia_uzyta{s in 1..skrzynie} binary; 

# Funkcja celu - Minimalizacja liczby użytych skrzyń
minimize liczba_skrzynek: sum {s in 1..skrzynie} czy_skrzynia_uzyta[s];

# Ograniczenia
# Każde pudełko musi być zapakowane dokładnie do jednej skrzyni
o_zapakowania_pudelka{p in 1..pudelka}: sum {s in 1..skrzynie} czy_pudelko_w_skrzyni[p,s] = 1; 
# Całkowity rozmiar pudełek w każdej skrzyni nie może przekraczać jej pojemności
o_limitu_pojemnosci{s in 1..skrzynie}: sum {p in 1..pudelka} czy_pudelko_w_skrzyni[p,s] * rozmiary_pudelek[p] <= pojemnosc_skrzyn;	
# Skrzynia jest uznana za używaną, jeśli znajduje się w niej przynajmniej jedno pudełko
o_uzytych_skrzynek{s in 1..skrzynie}: pudelka * czy_skrzynia_uzyta[s] >= sum {p in 1..pudelka} czy_pudelko_w_skrzyni[p,s]; 			

data;
param pudelka := 10;
param skrzynie := 10;
param pojemnosc_skrzyn := 12;
param rozmiary_pudelek:= 1 4 2 5 3 1 4 6 5 8 6 7 7 1 8 2 9 3 10 4;

solve;
display liczba_skrzynek, czy_skrzynia_uzyta;
end;