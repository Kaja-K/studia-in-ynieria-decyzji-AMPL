option solver cplex;
reset;

# Model dla gracza 1

# Deklaracje
set GRA; # Zbiór możliwych ruchów
param wypłata {GRA, GRA}; # Tablica wypłat

var x {GRA} >= 0, <= 1; # Strategie dla gracza 1
var y {GRA} >= 0, <= 1; # Strategie dla gracza 2

# Cel dla gracza 1
maximize z: sum {i in GRA, j in GRA} wypłata[i,j] * x[i] * y[j];

minimize z2: sum {i in GRA, j in GRA} -wypłata[i,j] * x[i] * y[j];

# Ograniczenia
subject to SumaStrategiiGracza1: sum {i in GRA} x[i] = 1;
subject to SumaStrategiiGracza2: sum {j in GRA} y[j] = 1;

# Dane dla modelu
data;

set GRA := kamien papier nozyce;

param wypłata :  kamien papier nozyce :=
kamien   0 -1  1
papier   1  0 -1
nozyce  -1  1  0;

# Rozwiązanie
solve;

# Wyświetlanie wyników
printf "Gracz 1  = %f\n", z;
printf "Optymalne strategie dla gracza 1:\n";
for {i in GRA} {
 if x[i] > 0 then printf "%s: %f\n", i, x[i];
}

printf "Gracz 2  = %f\n", z2;
printf "Optymalne strategie dla gracza 2 (jako model dualny):\n";
for {j in GRA} {
 if y[j] > 0 then printf "%s: %f\n", j, y[j];
}
