option solver cplex;

reset;

# Parametry
set m;  		# Liczba strategii dla gracza 1
set n;  		# Liczba strategii dla gracza 2
param A{m,n}; 	# Macierz gry

# Zmienne decyzyjne
var p{m} >= 0, <=1;  # Strategie mieszane gracza 1
var t;             	 # Zmienna celu - wypłata

# Funkcja celu
maximize wartosc_gry: t;  # Maksymalizacja wypłaty

# Ograniczenia
gracz2{j in n}: t <= sum{i in m} p[i] * A[i,j];  # Ograniczenie dla gracza 2
prob: sum{i in m} p[i] = 1;                		 # Suma prawdopodobieństw strategii gracza 1 równa się 1

# Dane
data;
set m := "Kamien", "Papier", "Nozyce";
set n := "Kamien", "Papier", "Nozyce";
param A: "Kamien" "Papier" "Nozyce" := "Kamien" 0 -1 1 "Papier" 1 0 -1 "Nozyce" -1 1 0;

solve;

printf "Wartość gry (wypłata): %f\n", wartosc_gry;

printf "Strategie mieszane gracza 1 (p):\n";
for {i in m} {printf "Strategia %d: %f\n", i, p[i];}

printf "Strategie mieszane gracza 2 (q - optymalne rozwiązanie dualne):\n";
for {j in n} {printf "Strategia %d: %f\n", j, p[j];}

# Wynik: 
# Wartość gry (wypłata): 0.000000
# Strategie mieszane gracza 1 (p):
# Strategia 0: 0.333333
# Strategia 0: 0.333333
# Strategia 0: 0.333333
# Strategie mieszane gracza 2 (q - optymalne rozwiązanie dualne):
# Strategia 0: 0.333333
# Strategia 0: 0.333333
# Strategia 0: 0.333333

end;