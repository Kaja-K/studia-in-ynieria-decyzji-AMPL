option solver cplex;
reset;

# Deklaracja parametrów
param h > 0, integer; 				# Liczba hurtowni
param f > 0, integer;   			# Liczba fabryk
param koszt_przewozu{1..f, 1..h};  	# Koszt przewozu z fabryk do hurtowni
param podaż{1..f};   		 		# Podaż z poszczególnych fabryk
param popyt{1..h};   				# Popyt w poszczególnych hurtowniach

# Zmienna decyzyjna - Ilość sztuk przewiezionych z f i do hurtowni j
var przewiezione{i in 1..f, j in 1..h} >= 0;

# Funkcja celu - Minimalizacja kosztu przewozu
minimize koszt: sum{i in 1..f, j in 1..h} przewiezione[i, j] * koszt_przewozu[i, j];

# Ograniczenia
o_podaży{i in 1..f}: sum{j in 1..h} przewiezione[i, j] = podaż[i];    # Podaż z fabryk
o_popytu{j in 1..h}: sum{i in 1..f} przewiezione[i, j] = popyt[j];    # Popyt w hurtowniach

data;
param h := 4; 
param f := 3; 
param koszt_przewozu := 1 1 2 1 2 4 1 3 1 1 4 5 2 1 5 2 2 1 2 3 3 2 4 3 3 1 1 3 2 2 3 3 4 3 4 1;
param podaż := 1 200 2 100 3 300;  		
param popyt := 1 250 2 250 3 75 4 25; 

solve;
display koszt, przewiezione;
# Wynik: koszt = 875
# przewiezione
# 1 1   125
# 1 3    75
# 2 2   100
# 3 1   125
# 3 2   150
# 3 4    25

end;