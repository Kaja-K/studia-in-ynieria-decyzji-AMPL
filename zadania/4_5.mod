option solver cplex;
reset;

# Parametry
param n > 0, integer; # Liczba pudełek
param C > 0, integer; # Pojemność skrzyń
param m > 0, integer; # Maksymalna liczba skrzyń, równa liczbie pudełek
param a {1..n}; 	  # Rozmiary poszczególnych pudełek

# Zmienne decyzyjne
var x {1..n, 1..m} binary; 	# Zmienna binarna określająca, czy pudełko i znajduje się w skrzyni j
var y {1..m} binary; 		# Zmienna binarna określająca, czy skrzynia j została użyta

# Funkcja celu - minimalizacja liczby użytych skrzyń
minimize Liczba_skrzyn: sum {j in 1..m} y[j];

# Ograniczenia
Zapakowanie_pudelka {i in 1..n}: sum {j in 1..m} x[i,j] = 1; 		# Każde pudełko musi być zapakowane dokładnie do jednej skrzyni
Limit_pojemnosci {j in 1..m}: sum {i in 1..n} x[i,j] * a[i] <= C; 	# Całkowity rozmiar pudełek w każdej skrzyni nie może przekraczać jej pojemności
Uzyte_skrzynie {j in 1..m}: n * y[j] >= sum {i in 1..n} x[i,j]; 	# Skrzynia jest uznana za używaną, jeśli znajduje się w niej przynajmniej jedno pudełko


# Dane
data;
param n := 10;
param m := 10;
param C := 12;
param a :=  1 4  2 5  3 1  4 6 5 8  6 7  7 1  8 2 9 3  10 4;

solve;
display Liczba_skrzyn, x, y;
# Wynik:  Liczba_skrzyn = 4

end;
