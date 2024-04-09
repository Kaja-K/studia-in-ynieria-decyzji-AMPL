option solver cplex;
reset;

# Parametry
set m;  		# Liczba strategii dla gracza Nieparzysty
set n;  		# Liczba strategii dla gracza Parzysty
param A{m,n};  	# Macierz gry

# Zmienne decyzyjne
var p{m} >= 0, <=1;  # Strategie mieszane gracza Nieparzysty
var t;               # Zmienna celu - wypłata

# Funkcja celu
maximize wartosc_gry: t;  # Maksymalizacja wypłaty

# Ograniczenia
gracz2{j in n}: t <= sum{i in m} p[i] * A[i,j];  # Ograniczenie dla gracza Parzysty
prob: sum{i in m} p[i] = 1;                      # Suma prawdopodobieństw strategii gracza Nieparzysty równa się 1

# Dane
data;
set m := 1, 2;
set n := 1, 2;
param A: 1 2 :=
1 1 -2
2 2 -1;

solve;

printf "Wartość gry (wypłata): %f\n", wartosc_gry;

printf "Strategie mieszane gracza Nieparzysty (p):\n";
for {i in m} {printf "Strategia %d: %f\n", i, p[i];}

printf "Strategie mieszane gracza Parzysty (q - optymalne rozwiązanie dualne):\n";
for {j in n} {printf "Strategia %d: %f\n", j, p[j];}

# Wynik:
# Wartość gry (wypłata): -1.000000
# Strategie mieszane gracza Nieparzysty (p):
# Strategia 1: 0.000000
# Strategia 2: 1.000000
# Strategie mieszane gracza Parzysty (q - optymalne rozwiązanie dualne):
# Strategia 1: 0.000000
# Strategia 2: 1.000000

end;
