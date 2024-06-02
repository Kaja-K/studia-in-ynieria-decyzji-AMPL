option solver cplex;
reset;

# Parametry
set zadania;                                    # Zbiór zadań w projekcie
set poprzedniki within zadania cross zadania;   # Zbiór poprzedników zadań
param czas_wykonania{zadania};                  # Czas trwania każdego zadania
param minimalny_czas{zadania};                  # Minimalny czas wykonania każdego zadania
param koszt_skrocenia{zadania};                 # Koszt skrócenia każdego zadania
param maksymalny_czas;                          # Maksymalny czas trwania projektu

# Zmienne decyzyjne
var termin_zakonczenia{zadania} >= 0;           # Termin zakończenia każdego zadania
var zapas_czasu{zadania} >= 0;                  # Zapas czasu dla każdego zadania

# Funkcja celu - Minimalizacja całkowitego kosztu skrócenia projektu
minimize koszt_skrocenia_projektu: sum{i in zadania} koszt_skrocenia[i] * zapas_czasu[i];

# Ograniczenia 
o_poprzednika{(i,j) in poprzedniki}: termin_zakonczenia[j] >= termin_zakonczenia[i] + czas_wykonania[i] - zapas_czasu[i]; 	# Zapewnienie odpowiedniego czasu dla poprzedników
o_maksymalny_termin{i in zadania}: termin_zakonczenia[i] + czas_wykonania[i] - zapas_czasu[i] <= maksymalny_czas;       	# Ograniczenie maksymalnego terminu zakończenia projektu
o_minimalny_czas_wykonania{i in zadania}: czas_wykonania[i] - zapas_czasu[i] >= minimalny_czas[i];                        	# Zapewnienie minimalnego czasu trwania dla każdego zadania

data;
param maksymalny_czas := 7;
set zadania := 'A' 'B' 'C' 'D' 'E' 'F' 'G';
set poprzedniki := ('B', 'D') ('C', 'D') ('A', 'E') ('E', 'F') ('D', 'F') ('C', 'G');
param: zadania: czas_wykonania, koszt_skrocenia, minimalny_czas :=	'A' 2 1 1 
																    'B' 4 2 2 
																    'C' 5 1 3 
																    'D' 6 2 1 
																    'E' 3 5 1 
																    'F' 4 4 2 
																    'G' 4 1 3;
solve;
display koszt_skrocenia_projektu, zapas_czasu, termin_zakonczenia;
end;