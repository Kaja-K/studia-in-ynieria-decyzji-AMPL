option solver cplex;
reset;

# Definicja zestawu danych
param maszyny > 0, integer;  		# Liczba maszyn
param waga{1..maszyny}, integer;	# Waga maszyn
param wsp_x{1..maszyny}, integer; 	# Współrzędne X dla poszczególnych maszyn
param wsp_y{1..maszyny}, integer; 	# Współrzędne y dla poszczególnych maszyn

# Zmienne - współrzędne
var nowa_x, integer;				# Szukana współrzędna X dla nowej maszyny
var nowa_y, integer;				# Szukana współrzędna Y dla nowej maszyny
var odleglosc_x{1..maszyny};		# Zmienna określająca odległość (nowa_x - wsp_x)
var odleglosc_y{1..maszyny};		# Zmienna określająca odległość (nowa_y - wsp_y)

# Funkcja celu - minimalizacja sumy ważonych odległości nowej maszyny od istniejących maszyn
minimize odleglosc: sum{i in 1..maszyny} odleglosc_x[i]* waga[i] + sum{i in 1..maszyny} odleglosc_y[i] * waga[i];

# Ograniczenia - wartości względne i bezwzględne w postaci liniowej
subject to 
o_1{i in 1..maszyny}: odleglosc_x[i] >= nowa_x - wsp_x[i];
o_2{i in 1..maszyny}: odleglosc_x[i] >= -(nowa_x - wsp_x[i]);
o_3{i in 1..maszyny}: odleglosc_y[i] >= nowa_y - wsp_y[i];
o_4{i in 1..maszyny}: odleglosc_y[i] >= -(nowa_y - wsp_y[i]);

data;
param maszyny := 4;          		
param waga := 1 5 2 7 3 3 4 10;			
param wsp_x:= 1 3 2 0 3 -2 4 2; 		
param wsp_y:= 1 0 2 -3 3 1 4 4; 		

solve;
display nowa_x, nowa_y, odleglosc;
# Wynik:  nowa_x = 2, nowa_y = 1, odleglosc = 94

end;
