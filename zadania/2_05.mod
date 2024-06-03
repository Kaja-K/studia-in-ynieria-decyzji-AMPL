option solver cplex;
reset;

# Parametry
set maszyny;
param wagi{maszyny}, integer; # Wagi poszczególnych maszyn
param wsp_x{maszyny}, integer; # Współrzędne X dla maszyn
param wsp_y{maszyny}, integer; # Współrzędne Y dla maszyn

# Zmienne decyzyjne
# Współrzędna X nowej maszyny
var nowa_x, integer;		
# Współrzędna Y nowej maszyny
var nowa_y, integer;		
# Odległość nowej maszyny od istniejących maszyn wzdłuż osi X
var odleglosc_x{maszyny};	
# Odległość nowej maszyny od istniejących maszyn wzdłuż osi Y
var odleglosc_y{maszyny};	

# Funkcja celu - Minimalizacja sumy ważonych odległości nowej maszyny od istniejących maszyn
minimize suma_odleglosci: sum{m in maszyny} wagi[m]*(odleglosc_x[m] + odleglosc_y[m]);

# Ograniczenia - Określenie odległości nowej maszyny od istniejących maszyn
# Odległość nowej maszyny od istniejących maszyn wzdłuż osi X i Y musi być większa lub równa różnicy współrzędnych nowej maszyny i istniejących maszyn.
o_odleglosc_x{m in maszyny}: odleglosc_x[m] >= nowa_x - wsp_x[m];           
o_odleglosc_x_minus{m in maszyny}: odleglosc_x[m] >= -(nowa_x - wsp_x[m]);# (wartość bezwzględna)  
# Odległość ta jest większa lub równa wartości bezwzględnej różnicy współrzędnych nowej maszyny i istniejących maszyn.
o_odleglosc_y{m in maszyny}: odleglosc_y[m] >= nowa_y - wsp_y[m];           
o_odleglosc_y_minus{m in maszyny}: odleglosc_y[m] >= -(nowa_y - wsp_y[m]);# (wartość bezwzględna)

data;        		
param: maszyny: wsp_x, wsp_y, wagi := 'Fabryka-1' 3 0 5 'Fabryka-2' 0 -3 7 'Fabryka-3' -2 1 3 'Fabryka-4' 2 4 10;

solve;
display suma_odleglosci, nowa_x, nowa_y;
end;