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
minimize koszt: sum{f in fabryki, o in odbiorcy} koszty_transportu[f,o] * ilosc_przewozona[f,o] + 
				sum{f in fabryki} koszty_stale[f] * fabryka_uruchomiona[f];

# Ograniczenia
# Ogranicza podaż z każdej fabryki do całkowitej podaży.
o_podazy{f in fabryki}: sum{o in odbiorcy} ilosc_przewozona[f,o] <= calkowita_podaz;  
 # Zapewnia, że popyt odbiorców na produkty jest zaspokojony. 
o_popytu{o in odbiorcy}: sum{f in fabryki} ilosc_przewozona[f,o] >= popyt[o];
# Powiązujące ilość przewiezionych produktów z uruchomieniem fabryki, zapewniające, że jeśli fabryka jest uruchomiona, to przewozi co najmniej jednostkę produktu.
o_bin_1{f in fabryki}: M * fabryka_uruchomiona[f] >= sum{o in odbiorcy} ilosc_przewozona[f,o];
 # Zapewnia, że jeśli fabryka jest uruchomiona, to ilość przewiezionych produktów nie przekroczy ogromnej stałej M.
o_bin_2{f in fabryki}: sum{o in odbiorcy} ilosc_przewozona[f,o] <= M * fabryka_uruchomiona[f]; 	
# Gwarantuje, że jeśli fabryka nie jest uruchomiona, to produkcja w niej będzie mniejsza niż minimalna produkcja.
o_min{f in fabryki}: sum{o in odbiorcy} -ilosc_przewozona[f,o] + minimalna_produkcja <= M * (1 - fabryka_uruchomiona[f]);

data;
param: fabryki: koszty_stale := F1 300 F2 250 F3 400;
param: odbiorcy: popyt := O1 100 O2 80 O3 50;
param calkowita_podaz := 200;
param minimalna_produkcja := 100;
param koszty_transportu:  O1 O2 O3:=F1 1 5 2 F2 7 4 2 F3 5 3 6;

solve;
display koszt, ilosc_przewozona;
end;