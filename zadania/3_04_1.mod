option solver cplex;
reset;

# Model dla gry z kartami
var A1 binary; # Gracz 1 wybiera czarny As
var R1 binary; # Gracz 1 wybiera czerwoną ósemkę
var A2 binary; # Gracz 2 wybiera czerwoną dwójkę
var R2 binary; # Gracz 2 wybiera czarną siódemkę

# Funkcja celu
maximize Wynik_Gracza_1: 1*A1 + 8*R1 - 2*A2 - 7*R2;

# Ograniczenia
subject to Wybory_Graczy_1: A1 + R1 = 1;
subject to Wybory_Graczy_2: A2 + R2 = 1;

# Rozwiązanie
solve;

# Wyświetlanie wyników
printf "Wynik gry dla gracza 1: %f\n", Wynik_Gracza_1.sol;
printf "Optymalne strategie dla gracza 1:\n";
printf "Czarny As: %f, Czerwoną ósemkę: %f\n", A1.sol, R1.sol;
printf "Czerwoną dwójkę: %f, Czarną siódemkę: %f\n", A2.sol, R2.sol;