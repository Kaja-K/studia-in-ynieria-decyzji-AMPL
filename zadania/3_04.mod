# A
option solver cplex;
reset;

# Parametry
param strategie_g1; # Liczba strategii dla gracza 1
param strategie_g2; # Liczba strategii dla gracza 2
param wyplata{s1 in 1..strategie_g1, s2 in 1..strategie_g2}; # Macierz wypłat w grze

# Zmienne decyzyjne
# Prawdopodobieństwa strategii gracza 1
var prawdopodobienstwa_strategii{s1 in 1..strategie_g1} >= 0; 
# Wypłata gracza 2	
var wyplata_g2; 

# Funkcja celu - Maksymalizacja wypłaty gracza 2.
maximize maksymalizacja_wyplaty: wyplata_g2;

# Ograniczenia
# Wypłata gracza 2 musi być mniejsza lub równa sumie prawdopodobieństw strategii gracza 1 pomnożonych przez wypłatę gracza 2 dla każdej strategii gracza 2.
o_gracz2{s2 in 1..strategie_g2}: wyplata_g2 <= sum{s1 in 1..strategie_g1} prawdopodobienstwa_strategii[s1] * wyplata[s1, s2]; 
# Suma prawdopodobieństw strategii gracza 1 musi być równa 1.
o_prawdopodobienstw: sum{s1 in 1..strategie_g1} prawdopodobienstwa_strategii[s1] = 1;

data;
param strategie_g1 := 2;
param strategie_g2 := 2;
param wyplata := 1 1 8 1 2 -3 2 1 -15 2 2 10;

solve;
display maksymalizacja_wyplaty, prawdopodobienstwa_strategii;


# B
option solver cplex;
reset;

# Parametry
set strategie_nieparzystego; # Zbiór strategii dla gracza Nieparzysty
set strategie_parzystego; # Zbiór strategii dla gracza Parzysty
param wyplata{n in strategie_nieparzystego, p in strategie_parzystego}; # Macierz wypłat w grze

# Zmienne decyzyjne - Prawdopodobieństwa strategii gracza Nieparzysty
var prawdopod_strategii_niep{n in strategie_nieparzystego} >= 0, <= 1;  
var wyplata_parzystego; 

# Funkcja celu - Maksymalizacja wypłaty gracza Parzysty.
maximize wartosc_gry: wyplata_parzystego;

# Ograniczenia
# Wypłata gracza Parzysty musi być mniejsza lub równa sumie prawdopodobieństw strategii gracza Nieparzysty pomnożonych przez wypłatę gracza Parzysty dla każdej strategii gracza Parzysty.
o_gracz_parzysty{p in strategie_parzystego}:  wyplata_parzystego <= sum{n in strategie_nieparzystego} prawdopod_strategii_niep[n] * wyplata[n, p]; 
# Suma prawdopodobieństw strategii gracza Nieparzysty musi być równa 1.
o_prawdopodobienstw: sum{n in strategie_nieparzystego} prawdopod_strategii_niep[n] = 1; 

data;
set strategie_nieparzystego := 1, 2;
set strategie_parzystego := 1, 2;
param wyplata: 1 2 := 1 1 -2 2 2 -1;

solve;
display wartosc_gry, wyplata_parzystego, prawdopod_strategii_niep;
end;