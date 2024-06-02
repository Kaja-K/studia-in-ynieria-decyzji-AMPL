option solver cplex;
reset;

# Parametry
set zdarzenie;						# Zbiór zdarzeń
set projekt;						# Zbiór projektów
param budzet;						# Budżet inwestycyjny
param tablica{zdarzenie,projekt};	# Tabela zysków i strat dla każdego projektu w zależności od zdarzenia

# Zmienne decyzyjne
# Ilość dolarów zainwestowanych w każdy projekt
var ilosc_dolarow{projekt} >= 0; 
# Całkowity zysk
var zysk;

# Funkcja celu - Maksymalizacja zysku
maximize zysk_calkowity: zysk;

# Ograniczenia
# Suma inwestycji we wszystkie projekty nie może przekroczyć dostępnego budżetu inwestycyjnego.
o_limit_budzet: sum{j in projekt} ilosc_dolarow[j] = budzet;
# Zysk nie może przekroczyć sumy zysków i strat dla każdego projektu w danym zdarzeniu, pomnożonych przez ilość dolarów zainwestowanych w ten projekt.
o_zysku{i in zdarzenie}: zysk <= sum{j in projekt} ilosc_dolarow[j] * tablica[i,j]; 

data;
set zdarzenie := 'Zdarzenie-1', 'Zdarzenie-2', 'Zdarzenie-3';
set projekt := 'Projekt-1', 'Projekt-2', 'Projekt-3', 'Projekt-4';
param budzet := 500000;
param tablica: 'Projekt-1' 'Projekt-2' 'Projekt-3' 'Projekt-4':= 'Zdarzenie-1' -3 4 -7 15 'Zdarzenie-2' 5 -3 9 4 'Zdarzenie-3' 3 2 10 -8;

solve;
display ilosc_dolarow, zysk_calkowity;
end;