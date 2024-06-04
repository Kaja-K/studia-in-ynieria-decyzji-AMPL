option solver cplex;
reset;

# Parametry
param typy > 0, integer; # Liczba dostępnych typów kotletów
param limit_kotlety{1..typy}; # Limit sprzedaży kotletów (kg) dla każdego typu
param cena_kotlet{1..typy}; # Cena sprzedaży kotletów ($ za kg) dla każdego typu
param koszt_indyk{1..typy}; # Koszt kupna indyków ($ za sztukę) dla każdego typu
param proc_miesa_bialego{1..typy}; # Minimalny procent mięsa białego w kotletach dla każdego typu
param mieso_biale{1..typy}; # Ilość mięsa białego z indyka (kg) dla każdego typu
param mieso_ciemne{1..typy}; # Ilość mięsa ciemnego z indyka (kg) dla każdego typu

# Zmienne decyzyjne
# Liczba kilogramów kotletów do wyprodukowania dla każdego typu, ograniczona przez limit sprzedaży.
var kg_kotlety{t in 1..typy} >= 0, <= limit_kotlety[t], integer;
# Liczba zakupionych indyków dla każdego typu.
var liczba_indykow{t in 1..typy} >= 0, integer;        

# Funkcja celu - Zmaksymalizowanie zysku (przychód ze sprzedaży - koszt zakupu indyków).
maximize zysk: sum{t in 1..typy} kg_kotlety[t] * cena_kotlet[t] - sum{t in 1..typy} liczba_indykow[t] * koszt_indyk[t];

# Ograniczenia - Ograniczenie minimalnej zawartości mięsa białego i ciemnego w kotletach.
# Wymagana ilość mięsa białego musi być większa lub równa sumie ilości mięsa białego w kotletach każdego typu.
o_mieso_biale: sum{t in 1..typy} liczba_indykow[t] * mieso_biale[t] >= sum{t in 1..typy} kg_kotlety[t] * proc_miesa_bialego[t];
# Wymagana ilość mięsa ciemnego musi być większa lub równa sumie ilości mięsa ciemnego w kotletach każdego typu.
o_mieso_ciemne: sum{t in 1..typy} liczba_indykow[t] * mieso_ciemne[t] >= sum{t in 1..typy} kg_kotlety[t] * (1 - proc_miesa_bialego[t]);

data;
param typy := 2;
param: limit_kotlety cena_kotlet koszt_indyk proc_miesa_bialego mieso_biale mieso_ciemne := 
1 50 8 10 0.7 3 2 
2 30 6 8 0.5 1.5 4;

solve;
display zysk, kg_kotlety, liczba_indykow;
end;