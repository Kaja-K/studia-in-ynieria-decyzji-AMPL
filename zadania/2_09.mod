option solver cplex;
reset;

# Deklaracja parametrów
param hurtownie > 0, integer; 		# Liczba hurtowni
param fabryki > 0, integer;   		# Liczba fabryk
param c{1..fabryki, 1..hurtownie};  # Koszt przewozu z fabryk do hurtowni
param podaż{1..fabryki};   		 	# Podaż z poszczególnych fabryk
param popyt{1..hurtownie};   		# Popyt w poszczególnych hurtowniach

# Zmienna decyzyjna - Ilość sztuk przewiezionych z fabryki i do hurtowni j
var przewiezione{i in 1..fabryki, j in 1..hurtownie} >= 0;

# Funkcja celu - minimalizacja kosztu przewozu
minimize koszt: sum{i in 1..fabryki, j in 1..hurtownie} przewiezione[i, j] * c[i, j];

# Ograniczenia
subject to
o_podaż{i in 1..fabryki}: sum{j in 1..hurtownie} przewiezione[i, j] = podaż[i];    # Podaż z fabryk
o_popyt{j in 1..hurtownie}: sum{i in 1..fabryki} przewiezione[i, j] = popyt[j];    # Popyt w hurtowniach

# Dane
data;
param hurtownie := 4; 
param fabryki := 3; 
param c := 1 1 2 1 2 4 1 3 1 1 4 5 2 1 5 2 2 1 2 3 3 2 4 3 3 1 1 3 2 2 3 3 4 3 4 1;
param podaż := 1 200 2 100 3 300;  		
param popyt := 1 250 2 250 3 75 4 25; 

solve;
display przewiezione, koszt;
#Wynik: 1 1 = 125, 1 3 = 75, 2 2 = 100, 3 1 = 125 ,3 2 = 150 ,3 4 = 25 ,koszt = 875

end;
