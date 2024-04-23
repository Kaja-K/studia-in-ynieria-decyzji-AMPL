option solver cplex;
reset;

# Parametry
param liczba_przedmiotow;  												# Liczba przedmiotów
param maksymalna_waga_plecaka;  										# Maksymalna waga plecaka
param wagi_przedmiotow{i in 1..liczba_przedmiotow};  					# Wagi przedmiotów
param wartosci_przedmiotow{i in 1..liczba_przedmiotow}; 				# Wartości przedmiotów
set para_L1 within 1..liczba_przedmiotow cross 1..liczba_przedmiotow;  	# Zbiór par przedmiotów z L1
set para_L2 within 1..liczba_przedmiotow cross 1..liczba_przedmiotow;  	# Zbiór par przedmiotów z L2
set para_L3 within 1..liczba_przedmiotow cross 1..liczba_przedmiotow;  	# Zbiór par przedmiotów z L3

# Zmienne decyzyjne - Czy przedmiot i zostanie zabrany
var czy_zabrac_przedmiot{i in 1..liczba_przedmiotow} binary; 

# Funkcja celu -  Maksymalizacja sumy wartości zabranych przedmiotów
maximize suma_wartosci: sum{i in 1..liczba_przedmiotow} czy_zabrac_przedmiot[i] * wartosci_przedmiotow[i];  

# Ograniczenia 
o_wagi: sum{i in 1..liczba_przedmiotow} czy_zabrac_przedmiot[i] * wagi_przedmiotow[i] <= maksymalna_waga_plecaka;   # Ograniczenie wagi plecaka
o_L1{(i,j) in para_L1}: czy_zabrac_przedmiot[i] + czy_zabrac_przedmiot[j] <= 1;  									# Ograniczenie dla par przedmiotów z L1
o_L2{(i,j) in para_L2}: czy_zabrac_przedmiot[i] + czy_zabrac_przedmiot[j] >= 1;  									# Ograniczenie dla par przedmiotów z L2
o_L3{(i,j) in para_L3}: czy_zabrac_przedmiot[i] <= czy_zabrac_przedmiot[j];  	 									# Ograniczenie dla par przedmiotów z L3

# Dane 
data;
param liczba_przedmiotow:=20;
param maksymalna_waga_plecaka:=45;
param wagi_przedmiotow:= 1 7 2 4 3 8 4 1 5 9 6 7 7 8 8 1 9 10 10 4 11 5 12 5 13 5 14 2 15 8 16 7 17 9 18 2 19 6 20 4;
param wartosci_przedmiotow:= 1 7 2 2 3 10 4 2 5 5 6 4 7 5 8 3 9 9 10 6 11 7 12 7 13 3 14 1 15 10 16 9 17 8 18 6 19 1 20 8;
set para_L1:= 2 5 3 4 7 11 10 11;
set para_L2:= 5 8 1 14 13 20 6 3;
set para_L3:= 2 19 4 15;

solve;
expand;
display suma_wartosci, czy_zabrac_przedmiot;
# Wynik: suma_wartosci = 61
# czy_zabrac_przedmiot
#  1  1
#  2  0
#  3  1
#  4  0
#  5  0
#  6  0
#  7  0
#  8  1
#  9  0
# 10  0
# 11  0
# 12  1
# 13  0
# 14  1
# 15  1
# 16  1
# 17  0
# 18  1
# 19  0
# 20  1

end;