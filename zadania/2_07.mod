option solver cplex;
reset;

# Parametry:
param projekty > 0, integer;   							# Liczba projektów
param zdarzenia > 0, integer;   						# Liczba zdarzeń
param zysk_strata{i in 1..projekty, j in 1..zdarzenia}; # Zysk lub strata dla projektu i w zdarzeniu j
param inwestycja;       								# Kwota przeznaczona na inwestycje

# Zmienne decyzyjne - Pieniądze przeznaczone na projekt i przy zdarzeniu j
var x{i in 1..projekty} >= 0;           

# Funkcja celu - minimalizacja strat
minimize strata: sum{i in 1..projekty, j in 1..zdarzenia} min(zysk_strata[i,j] * x[i]);

# Ograniczenia:
subject to
o_projekty{i in 1..projekty}: x[i] >= 0;   			# Pieniądze przeznaczone na projekt i muszą być nieujemne
o_limit: sum{i in 1..projekty} x[i] = inwestycja;  	# Całkowity koszt inwestycji nie może przekroczyć dostępnej kwoty

# Dane
data;
param projekty := 4; 
param zdarzenia := 3;  
param zysk_strata:= 1 1 -3 1 2 5 1 3 3 2 1 4 2 2 -3 2 3 2 3 1 -7 3 2 9 3 3 10 4 1 15 4 2 4 4 3 -8;
param inwestycja:= 500000;  

solve;
display x, strata;
#Wynik: 3 = 500000, zysk = 1500000

end;
