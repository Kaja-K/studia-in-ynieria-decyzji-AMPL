option solver cplex;
reset;

# Parametry
param n>0, integer;              # Liczba dostępnych typów kotletów
param limit_kotlety{1..n};       # Limit sprzedaży kotletów (kg)
param cena_kotlet{1..n};         # Cena sprzedaży kotletów ($ za kg)
param koszt_indyk{1..n};         # Koszt kupna indyków ($ za sztukę)
param proc_miesa_bialego{1..n};  # Minimalny procent mięsa białego w kotletach
param mieso_biale{1..n};         # Ilość mięsa białego z indyka (kg)
param mieso_ciemne{1..n};        # Ilość mięsa ciemnego z indyka (kg)

# Zmienne decyzyjne
var kg_kotlety{i in 1..n} >= 0, <= limit_kotlety[i], integer;   # Liczba kilogramów kotletów do wyprodukowania
var liczba_indykow{i in 1..n} >= 0, integer;                   	# Liczba zakupionych indyków

# Funkcja celu - zmaksymalizowanie zysku (przychód ze sprzedaży - koszt zakupu indyków)
maximize zysk: sum{i in 1..n} kg_kotlety[i] * cena_kotlet[i] - sum{i in 1..n} liczba_indykow[i] * koszt_indyk[i];

# Ograniczenia
o_mieso_biale: sum{i in 1..n} liczba_indykow[i] * mieso_biale[i] >= sum{i in 1..n} kg_kotlety[i] * proc_miesa_bialego[i]; 
o_mieso_ciemne: sum{i in 1..n} liczba_indykow[i] * mieso_ciemne[i] >= sum{i in 1..n} kg_kotlety[i] * (1 - proc_miesa_bialego[i]);

data;
param n := 2;
param limit_kotlety := 1 50 2 30;
param cena_kotlet := 1 8 2 6;
param koszt_indyk := 1 10 2 8;
param proc_miesa_bialego := 1 0.7 2 0.5;
param mieso_biale := 1 3 2 1.5;
param mieso_ciemne := 1 2 2 4;

solve;
display zysk, kg_kotlety, liczba_indykow;
# Wynik: zysk = 410
#    kg_kotlety   liczba_indykow
# 1    50         17
# 2    30          0

end;