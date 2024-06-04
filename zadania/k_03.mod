option solver cplex;
reset;

# Parametry
set wegiel; # Zbiór typów węgla
set mieszanka; # Zbiór typów mieszanki
param zawartosc_popiolow{wegiel}; # Zawartość popiołu w węglu
param zawartosc_subs{wegiel}; # Zawartość substancji w węglu
param koszt{wegiel}; # Koszt węgla
param wydobycie{wegiel}; # Ilośc wydobycia węgla
param zawartosc_p_min{mieszanka}; # Minimalna zawartość popiołu w mieszance
param zawartosc_p_max{mieszanka}; # Maksymalna zawartość popiołu w mieszance
param zawartosc_s_min{mieszanka}; # Minimalna zawartość substancji w mieszance
param zawartosc_s_max{mieszanka}; # Maksymalna zawartość substancji w mieszance
param cena{mieszanka}; # Cena za każdą mieszankę

# Zmienna Decyzyjna - Ilość gotowej mieszanki
var ilosc_mieszanki{wegiel, mieszanka} >= 0; 

# Funkcja celu - Maksymalizacja zysku. Zysk = przychód - koszt
maximize zysk: sum{i in mieszanka, j in wegiel} ilosc_mieszanki[j, i] * cena[i] - sum{j in wegiel} sum{i in mieszanka} ilosc_mieszanki[j, i] * koszt[j];

# Ograniczenia
# Ograniczenie maksymalnego wydobycia węgla
o_zuzycie_wydobycia {j in wegiel}:sum{i in mieszanka} ilosc_mieszanki[j, i] <= wydobycie[j];
# Ograniczenia dotyczące zawartości popiołów
o_min_p{i in mieszanka}:zawartosc_p_min[i] * sum{j in wegiel} ilosc_mieszanki[j, i] <= sum{j in wegiel} ilosc_mieszanki[j, i] * zawartosc_popiolow[j];
o_max_p{i in mieszanka}:zawartosc_p_max[i] * sum{j in wegiel} ilosc_mieszanki[j, i] >= sum{j in wegiel} ilosc_mieszanki[j, i] * zawartosc_popiolow[j];
# Ograniczenia dotyczące zawartości substancji
o_min_s{i in mieszanka}:zawartosc_s_min[i] * sum{j in wegiel} ilosc_mieszanki[j, i] <= sum{j in wegiel} ilosc_mieszanki[j, i] * zawartosc_subs[j];
o_max_s{i in mieszanka}:zawartosc_s_max[i] * sum{j in wegiel} ilosc_mieszanki[j, i] >= sum{j in wegiel} ilosc_mieszanki[j, i] * zawartosc_subs[j];

data;
set wegiel := "Typ A" "Typ B" "Typ C";
set mieszanka := "Gruba" "PolGruba";
param: zawartosc_popiolow zawartosc_subs koszt wydobycie :=
    "Typ A" 0.10 0.10 60 10000
    "Typ B" 0.15 0.15 50 20000 
    "Typ C" 0.15 0.40 40 30000;
param: zawartosc_p_min zawartosc_p_max zawartosc_s_min zawartosc_s_max cena :=
    "PolGruba" 0.14 0.22 0.14 0.18 65
    "Gruba" 0.12 0.15 0.18 0.30 60;

solve;
display zysk, ilosc_mieszanki;
end;