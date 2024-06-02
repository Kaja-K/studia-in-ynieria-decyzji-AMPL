option solver cplex; 
reset;             

# Parametry
set mieszanka;        					# Zbiór stopów
set pierwiastek;      					# Zbiór pierwiastków
param popyt;                            # Całkowite zapotrzebowanie na mieszankę (w tonach)
param zawartosc{mieszanka, pierwiastek};# Zawartość pierwiastków w poszczególnych stopach
param limit{pierwiastek};               # Limity zawartości pierwiastków w mieszance (procent)
param koszt{mieszanka};                 # koszt za tonę każdego stopu
param znak{pierwiastek};                # Znak ograniczenia dla każdego pierwiastka (1 dla <=, -1 dla >=)

# Zmienna decyzyjna - Ilość ton każdego stopu użytego w mieszance
var ilosc_stopow{i in mieszanka} >= 0;

# Funkcja celu - Minimalizuje całkowity koszt mieszanki, czyli sumę kosztów ton stopów użytych w mieszance. 
minimize koszt: sum{i in mieszanka} ilosc_stopow[i] * koszt[i];

# Ograniczenia
o_popyt: sum{i in mieszanka} ilosc_stopow[i] = popyt; 																			 # Zapewnia, że ilość użytych ton stopów odpowiada całkowitemu zapotrzebowaniu na mieszankę
o_pierwiastek{j in pierwiastek}:(sum{i in mieszanka} ilosc_stopow[i] * zawartosc[i, j]) * znak[j] <= limit[j] * popyt * znak[j]; # Kontroluje zawartość pierwiastków w mieszance, ograniczając ją do określonych limitów.

data;
param popyt:= 5000;
param zawartosc:  'C' 'Si' 'Mn' 'P' :=	'Stop-1' 0.28 0.1 0.3 0.1
								  		'Stop-2' 0.14 0.12 0.2 0.1
								  		'Stop-3' 0.1 0.06 0.3 0.15;
param: mieszanka: koszt:= 		  		'Stop-1' 200
								  		'Stop-2' 150
								  		'Stop-3' 400;
param: pierwiastek: limit, znak:= 		'C' 0.14 1
								  		'Si' 0.08 1
								  		'Mn' 0.25 -1
								  		'P' 0.12 -1;
solve;
display koszt, ilosc_stopow;
end;
