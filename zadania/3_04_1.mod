option solver cplex;
reset;

# Parametry
set m; 			# Liczba strategii dla gracza 1
set n; 			# Liczba strategii dla gracza 2
param A{m,n}; 	# Macierz gry

# Zmienne decyzyjne
var p{m} >= 0, <=1; 	# Strategie mieszane gracza 1
var t;               	# Zmienna celu - wypłata

# Funkcja celu
maximize wartosc_gry: t; # Maksymalizacja wypłaty

# Ograniczenia
gracz2{j in n}: t <= sum{i in m} p[i] * A[i,j];  # Ograniczenie dla gracza 2
prob: sum{i in m} p[i] = 1;                      # Suma prawdopodobieństw strategii gracza 1 równa się 1

# Dane
data;
set m := "As", "Osemka";
set n := "Dwojka", "Siodemka";
param A : "As" "Osemka" "Dwojka" "Siodemka" := 
    "As" "As" 1 -1,
    "Osemka" "As" -1 1,
    "As" "Dwojka" 1 -1,
    "Osemka" "Dwojka" 1 -1;

solve;

printf "Wartość gry (wypłata): %f\n", wartosc_gry;

printf "Strategie mieszane gracza 1 (p):\n";
for {i in m} {printf "Strategia %s: %f\n", i, p[i];}

printf "Strategie mieszane gracza 2 (q - optymalne rozwiązanie dualne):\n";
for {j in n} {printf "Strategia %s: %f\n", j, p[j];}

end;
