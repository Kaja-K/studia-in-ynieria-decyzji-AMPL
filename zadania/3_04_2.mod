option solver cplex;
reset;

# Model dla gry Nieparzysty vs Parzysty
var Nieparzysty {1,2} >= 0; # Wybór gracza Nieparzystego
var Parzysty {1,2} >= 0; # Wybór gracza Parzystego

# Funkcja celu
minimize Wynik_Nieparzysty: Nieparzysty;

# Ograniczenia
subject to Suma_Liczb: Nieparzysty + Parzysty = 3; # Suma liczb musi być nieparzysta

# Rozwiązanie
solve;

# Wyświetlanie wyników
printf "Wynik gry dla gracza Nieparzysty: %f\n", Wynik_Nieparzysty.sol;
printf "Optymalne strategie dla gracza Nieparzysty: %f\n", Nieparzysty.sol;
