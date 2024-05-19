option solver cplex;
reset;

# Parametry
set Strategie_Gracza1;  							# Zbiór strategii dla gracza 1
set Strategie_Gracza2;  							# Zbiór strategii dla gracza 2
param wyplata{Strategie_Gracza1, Strategie_Gracza2};# Macierz wypłat w grze

# Zmienne decyzyjne - Prawdopodobieństwa strategii mieszanych gracza 1
var StrategieMieszaneGracza1{Strategie_Gracza1} >= 0, <=1;
var wyplata_gracza1;

# Funkcja celu - Maksymalizacja wypłaty
maximize maks_wyplata: wyplata_gracza1;

# Ograniczenia
o_gracza2{j in Strategie_Gracza2}: wyplata_gracza1 <= sum{i in Strategie_Gracza1} StrategieMieszaneGracza1[i] * wyplata[i,j];
o_prawdopodobieństw: sum{i in Strategie_Gracza1} StrategieMieszaneGracza1[i] = 1; # Suma prawdopodobieństw strategii gracza 1 równa się 1

data;
set Strategie_Gracza1 := "Kamień", "Papier", "Nożyce";
set Strategie_Gracza2 := "Kamień", "Papier", "Nożyce";
param wyplata: "Kamień" "Papier" "Nożyce" := "Kamień" 0 -1 1 "Papier" 1 0 -1 "Nożyce" -1 1 0;

solve;
display maks_wyplata, wyplata_gracza1, StrategieMieszaneGracza1;
# Wynik: maks_wyplata = 0
# wyplata_gracza1 = 0
# StrategieMieszaneGracza1 
# Kamień  0.333333
# Nożyce  0.333333
# Papier  0.333333

end;