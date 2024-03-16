option solver cplex;
reset;

# Parametry:
param n > 0, integer;   					# Liczba projektów
param m > 0, integer;   					# Liczba zdarzeń
param zysk_strata{i in 1..n, j in 1..m};  	# Zysk lub strata dla projektu i w zdarzeniu j
param inwestycja;       					# Kwota przeznaczona na inwestycje

# Zmienne decyzyjne - Pieniądze przeznaczone na projekt i przy zdarzeniu j
var x{i in 1..n} >= 0;           

# Funkcja celu - maksymalizacja zysku
maximize zysk: sum{i in 1..n, j in 1..m} min(zysk_strata[i,j] * x[i]);

# Ograniczenia:
subject to
o_projekty{i in 1..n}: x[i] >= 0;   		# Pieniądze przeznaczone na projekt i muszą być nieujemne
o_limit: sum{i in 1..n} x[i] = inwestycja;  # Całkowity koszt inwestycji nie może przekroczyć dostępnej kwoty

# Dane
data;
param n := 4; 
param m := 3;  
param zysk_strata:= 1 1 -3 1 2 5 1 3 3 2 1 4 2 2 -3 2 3 2 3 1 -7 3 2 9 3 3 10 4 1 15 4 2 4 4 3 -8;
param inwestycja:= 500000;  

solve;

display x, zysk;
#Wynik: 3 = 500000, zysk = 6000000

end;