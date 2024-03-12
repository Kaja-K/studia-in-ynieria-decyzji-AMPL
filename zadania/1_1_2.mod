option solver cplex;
reset;

# Zdefiniowanie parametrów
param n>0 integer;
param p{1..n};
param d{1..n};
param h{1..n};
param h_limit;


# Definicja zmiennych decyzyjnych
var x{i in 1..n} >=0, <= d[i];

# Funkcja celu do zmaksymalizowania zysku
maximize Profit: sum{i in 1..n} p[i]*x[i];

# Ograniczenia - Dostępne godziny robocze
subject to Labor_Hours: sum{i in 1..n}  h[i]*x[i] <= h_limit;


# Przypisanie wartości parametrów
data;
param n := 2;
param p := [1] 120 [2] 80;
param d := [1] 20 [2] 40;
param h := [1] 20 [2] 10;
param h_limit := 500;

solve;

display x, Profit; 
# Wynik: 1 = 5, 2 = 40, Profit = 3800

end;

