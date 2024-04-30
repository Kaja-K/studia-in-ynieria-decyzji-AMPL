option solver cplex;
reset;

# Dane
set F;					# Fabryki
set O;					# Odbiorcy
param podaz;			# Podaż
param popyt{O};			# Popyt odbiorców
param c{F,O};			# Koszty transportu
param fixdex{F};		# Koszty uruchomienia fabryk
param limit;			# Minimalna produkcja
param M:= podaz*card(F)	# Całkowita podaż

# Zmienne decyzyjne
x{F,O} >= 0 integer;
y{F} binary;

# Funkcja celu
minimize g: sum{i in F, j in O} c[i,j] *x[i,j] + sum{i in F} fixedc[i] * y[i];

# Ograniczenia
c1{i in F} sum{j in O} x[i,j] <= podaz;
c2{i in O} sum{j in F} x[i,j] >= popyt[j];
c3{i in F} M*y[i] 			  >= sum{j in O} x[i,j];
c4{i in F} sum{j in O} x[i,j] <= M*y[i];
c5{i in F} sum{j in O} -x[i,j]+limit <= M *(1-y[i]);

# Dane
data;



solve;
display x,y;