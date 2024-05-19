option solver cplex; 
reset;

# Parametry 
param t > 0, integer; 						# Liczba dni w tygodniu
param z > 0, integer; 						# Liczba zmian
param minimalna_liczba_pracownikow{1..t}; 	# Minimalna liczba pracowników danego dnia
param czy_pracownik_pracuje{1..t, 1..z};	# Czy pracownik z danej zmiany pracuje

# Zmienna decyzyjna - Liczba zatrudnionych pracowników w dniu i
var liczba_zatrudnionych_pracownikow{i in 1..t} >= 0, integer; 

# Funkcja celu =  Minimalizacja sumy zatrudnionych pracowników
minimize Zatrudnieni: sum{i in 1..t} liczba_zatrudnionych_pracownikow[i];

# Ograniczenie - Warunek minimalnej liczby pracowników dla każdego dnia tygodnia
o_dnia_tygodnia{i in 1..t}: sum{j in 1..z} liczba_zatrudnionych_pracownikow[j] * czy_pracownik_pracuje[i, j] >= minimalna_liczba_pracownikow[i];

data;
param t := 7; 
param z := 7;
param minimalna_liczba_pracownikow:= [1] 17 [2] 13 [3] 15 [4] 19 [5] 14 [6] 16 [7] 11;
param czy_pracownik_pracuje:= 1 1 1 1 2 0 1 3 0 1 4 1 1 5 1 1 6 1 1 7 1 2 1 1 2 2 1 2 3 0 2 4 0 2 5 1 2 6 1 2 7 1 3 1 1 3 2 1 3 3 1 3 4 0 3 5 0  3 6 1 3 7 1 4 1 1 4 2 1 4 3 1 4 4 1 4 5 0 4 6 0 4 7 1 5 1 1 5 2 1 5 3 1 5 4 1 5 5 1 5 6 0 5 7 0 6 1 0 6 2 1 6 3 1 6 4 1 6 5 1 6 6 1 6 7 0 7 1 0 7 2 0 7 3 1 7 4 1 7 5 1 7 6 1 7 7 1;

solve;
display Zatrudnieni, liczba_zatrudnionych_pracownikow; 
# Wynik: Zatrudnieni = 23
# liczba_zatrudnionych_pracownikow
# 	1  6
# 	2  4
# 	3  1
# 	4  8
# 	5  0
# 	6  4
# 	7  0

end;