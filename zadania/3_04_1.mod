option solver cplex;
reset;

# Parametry
param strategie_gracza1; 									# Liczba strategii dla gracza 1
param strategie_gracza2; 									# Liczba strategii dla gracza 2
param wyplata{1..strategie_gracza1, 1..strategie_gracza2}; 	# Macierz wypłat w grze

# Zmienne decyzyjne - Prawdopodobieństwa strategii gracza 1
var prawdopodobienstwa_strategii{1..strategie_gracza1} >= 0;
var wyplata_gracza2;             					

# Funkcja celu
maximize maksymalizacja_wypłaty: wyplata_gracza2; # Maksymalizacja wypłaty

# Ograniczenia
o_gracz2{j in 1..strategie_gracza2}: wyplata_gracza2 <= sum{i in 1..strategie_gracza1} prawdopodobienstwa_strategii[i] * wyplata[i,j];
o_prawdopodobienstw: sum{i in 1..strategie_gracza1} prawdopodobienstwa_strategii[i] = 1;  # Suma prawdopodobieństw strategii gracza 1 równa się 1

data;
param strategie_gracza1 := 2;
param strategie_gracza2 := 2;
param wyplata := 1 1 8 1 2 -3 2 1 -15 2 2 10;

solve;
display maksymalizacja_wypłaty, prawdopodobienstwa_strategii;
# Wynik: maksymalizacja_wypłaty = 0.972222
# prawdopodobienstwa_strategii 
# 1  0.694444
# 2  0.305556

end;