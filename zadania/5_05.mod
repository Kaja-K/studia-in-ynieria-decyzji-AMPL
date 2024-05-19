option solver cplex;
reset;

# Parametry
set Osoby;											# Zbiór osób 
set Grupy;											# Zbiór grup
param przyjazn {Osoby, Osoby} binary;  				# Macierz określająca, czy pary osób są zaprzyjaźnione (1) czy nie (0)
param przynaleznosc_do_grp {Osoby, Grupy} binary;   # Macierz określająca przynależność osób do poszczególnych grup

# Funkcja celu - Minimalizacja liczby grup
minimize liczba_grup: sum {g in Grupy} przynaleznosc_do_grp[g, g];

# Ograniczenia
o_brak_przyjaciol_grp {g in Grupy}: sum {p in Osoby: przynaleznosc_do_grp[p, g]} <= 1; # W każdej grupie może być maksymalnie jedna osoba mająca znajomych w tej grupie
o_maks_klika {j in Osoby}: sum {i in Osoby: przyjazn[i, j]} >= 1; 					   # Każda osoba w grupie musi znać przynajmniej jedną inną osobę w tej grupie

data;


solve;
display o_maks_klika, przynaleznosc_do_grp,liczba_grup;

end;