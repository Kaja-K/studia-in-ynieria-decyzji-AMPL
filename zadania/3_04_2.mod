option solver cplex;
reset;

# Parametry
set strategie_nieparzystego;  									# Zbiór strategii dla gracza Nieparzysty
set strategie_parzystego;  										# Zbiór strategii dla gracza Parzysty
param wyplata{strategie_nieparzystego, strategie_parzystego}; 	# Macierz wypłat w grze

# Zmienne decyzyjne - Prawdopodobieństwa strategii gracza Nieparzysty
var prawdopod_strategii_niep{strategie_nieparzystego} >= 0, <= 1;  
var wyplata_parzystego; 

# Funkcja celu
maximize wartosc_gry: wyplata_parzystego;  # Maksymalizacja wypłaty

# Ograniczenia
o_gracz_parzysty{j in strategie_parzystego}:  wyplata_parzystego <= sum{i in strategie_nieparzystego} prawdopod_strategii_niep[i] * wyplata[i,j];
o_prawdopodobienstw: sum{i in strategie_nieparzystego} prawdopod_strategii_niep[i] = 1;  # Suma prawdopodobieństw strategii gracza Nieparzysty równa się 1

data;
set strategie_nieparzystego := 1, 2;
set strategie_parzystego := 1, 2;
param wyplata: 1 2 := 1 1 -2 2 2 -1;

solve;
display wartosc_gry,wyplata_parzystego, prawdopod_strategii_niep;
# Wynik:wartosc_gry = -1
# wyplata_parzystego = -1
# prawdopod_strategii_niep 
# 1  0
# 2  1

end;