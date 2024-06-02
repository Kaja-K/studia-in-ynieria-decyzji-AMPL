option solver cplex;
reset;

# Parametry
set strategie_g1;  							# Zbiór strategii dla gracza 1
set strategie_g2;  							# Zbiór strategii dla gracza 2
param wypłaty{strategie_g1, strategie_g2};	# Macierz wypłat w grze

# Zmienne decyzyjne
var strategie_mieszane_g1{strategie_g1} >= 0, <=1;	# Prawdopodobieństwa strategii mieszanych gracza 1
var wygrana_g1;										# Wypłata gracza 1

# Funkcja celu - Maksymalizacja wypłaty gracza 1
maximize maks_wygrana: wygrana_g1;

# Ograniczenia
o_gracza2{j in strategie_g2}: wygrana_g1 <= sum{i in strategie_g1} strategie_mieszane_g1[i] * wypłaty[i,j]; # Określa, że wypłata gracza 1 musi być mniejsza lub równa sumie prawdopodobieństw strategii gracza 1 pomnożonych przez wypłatę gracza 2 dla każdej strategii gracza 2.
o_prawdopodobienstw: sum{i in strategie_g1} strategie_mieszane_g1[i] = 1; 									# Określa, że suma prawdopodobieństw strategii gracza 1 musi być równa 1, aby były one prawidłowymi prawdopodobieństwami.

data;
set strategie_g1 := "Kamień", "Papier", "Nożyce";
set strategie_g2 := "Kamień", "Papier", "Nożyce";
param wypłaty: 		"Kamień" "Papier" "Nożyce" := 	"Kamień" 0 -1 1 
													"Papier" 1 0 -1 
													"Nożyce" -1 1 0;
solve;
display maks_wygrana, wygrana_g1, strategie_mieszane_g1;
end;
