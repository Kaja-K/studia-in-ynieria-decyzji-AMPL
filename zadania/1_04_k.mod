option solver cplex; 
reset;             

# Parametry
set mieszanki; # Zbiór stopów
set pierwiastki; # Zbiór pierwiastków
param popyt; # Całkowite zapotrzebowanie na mieszankę (w tonach)
param zawartosc{mieszanki, pierwiastki}; # Zawartość pierwiastków w poszczególnych stopach
param limit{pierwiastki}; # Limity zawartości pierwiastków w mieszance (procent)
param koszt{mieszanki}; # koszt za tonę każdego stopu
param znak{pierwiastki}; # Znak ograniczenia dla każdego pierwiastka (1 dla <=, -1 dla >=)

# Zmienna decyzyjna - Ilość ton każdego stopu użytego w mieszance
var ilosc_stopow{m in mieszanki} >= 0;

# Funkcja celu - Minimalizuje całkowity koszt mieszanki, czyli sumę kosztów ton stopów użytych w mieszance. 
minimize calkowity_koszt: sum{m in mieszanki} ilosc_stopow[m] * koszt[m];

# Ograniczenia
# Zapewnia, że ilość użytych ton stopów odpowiada całkowitemu zapotrzebowaniu na mieszankę
o_popyt: sum{m in mieszanki} ilosc_stopow[m] = popyt;
# Kontroluje zawartość pierwiastków w mieszance, ograniczając ją do określonych limitów.
o_pierwiastek{p in pierwiastki}: (sum{m in mieszanki} ilosc_stopow[m] * zawartosc[m, p]) * znak[p] <= limit[p] * popyt * znak[p];

data;
param popyt := 5000;
param zawartosc:  'C' 'Si' 'Mn' 'P' :=
	    'Stop-1' 0.28 0.1 0.3 0.1
	    'Stop-2' 0.14 0.12 0.2 0.1
	    'Stop-3' 0.1 0.06 0.3 0.15;
param: mieszanki: koszt := 
	    'Stop-1' 200 
	    'Stop-2' 150 
	    'Stop-3' 400;
param: pierwiastki: limit, znak := 
	    'C' 0.14 1 
	    'Si' 0.08 1 
	    'Mn' 0.25 -1 
	    'P' 0.12 -1;

solve;
display calkowity_koszt, ilosc_stopow;
end;