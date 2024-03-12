option solver cplex;
reset;

# Zdefiniowanie parametrów
param n>0, integer;
param k{1..n};
param C{1..n};
param Si{1..n};
param Mn{1..n};
param P{1..n};
param mix_limit;
param C_limit;
param Si_limit;
param Mn_limit;
param P_limit;

# Definicja zmiennych decyzyjnych
var x{i in 1..n} >= 0;

# Funkcja celu do zmaksymalizowania zysku
minimize Profit: sum{i in 1..n}k[i]*x[i];

# Ograniczenia
subject to
C_contents: sum{i in 1..n}x[i]*C[i] <= C_limit*mix_limit;
Si_contents: sum{i in 1..n}x[i]*Si[i] <= Si_limit*mix_limit;
Mn_contents: sum{i in 1..n}x[i]*Mn[i] >= Mn_limit*mix_limit;
P_contents: sum{i in 1..n}x[i]*P[i] >= P_limit*mix_limit;
Mix: sum{i in 1..n}x[i] = mix_limit;

# Przypisanie wartości parametrów
data;
param n:=3;
param k:= [1] 200 [2] 150 [3] 400;
param C:= [1] 0.28 [2] 0.14 [3] 0.1;
param Si:= [1] 0.1 [2] 0.12 [3] 0.06;
param Mn:= [1] 0.3 [2] 0.2 [3] 0.3;
param P:= [1] 0.1 [2] 0.1 [3] 0.15;
param mix_limit:=5000;
param C_limit:=0.14;
param Si_limit:=0.08;
param Mn_limit:=0.25;
param P_limit:=0.12;


solve;

display x,Profit;
# Wynik: 1 = 869.565, 2 = 1086.96, 3 = 3043.48, Profit = 1554350

end;



