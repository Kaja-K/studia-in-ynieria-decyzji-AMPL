option solver cplex;
reset;

# Parametry
set fabryki; # Zbiór fabryk
set hurtownie; # Zbiór hurtowni
param popyt{hurtownie}; # Popyt w każdej hurtowni
param podaz{fabryki}; # Podaż z każdej fabryki
param cena{fabryki, hurtownie};	# Cena przewozu towarów z fabryk do hurtowni

# Zmienna decyzyjna - Ilość towarów przewiezionych z fabryki f i do hurtowni h
var ilosc_towarow{fabryki, hurtownie} >= 0;

# Funkcja celu - Minimalizacja kosztu przewozu
minimize koszt: sum{f in fabryki, h in hurtownie} cena[f,h] * ilosc_towarow[f,h];

# Ograniczenia
# Zapewnia, że suma towarów przewiezionych z każdej fabryki do wszystkich hurtowni jest równa podaży z danej fabryki.
o_fabryk{f in fabryki}: sum{h in hurtownie} ilosc_towarow[f,h] = podaz[f]; 	
# Gwarantuje, że suma towarów dostarczonych do każdej hurtowni z wszystkich fabryk jest równa popytowi w danej hurtowni.
o_hurtownia{h in hurtownie}: sum{f in fabryki} ilosc_towarow[f,h] = popyt[h];

data;
param cena: 'H1' 'H2' 'H3' 'H4':= 'F1' 2 4 1 5 'F2' 5 1 3 3 'F3' 1 2 4 1;
param: fabryki: podaz:='F1' 200 'F2' 100 'F3' 300;
param: hurtownie: popyt:= 'H1' 250 'H2' 250 'H3' 75 'H4' 25;

solve;
display ilosc_towarow, koszt;
end;