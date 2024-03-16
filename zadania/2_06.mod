option solver cplex;
reset;

# Deklaracja parametrów
param n, integer, > 0;          			# Liczba miast
param m, integer, > 0;          			# Liczba spalarni
param l, integer, > 0;          			# Liczba wysypisk
param transport_1{i in 1..n, j in 1..m}; 	# Koszt transportu z miast do spalarni
param transport_2{j in 1..m, k in 1..l}; 	# Koszt transportu z spalarni do wysypiska
param spalanie{j in 1..m};      			# Koszt spalania śmieci w poszczególnych spalarniach
param popiol{j in 1..m};        			# Ilość popiołu wytworzonego w poszczególnych spalarniach
param limit_spalania{j in 1..m};    		# Limit spalania śmieci w poszczególnych spalarniach
param limit_wysypiska{k in 1..l};    		# Limit pojemności wysypiska

# Zmienne decyzyjne
var x{i in 1..n, j in 1..m} >= 0; # Tony śmieci wysłanej z miasta i do spalarni j
var y{j in 1..m, k in 1..l} >= 0; # Tony popiołu transportowanych ze spalarni j do wysypiska k

# Funkcja celu minimalizacja kosztu
minimize koszt: 
    sum{i in 1..n, j in 1..m} transport_1[i,j] * x[i,j] +  	# Koszt transportu z miast do spalarni
    sum{j in 1..m} spalanie[j] * sum{i in 1..n} x[i,j] +    # Koszt spalania śmieci w poszczególnych spalarniach
    sum{j in 1..m, k in 1..l} transport_2[j,k] * y[j,k];  	# Koszt transportu z spalarni do wysypiska

# Ograniczenia 
subject to
o_spalanie{j in 1..m}: sum{i in 1..n} x[i,j] <= limit_spalania[j];    		   # Limit spalania śmieci w poszczególnych spalarniach
o_pop{j in 1..m}: sum{i in 1..n} popiol[j] * x[i,j] <= sum{k in 1..l} y[j,k];  # Ilość popiołu wytworzonego w poszczególnych spalarniach
o_wysypisko{k in 1..l}: sum{j in 1..m} y[j,k] <= limit_wysypiska[k];     	   # Limit pojemności wysypiska

# Dane
data;
param n := 2;  
param m := 2; 
param l := 2;  
param transport_1 := 1 1 30 1 2 5 2 1 36 2 2 42;
param transport_2 := 1 1 5  1 2 8 2 1 9  2 2 6;
param spalanie := 1 40 2 30;
param popiol := 1 0.3 2 0.3;
param limit_spalania := 1 1500 2 1500;
param limit_wysypiska := 1 500 2 500;

solve;

display x, y, koszt;
# Wynik: - ?

end;
