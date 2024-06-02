option solver cplex;
reset;

# Parametry
param typ > 0, integer;				# Liczba dostępnych typów kotletów
param limit_kotlety{1..typ};		# Limit sprzedaży kotletów (kg) dla każdego typu
param cena_kotlet{1..typ};			# Cena sprzedaży kotletów ($ za kg) dla każdego typu
param koszt_indyk{1..typ};			# Koszt kupna indyków ($ za sztukę) dla każdego typu
param proc_miesa_bialego{1..typ};	# Minimalny procent mięsa białego w kotletach dla każdego typu
param mieso_biale{1..typ};			# Ilość mięsa białego z indyka (kg)  dla każdego typu
param mieso_ciemne{1..typ};			# Ilość mięsa ciemnego z indyka (kg) dla każdego typu

# Zmienne decyzyjne
# Liczba kilogramów kotletów do wyprodukowania dla każdego typu, ograniczona przez limit sprzedaży.
var kg_kotlety{i in 1..typ} >= 0, <= limit_kotlety[i], integer;
 # Liczba zakupionych indyków dla każdego typu.
var liczba_indykow{i in 1..typ} >= 0, integer;        

# Funkcja celu - Zmaksymalizowanie zysku (przychód ze sprzedaży - koszt zakupu indyków) Przychód ze sprzedaży kotletów oblicza się mnożąc liczbę kilogramów kotletów każdego typu przez ich cenę, Koszt zakupu indyków oblicza się mnożąc liczbę indyków każdego typu przez ich koszt.
maximize zysk: sum{i in 1..typ} kg_kotlety[i] * cena_kotlet[i] - sum{i in 1..typ} liczba_indykow[i] * koszt_indyk[i];

# Ograniczenia - Ograniczenie minimalnej zawartości mięsa białego i ciemnego w kotletach. 
# Wymagana ilość mięsa białego musi być większa lub równa sumie ilości mięsa białego w kotletach każdego typu.
o_mieso_biale: sum{i in 1..typ} liczba_indykow[i] * mieso_biale[i] >= sum{i in 1..typ} kg_kotlety[i] * proc_miesa_bialego[i];
# Wymagana ilość mięsa ciemnego musi być większa lub równa sumie ilości mięsa ciemnego w kotletach każdego typu. 
o_mieso_ciemne: sum{i in 1..typ} liczba_indykow[i] * mieso_ciemne[i] >= sum{i in 1..typ} kg_kotlety[i] * (1 - proc_miesa_bialego[i]);

data;
param typ := 2;
param: limit_kotlety cena_kotlet koszt_indyk proc_miesa_bialego mieso_biale mieso_ciemne :=	1 50 8 10 0.7 3 2 2 30 6 8 0.5 1.5 4;

solve;
display zysk, kg_kotlety, liczba_indykow;
end;