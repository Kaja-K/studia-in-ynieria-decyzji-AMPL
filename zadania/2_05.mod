option solver cplex;
reset;

# Parametry
param n > 0, integer;  	    # Liczba maszyn w fabryce
param wagi{1..n}, integer;	# Wagi poszczególnych maszyn
param wsp_x{1..n}, integer; # Współrzędne X dla maszyn
param wsp_y{1..n}, integer; # Współrzędne Y dla maszyn

# Zmienne decyzyjne
var nowa_x, integer;	# Współrzędna X nowej maszyny
var nowa_y, integer;	# Współrzędna Y nowej maszyny
var odleglosc_x{1..n};	# Odległość nowej maszyny od istniejących maszyn wzdłuż osi X
var odleglosc_y{1..n};	# Odległość nowej maszyny od istniejących maszyn wzdłuż osi Y

# Funkcja celu - Minimalizacja sumy ważonych odległości nowej maszyny od istniejących maszyn
minimize suma_odleglosci: sum{i in 1..n} (odleglosc_x[i] * wagi[i]) + sum{i in 1..n} (odleglosc_y[i] * wagi[i]);

# Ograniczenia - Określenie odległości nowej maszyny od istniejących maszyn
o_odleglosc_x{i in 1..n}: odleglosc_x[i] >= nowa_x - wsp_x[i];           # Odległość nowej maszyny od istniejących maszyn wzdłuż osi X
o_odleglosc_x_minus{i in 1..n}: odleglosc_x[i] >= -(nowa_x - wsp_x[i]);  # (wartość bezwzględna)
o_odleglosc_y{i in 1..n}: odleglosc_y[i] >= nowa_y - wsp_y[i];           # Odległość nowej maszyny od istniejących maszyn wzdłuż osi Y
o_odleglosc_y_minus{i in 1..n}: odleglosc_y[i] >= -(nowa_y - wsp_y[i]);  # (wartość bezwzględna)

data;
param n := 4;          		
param wagi := 1 5 2 7 3 3 4 10;			
param wsp_x:= 1 3 2 0 3 -2 4 2; 		
param wsp_y:= 1 0 2 -3 3 1 4 4; 		

solve;
display suma_odleglosci, nowa_x, nowa_y;
# Wynik: suma_odleglosci = 94
# nowa_x = 2
# nowa_y = 1

end;