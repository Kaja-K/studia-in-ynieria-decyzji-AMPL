option solver cplex;
reset;

# Parametry:
set Wyroby;  										# Zbiór wyrobów
set Komponenty;  									# Zbiór komponentów
param ilosc_komponentow{Wyroby, Komponenty} >= 0;  	# Liczba jednostek komponentu j potrzebna do produkcji wyrobu i
param cena_wyrobu{Wyroby} >= 0;  					# Cena jednostkowa wyrobu i
param ilosc_zapasow{Komponenty} >= 0;  				# Ilość zapasów komponentu j
param cena_komponentu{Komponenty} >= 0;  			# Cena jednostkowa komponentu j

# Zmienne decyzyjne - Ilość wyprodukowanych wyrobów
var ilosc_wyrobow{Wyroby} >= 0;  				

# Funkcja celu:
maximize zysk: sum{i in Wyroby} ilosc_wyrobow[i] * cena_wyrobu[i];  # Maksymalizacja całkowitego zysku

# Ograniczenie:
o_komponentow{j in Komponenty}: sum{i in Wyroby} ilosc_komponentow[i,j] * ilosc_wyrobow[i] <= ilosc_zapasow[j];  # Ograniczenie ilości komponentów

# Dane:
data;
set Wyroby := W1, W2, W3;
set Komponenty := C1, C2, C3;
param ilosc_komponentow: C1 C2 C3 := W1 2 1 0 W2 1 2 3 W3 3 1 1;
param cena_wyrobu := W1 20 W2 30 W3 25;
param ilosc_zapasow := C1 300 C2 150 C3 200;
param cena_komponentu := C1 10 C2 15 C3 12;

solve;

display ilosc_wyrobow;
display zysk;

for {j in Komponenty} {
    display "Komponent", j;
    display "Aktualny zapas:", ilosc_zapasow[j];
    display "Maksymalna dopuszczalna cena:", cena_komponentu[j] + sum{i in Wyroby} (ilosc_komponentow[i,j] * ilosc_wyrobow[i]) / ilosc_zapasow[j];
}
