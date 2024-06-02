option solver cplex;
reset;

# Parametry
set fabryki; # Zbiór fabryk
set odbiorcy; # Zbiór odbiorców
param calkowita_podaz; # Całkowita podaż
param popyt{odbiorcy}; # Popyt odbiorców
param koszty_transportu{fabryki, odbiorcy}; # Koszty transportu
param koszty_stale{fabryki}; # Koszty stałe uruchomienia fabryk
param minimalna_produkcja; # Minimalna produkcja
param M := calkowita_podaz * card(fabryki); # Duża stała równa całkowitej podaży

# Zmienne decyzyjne
# Liczba produktów przewożonych z fabryk do odbiorców
var ilosc_przewozona{fabryki, odbiorcy} >= 0 integer;
# Binarna zmienna określająca czy fabryka jest uruchomiona	
var fabryka_uruchomiona{fabryki} binary;				

# Funkcja celu -  Minimalizuje łączne koszty transportu i koszty stałe uruchomienia fabryk. 
# Sumuje ona koszty transportu dla każdej pary fabryka-odbiorca, pomnożone przez liczbę przewożonych produktów z danej fabryki do danego odbiorcy,
# oraz sumuje koszty stałe uruchomienia fabryk, które są aktywowane, tj. dla których binarna zmienna fabryka_uruchomiona ma wartość 1.
minimize koszty_transportu_min: sum{i in fabryki, j in odbiorcy} koszty_transportu[i,j] * ilosc_przewozona[i,j] + 
								sum{i in fabryki} koszty_stale[i] * fabryka_uruchomiona[i];

# Ograniczenia
# Ogranicza podaż z każdej fabryki do całkowitej podaży.
o_podazy{i in fabryki}: sum{j in odbiorcy} ilosc_przewozona[i,j] <= calkowita_podaz;  
 # Zapewnia, że popyt odbiorców na produkty jest zaspokojony. 
o_popytu{j in odbiorcy}: sum{i in fabryki} ilosc_przewozona[i,j] >= popyt[j];
# Powiązujące ilość przewiezionych produktów z uruchomieniem fabryki, zapewniające, że jeśli fabryka jest uruchomiona, to przewozi co najmniej jednostkę produktu.
o_bin_1{i in fabryki}: M * fabryka_uruchomiona[i] >= sum{j in odbiorcy} ilosc_przewozona[i,j];
 # Zapewnia, że jeśli fabryka jest uruchomiona, to ilość przewiezionych produktów nie przekroczy ogromnej stałej M.
o_bin_2{i in fabryki}: sum{j in odbiorcy} ilosc_przewozona[i,j] <= M * fabryka_uruchomiona[i]; 	
# Gwarantuje, że jeśli fabryka nie jest uruchomiona, to produkcja w niej będzie mniejsza niż minimalna produkcja.
o_min{i in fabryki}: sum{j in odbiorcy} -ilosc_przewozona[i,j] + minimalna_produkcja <= M * (1 - fabryka_uruchomiona[i]);

data;
param: fabryki: koszty_stale := F1 300 F2 250 F3 400;
param: odbiorcy: popyt := O1 100 O2 80 O3 50;
param calkowita_podaz := 200;
param minimalna_produkcja := 100;
param koszty_transportu:  O1 O2 O3:=F1 1 5 2 F2 7 4 2 F3 5 3 6;

solve;
display koszty_transportu_min, ilosc_przewozona;
end;