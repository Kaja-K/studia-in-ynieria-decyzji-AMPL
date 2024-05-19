option solver cplex;
reset;

# Parametry
param n;  								# Liczba przedmiotów
param maksymalna_waga_paczki;  			# Maksymalna waga paczki
param wagi_przedmiotow{i in 1..n};  	# Wagi przedmiotów
param wartosci_przedmiotow{i in 1..n}; 	# Wartości przedmiotów
set para_L1 within 1..n cross 1..n;  	# Zbiór par przedmiotów z L1
set para_L2 within 1..n cross 1..n;  	# Zbiór par przedmiotów z L2
set para_L3 within 1..n cross 1..n;  	# Zbiór par przedmiotów z L3

# Zmienna decyzyjna - Czy przedmiot i zostanie zabrany
var czy_zabrac_przedmiot{i in 1..n} binary; 

# Funkcja celu -  Maksymalizacja sumy wartości zabranych przedmiotów
maximize suma_wartosci: sum{i in 1..n} czy_zabrac_przedmiot[i] * wartosci_przedmiotow[i];  

# Ograniczenia 
o_wagi: sum{i in 1..n} czy_zabrac_przedmiot[i] * wagi_przedmiotow[i] <= maksymalna_waga_paczki;   	# Waga paczki
o_L1{(i,j) in para_L1}: czy_zabrac_przedmiot[i] + czy_zabrac_przedmiot[j] <= 1;  					# Pary przedmiotów z L1
o_L2{(i,j) in para_L2}: czy_zabrac_przedmiot[i] + czy_zabrac_przedmiot[j] >= 1;  					# Pary przedmiotów z L2
o_L3{(i,j) in para_L3}: czy_zabrac_przedmiot[i] <= czy_zabrac_przedmiot[j];  	 					# Pary przedmiotów z L3

data;
param n:=20;
param maksymalna_waga_paczki:=45;
param wagi_przedmiotow:= 1 7 2 4 3 8 4 1 5 9 6 7 7 8 8 1 9 10 10 4 11 5 12 5 13 5 14 2 15 8 16 7 17 9 18 2 19 6 20 4;
param wartosci_przedmiotow:= 1 7 2 2 3 10 4 2 5 5 6 4 7 5 8 3 9 9 10 6 11 7 12 7 13 3 14 1 15 10 16 9 17 8 18 6 19 1 20 8;
set para_L1:= 2 5 3 4 7 11 10 11;
set para_L2:= 5 8 1 14 13 20 6 3;
set para_L3:= 2 19 4 15;

solve;
display suma_wartosci, czy_zabrac_przedmiot;
# Wynik: suma_wartosci = 61
# czy_zabrac_przedmiot
#  1  1
#  3  1
#  8  1
# 12  1
# 14  1
# 15  1
# 16  1
# 18  1
# 20  1

end;