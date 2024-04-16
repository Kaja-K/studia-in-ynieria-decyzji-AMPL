option solver cplex;
reset;

# Parametry
param m; 				# Liczba strategii dla gracza 1
param n; 				# Liczba strategii dla gracza 2
param A{1..m,1..n}; 	# Macierz gry

# Zmienne decyzyjne
var p{1..m} >= 0; 	# Strategie mieszane gracza 1
var t;              # Zmienna celu - wypłata

# Funkcja celu
maximize wartosc_gry: t; # Maksymalizacja wypłaty

# Ograniczenia
gracz2{j in 1..n}: t <= sum{i in 1..m} p[i] * A[i,j];   # Ograniczenie dla gracza 2
prob: sum{i in 1..m} p[i] = 1;                      	# Suma prawdopodobieństw strategii gracza 1 równa się 1

# Dane
data;
param m := 2;
param n := 2;
param A := 1 1 8 1 2 -3 2 1 -15 2 2 10;

solve;

display wartosc_gry, p, gracz2;
# Wynik:
# wartosc_gry = 0.972222
#     p        gracz2
# 1   0.694444   0.361111
# 2   0.305556   0.638889

end;
