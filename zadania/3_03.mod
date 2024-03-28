option solver cplex;
reset;

param wyplaty {1..3, 1..3};  # Deklaracja parametru

# Zmienne decyzyjne
var strategia_gracza_1 {1..3} >= 0; # Strategie gracza 1: kamień, papier, nożyce
var strategia_gracza_2 {1..3} >= 0; # Strategie gracza 2: kamień, papier, nożyce

# Funkcja celu - maksymalizacja oczekiwanej wartości dla gracza 1
maximize wartosc_oczekiwana: sum{i in 1..3, j in 1..3} wyplaty[i,j] * strategia_gracza_1[i] * strategia_gracza_2[j];

# Ograniczenia - każdy gracz wybiera dokładnie jedną strategię
o_s1: sum{i in 1..3} strategia_gracza_1[i] = 1;
o_s2: sum{j in 1..3} strategia_gracza_2[j] = 1;

# Dane
data;
param wyplaty := 1 1 0 -1 2 0 1 -1 3 -1 1 0;
    
solve;

display strategia_gracza_1, strategia_gracza_2, wartosc_oczekiwana;
