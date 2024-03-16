option solver cplex;
reset;

# Deklaracja parametrów
set projects;
set years;
param cost {projects}; 		# Koszt projektów
param revenue {projects}; 	# Przychód z projektów
param budget {years}; 		# Budżet na lata

# Deklaracja zmiennych decyzyjnych 
var complete {projects, years} binary;  # Zmienna wskazująca ukończenie
var partial2 >= 0, <= 1; 				# Zmienna ciągła dla częściowego ukończenia Projektu 2
var partial3 >= 0, <= 1; 				# Zmienna ciągła dla częściowego ukończenia Projektu 3

# Funkcja celu - maksymalizacja całkowitego przychodu
maximize total_revenue: sum {p in projects, y in years} (complete[p,y] * revenue[p]);

# Ograniczenia
subject to 
o_budget {y in years}: sum {p in projects} (complete[p,y] * cost[p]) <= budget[y]; 	  # Ograniczenie budżetowe
complete_1_and_4: sum {y in years} complete[1,y] = 1; 								  # Ukończenie Projektu 1 w całości
complete_4_and_4: sum {y in years} complete[4,y] = 1; 								  # Ukończenie Projektu 4 w całości
partial_2 {y in years}: sum {p in projects: p <> 1 and p <> 4} complete[2,y] >= 0.25; # Warunek częściowego ukończenia Projektu 2
partial_3 {y in years}: sum {p in projects: p <> 1 and p <> 4} complete[3,y] >= 0.25; # Warunek częściowego ukończenia Projektu 3

# Dane wejściowe
data;
set projects := 1 2 3 4;
set years := 1 2 3 4 5;
param: cost revenue := 1 5.0 0.05 2 8.0 0.07 3 15.0 0.15 4 1.2 0.02;
param budget := 1 3.0 2 6.0 3 7.0 4 7.0 5 7.0;

solve;

display complete, total_revenue; 
# Wynik:total_revenue = 1.1,  - coś jest źle bo zwraca kompletność 2 i 3 projektu

end;
