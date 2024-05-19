option solver cplex;
reset;

# Parametry
set f;									# Zbiór fabryk
set o;									# Zbiór odbiorców
param całkowita_podaz;					# Całkowita podaż
param popyt{o};							# Popyt odbiorców
param koszty_transportu{f,o};			# Koszty transportu
param koszty_stale{f};					# Koszty stałe uruchomienia fabryk
param minimalna_produkcja;				# Minimalna produkcja
param M := całkowita_podaz * card(f);	# Duża stała równa całkowitej podaży

# Zmienne decyzyjne
var ilosc_przewozona{f,o} >= 0 integer;	# Liczba produktów przewożonych z fabryk do odbiorców
var fabryka_uruchomiona{f} binary;		# Binarna zmienna określająca czy fabryka jest uruchomiona

# Funkcja celu
minimize koszty_transportu_min: sum{i in f, j in o} koszty_transportu[i,j] * ilosc_przewozona[i,j] + 
								sum{i in f} koszty_stale[i] * fabryka_uruchomiona[i];
# Ograniczenia
o_podazy{i in f}: sum{j in o} ilosc_przewozona[i,j] <= całkowita_podaz;    									# Podaż z fabryk
o_popytu{j in o}: sum{i in f} ilosc_przewozona[i,j] >= popyt[j];   											# Popyt odbiorców
o_bin_1{i in f}: M * fabryka_uruchomiona[i] >= sum{j in o} ilosc_przewozona[i,j];							# Powiązanie z binarną zmienną fabryka_uruchomiona
o_bin_2{i in f}: sum{j in o} ilosc_przewozona[i,j] <= M * fabryka_uruchomiona[i]; 
o_min{i in f}: sum{j in o} -ilosc_przewozona[i,j] + minimalna_produkcja <= M * (1 - fabryka_uruchomiona[i]);# Minimalna produkcja przy nieuruchomionych fabrykach

data;
param: f: koszty_stale := F1 300 F2 250 F3 400;
param: o: popyt := O1 100 O2 80 O3 50;
param całkowita_podaz := 200;
param minimalna_produkcja := 100;
param koszty_transportu: O1  O2  O3 := F1  1   5   2 F2  7   4   2 F3  5   3   6;

solve;
display koszty_transportu_min, ilosc_przewozona;
# Wynik: koszty_transportu_min = 1070
# ilosc_przewozona
# F1 O1   100
# F1 O3    30
# F2 O2    80
# F2 O3    20

end;