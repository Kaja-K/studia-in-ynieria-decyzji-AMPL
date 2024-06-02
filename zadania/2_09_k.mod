option solver cplex;
reset;

# Parametry
set fabryka; 					# Zbiór fabryk
set hurtownia; 					# Zbiór hurtowni
param popyt{hurtownia}; 		# Popyt w każdej hurtowni
param podaz{fabryka}; 			# Podaż z każdej fabryki
param cena{fabryka, hurtownia}; # Cena przewozu towarów z fabryk do hurtowni

# Zmienna decyzyjna - Ilość towarów przewiezionych z fabryki i do hurtowni
var ilosc_towarow{fabryka, hurtownia} >= 0;

# Funkcja celu - Minimalizacja kosztu przewozu
minimize Koszt: sum{i in fabryka, j in hurtownia} cena[i,j] * ilosc_towarow[i,j];

# Ograniczenia
o_fabryk{i in fabryka}: sum{j in hurtownia} ilosc_towarow[i,j] = podaz[i]; 	# Zapewnia, że suma towarów przewiezionych z każdej fabryki do wszystkich hurtowni jest równa podaży z danej fabryki.
o_hurtowni{j in hurtownia}: sum{i in fabryka} ilosc_towarow[i,j] = popyt[j];# Gwarantuje, że suma towarów dostarczonych do każdej hurtowni z wszystkich fabryk jest równa popytowi w danej hurtowni.

data;
param cena: 'H1' 'H2' 'H3' 'H4':= 	'F1' 2 4 1 5
									'F2' 5 1 3 3 
									'F3' 1 2 4 1;
param: fabryka: podaz:= 			'F1' 200
									'F2' 100
									'F3' 300;
param: hurtownia: popyt:= 			'H1' 250
									'H2' 250
									'H3' 75
									'H4' 25;
solve;
display ilosc_towarow, Koszt;
end;