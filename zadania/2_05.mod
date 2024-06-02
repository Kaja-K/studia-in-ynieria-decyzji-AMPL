option solver cplex;
reset;

# Parametry
set maszyna;
param wagi{maszyna}, integer;	# Wagi poszczególnych maszyn
param wsp_x{maszyna}, integer;	# Współrzędne X dla maszyn
param wsp_y{maszyna}, integer;	# Współrzędne Y dla maszyn

# Zmienne decyzyjne
# Współrzędna X nowej maszyny
var nowa_x, integer;		
# Współrzędna Y nowej maszyny
var nowa_y, integer;		
# Odległość nowej maszyny od istniejących maszyn wzdłuż osi X
var odleglosc_x{maszyna};	
# Odległość nowej maszyny od istniejących maszyn wzdłuż osi Y
var odleglosc_y{maszyna};	

# Funkcja celu - Minimalizacja sumy ważonych odległości nowej maszyny od istniejących maszyn
minimize suma_odleglosci: sum{i in maszyna} wagi[i]*(odleglosc_x[i] + odleglosc_y[i]);

# Ograniczenia - Określenie odległości nowej maszyny od istniejących maszyn
# Odległość nowej maszyny od istniejących maszyn wzdłuż osi X i Y musi być większa lub równa różnicy współrzędnych nowej maszyny i istniejących maszyn.
o_odleglosc_x{i in maszyna}: odleglosc_x[i] >= nowa_x - wsp_x[i];           
o_odleglosc_x_minus{i in maszyna}: odleglosc_x[i] >= -(nowa_x - wsp_x[i]);# (wartość bezwzględna)  
# Odległość ta jest większa lub równa wartości bezwzględnej różnicy współrzędnych nowej maszyny i istniejących maszyn.
o_odleglosc_y{i in maszyna}: odleglosc_y[i] >= nowa_y - wsp_y[i];           
o_odleglosc_y_minus{i in maszyna}: odleglosc_y[i] >= -(nowa_y - wsp_y[i]);# (wartość bezwzględna)

data;        		
param: maszyna: wsp_x, wsp_y, wagi := 'Fabryka-1' 3 0 5 'Fabryka-2' 0 -3 7 'Fabryka-3' -2 1 3 'Fabryka-4' 2 4 10;

solve;
display suma_odleglosci, nowa_x, nowa_y;
end;