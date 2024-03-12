option solver cplex;
reset;

# Zdefiniowanie parametrów
param n>0 integer;
param c{1..n};
param w{1..n};
param h{1..n};
param p{1..n};
param f_limit;
param h_limit;


# Definicja zmiennych decyzyjnych
var x{i in 1..n} >=0, <= p[i]/w[i];

# Funkcja celu do zmaksymalizowania zysku
maximize Profit: sum{i in 1..n} c[i]*w[i]*x[i] - sum{i in 1..n} h[i]*w[i]*x[i];

# Ograniczenia - Dostępne godziny robocze oraz ziemia
subject to 
Field: sum {i in 1..n} x[i] <= f_limit;
Labor_Hours: sum{i in 1..n} x[i]*h[i] <= h_limit;


# Przypisanie wartości parametrów
data;
param n := 3;
param c := [1] 30 [2] 50 [3] 40;
param w := [1] 10 [2] 8 [3] 5;
param h := [1] 12 [2] 20 [3] 7;
param p := [1] 560 [2] 480 [3] 500;
param h_limit := 1400;
param f_limit := 100;

solve;

display x, Profit; 
# Wynik: 1 = 0, 2 = 53.8462, 3 = 46.1538, Profit = 20538.5

end;

