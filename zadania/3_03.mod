option solver cplex;
option cplex_options 'sensitivity';  # Opcje CPLEX

reset;

# Parametry
param m;  # Liczba strategii dla gracza 1
param n;  # Liczba strategii dla gracza 2
param A;

# Zmienne decyzyjne
var p{1..m} >= 0;  # Strategie mieszane gracza 1
var t;             # Zmienna celu - wypłata

# Funkcja celu
maximize payoff: t;  # Maksymalizacja wypłaty

# Ograniczenia
q{j in 1..n}: t <= sum{i in 1..m} p[i] * A[i,j];  # Ograniczenie dla gracza 2
c1: sum{i in 1..m} p[i] = 1;                      # Suma prawdopodobieństw strategii gracza 1 równa się 1

# Dostarczenie danych
data;

param m := 3;  # Liczba strategii dla gracza 1 (kamień, papier, nożyce)
param n := 3;  # Liczba strategii dla gracza 2 (kamień, papier, nożyce)
param A : 1 2 3 := 1 0 -1 1 2 1 0 -1 s3 -1 1 0;

# Rozwiązanie modelu i wyświetlenie wyników
solve;

printf "Wartość gry (wypłata): %f\n", payoff;
printf "Strategie mieszane gracza 1 (p):\n";
for {i in 1..m} {
    printf "Strategia %d: %f\n", i, p[i];
}

printf "Strategie mieszane gracza 2 (q - optymalne rozwiązanie dualne):\n";
for {j in 1..n} {
    printf "Strategia %d: %f\n", j, q[j];
}

end;