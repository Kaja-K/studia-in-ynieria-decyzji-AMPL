option solver cplex;
reset;

# Deklaracja parametrów
set projekty;
set lata;
param koszt {projekty}; 		# Koszt projektów
param przychod {projekty}; 		# Przychód z projektów
param budżet {lata}; 			# Budżet na lata

# Deklaracja zmiennych decyzyjnych 
var ukończone {projekty, lata} binary;  # Zmienna wskazująca ukończenie
var częściowe2 >= 0, <= 1; 				# Zmienna ciągła dla częściowego ukończenia Projektu 2
var częściowe3 >= 0, <= 1; 				# Zmienna ciągła dla częściowego ukończenia Projektu 3

# Funkcja celu - maksymalizacja całkowitego przychodu
maximize całkowity_przychód: sum {p in projekty, l in lata} (ukończone[p,l] * przychod[p]);

# Ograniczenia
subject to 
ograniczenie_budżetu {l in lata}: sum {p in projekty} (ukończone[p,l] * koszt[p]) <= budżet[l];	# Ograniczenie budżetowe
ukończenie_1_i_4: sum {l in lata} ukończone[1,l] = 1; 								  			# Ukończenie Projektu 1 w całości
ukończenie_4_i_4: sum {l in lata} ukończone[4,l] = 1; 								  			# Ukończenie Projektu 4 w całości
częściowe_2 {l in lata}: sum {p in projekty: p <> 1 and p <> 4} ukończone[2,l] >= 0.25; 		# Warunek częściowego ukończenia Projektu 2
częściowe_3 {l in lata}: sum {p in projekty: p <> 1 and p <> 4} ukończone[3,l] >= 0.25; 		# Warunek częściowego ukończenia Projektu 3

# Dane wejściowe
data;
set projekty := 1 2 3 4;
set lata := 1 2 3 4 5;
param: koszt przychod := 1 5.0 0.05 2 8.0 0.07 3 15.0 0.15 4 1.2 0.02;
param budżet := 1 3.0 2 6.0 3 7.0 4 7.0 5 7.0;

solve;

display ukończone, całkowity_przychód; 
# Wynik: całkowity_przychód = 1.1,  - ?

end;
