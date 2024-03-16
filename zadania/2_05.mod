option solver cplex;
reset;

# Definicja zestawu danych
param n > 0, integer;  		# Liczba maszyn, musi być dodatnia liczba całkowita
param waga{1..n};      		# Wagi dla poszczególnych maszyn
param wsp_x{1..n}, integer; # Współrzędne x dla poszczególnych maszyn
param wsp_y{1..n}, integer; # Współrzędne y dla poszczególnych maszyn

# Zmienne - współrzędne
var x1, integer;
var x2, integer;

# Funkcja celu - minimalizacja sumy ważonych odległości nowej maszyny od istniejących maszyn
minimize odleglosc: sum{i in 1..n} waga[i]* (abs(x1 - wsp_x[i]) + abs(x2 - wsp_y[i]));

# Ograniczenia
subject to 
o_nachodzenie {i in 1..n}: abs(x1 - wsp_x[i]) + abs(x2 - wsp_y[i]) >= 1; # Maszyny na siebie nie zachodzą
o_prosta {i in 1..n, j in 1..n: i != j}: (wsp_x[i] != wsp_x[j]) || ((x1 - wsp_x[i]) * (wsp_y[j] - wsp_y[i]) != (x2 - wsp_y[i]) * (wsp_x[j] - wsp_x[i]));


data;
param n := 4;          					# Liczba maszyn
param waga:= [1] 5 [2] 7 [3] 3 [4] 10;  # Wagi dla poszczególnych maszyn
param wsp_x:= [1] 3 [2] 0 [3] -2 [4] 2; # Współrzędne x dla poszczególnych maszyn
param wsp_y:= [1] 0 [2] -3 [3] 1 [4] 4; # Współrzędne y dla poszczególnych maszyn

solve;

display x1, x2, odleglosc;
# Wynik: x1 = 0, x2 = 0, odleglosc = 105; - ?
end;             
