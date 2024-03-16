# Przykład 1 z wykładu 1 

option solver cplex;
reset;

# Definicja zmiennych decyzyjnych
var x1 >=0;
var x2 >=0;

# Funkcja celu do zmaxymalizowania
maximize zysk: 5*x1+4*x2;

# Ograniczenia
subject to
M1: 6*x1+4*x2 <= 24;
M2: x1+2*x2 <= 6;
Popyt1: x2-x1 <= 1;
Popyt2: x2 <= 2;

solve;

display x1,x2, zysk;
# Wynik x1 = 3, x2 = 1.5, zysk = 21

end;

