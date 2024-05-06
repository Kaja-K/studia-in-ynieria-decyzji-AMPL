option solver cplex;
reset;

# Dane
set Fabryki;								# Zbiór fabryk
set Odbiorcy;								# Zbiór odbiorców
param całkowita_podaż;						# Całkowita podaż
param popyt{Odbiorcy};						# Popyt odbiorców
param koszty_transportu{Fabryki,Odbiorcy};	# Koszty transportu
param koszty_stałe{Fabryki};				# Koszty stałe uruchomienia fabryk
param minimalna_produkcja;					# Minimalna produkcja
param M := całkowita_podaż * card(Fabryki);	# Duża stała równa całkowitej podaży

# Zmienne decyzyjne
var ilość_przewożona{Fabryki,Odbiorcy} >= 0 integer;	# Liczba produktów przewożonych z fabryk do odbiorców
var fabryka_uruchomiona{Fabryki} binary;				# Binarna zmienna określająca czy fabryka jest uruchomiona

# Funkcja celu
minimize koszty_transportu_min: sum{i in Fabryki, j in Odbiorcy} koszty_transportu[i,j] * ilość_przewożona[i,j] + sum{i in Fabryki} koszty_stałe[i] * fabryka_uruchomiona[i];

# Ograniczenia
o_podazy{i in Fabryki}: sum{j in Odbiorcy} ilość_przewożona[i,j] <= całkowita_podaż;    								# Podaży z fabryk
o_popytu{j in Odbiorcy}: sum{i in Fabryki} ilość_przewożona[i,j] >= popyt[j];   										# Popytu odbiorców
o_bin_1{i in Fabryki}: M * fabryka_uruchomiona[i] >= sum{j in Odbiorcy} ilość_przewożona[i,j];							# Związane z binarną zmienną fabryka_uruchomiona
o_bin_2{i in Fabryki}: sum{j in Odbiorcy} ilość_przewożona[i,j] <= M * fabryka_uruchomiona[i]; 
o_min{i in Fabryki}: sum{j in Odbiorcy} -ilość_przewożona[i,j] + minimalna_produkcja <= M * (1 - fabryka_uruchomiona[i]);# Minimalnej produkcji przy nieuruchomionych fabrykach

# Dane
data;
param: Fabryki: koszty_stałe := F1 300 F2 250 F3 400;
param całkowita_podaż := 200;
param: Odbiorcy: popyt := O1 100 O2 80 O3 50;
param minimalna_produkcja := 100;
param koszty_transportu: O1  O2  O3 := F1  1   5   2 F2  7   4   2 F3  5   3   6;

solve;
display ilość_przewożona, fabryka_uruchomiona, koszty_transportu_min;
# Wynik: koszty_transportu_min = 1070
# ilość_przewożona
# F1 O1   100
# F1 O2     0
# F1 O3    30
# F2 O1     0
# F2 O2    80
# F2 O3    20
# F3 O1     0
# F3 O2     0
# F3 O3     0

# fabryka_uruchomiona
# F1  1
# F2  1
# F3  0

end;
