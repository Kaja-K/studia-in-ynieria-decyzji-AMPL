option solver cplex;
reset;

# Parametry
param n > 0, integer;       # Liczba stopów
param koszt{1..n};          # Koszt za tonę każdego stopu
param C{1..n};              # Zawartość pierwiastka C w każdym stopie
param Si{1..n};             # Zawartość pierwiastka Si w każdym stopie
param Mn{1..n};             # Zawartość pierwiastka Mn w każdym stopie
param P{1..n};              # Zawartość pierwiastka P w każdym stopie
param mix_limit;            # Limit mieszanki (w tonach)
param C_limit;              # Limit zawartości pierwiastka C w mieszance (procent)
param Si_limit;             # Limit zawartości pierwiastka Si w mieszance (procent)
param Mn_limit;             # Minimalna zawartość pierwiastka Mn w mieszance (procent)
param P_limit;              # Minimalna zawartość pierwiastka P w mieszance (procent)

# Zmienna decyzyjna - Ilość ton każdego stopu użytego w mieszance
var ilosc_ton{i in 1..n} >= 0;

# Funkcja celu - minimalizacja kosztów mieszanki
minimize koszty: sum{i in 1..n} koszt[i] * ilosc_ton[i];

# Ograniczenia
o_C: sum{i in 1..n} ilosc_ton[i] * C[i] <= C_limit * mix_limit; 	# Zawartość pierwiastka C w mieszance
o_Si: sum{i in 1..n} ilosc_ton[i] * Si[i] <= Si_limit * mix_limit;  # Zawartość pierwiastka Si w mieszance
o_Mn: sum{i in 1..n} ilosc_ton[i] * Mn[i] >= Mn_limit * mix_limit;  # Zawartość pierwiastka Mn w mieszance
o_P: sum{i in 1..n} ilosc_ton[i] * P[i] >= P_limit * mix_limit; 	# Minimalna zawartość pierwiastka P w mieszance
o_Mix: sum{i in 1..n} ilosc_ton[i] = mix_limit; 					# Ilość ton mieszanki musi być równa określonemu limitowi

data;
param n := 3;
param koszt := 1 200 2 150 3 400;
param C := 1 0.28 2 0.14 3 0.1;
param Si := 1 0.1 2 0.12 3 0.06;
param Mn := 1 0.3 2 0.2 3 0.3;
param P := 1 0.1 2 0.1 3 0.15;
param mix_limit := 5000;
param C_limit := 0.14;
param Si_limit := 0.08;
param Mn_limit := 0.25;
param P_limit := 0.12;

solve;
display koszty, ilosc_ton;
# Wynik: koszty = 1554350
# ilosc_ton
# 1   869.565
# 2  1086.96
# 3  3043.48

end;