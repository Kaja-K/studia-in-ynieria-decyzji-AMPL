option solver cplex;
reset;

# Parametry
param przedmioty;										# Liczba przedmiotów
param maksymalna_waga;									# Maksymalna waga paczki
param wagi_przedmiotow{i in 1..przedmioty};				# Wagi przedmiotów
param wartosci_przedmiotow{i in 1..przedmioty};			# Wartości przedmiotów
set para_L1 within 1..przedmioty cross 1..przedmioty;	# Zbiór par przedmiotów z L1
set para_L2 within 1..przedmioty cross 1..przedmioty;	# Zbiór par przedmiotów z L2
set para_L3 within 1..przedmioty cross 1..przedmioty;	# Zbiór par przedmiotów z L3

# Zmienna decyzyjna - Binarna zmienna decyzyjna, która określa, czy przedmiot i zostanie zabrany w paczce.
var czy_zabrac_przedmiot{i in 1..przedmioty} binary; 

# Funkcja celu -  Maksymalizacja sumy wartości przedmiotów, które zostaną zabrane w paczce. Każdy przedmiot może mieć różną wartość, więc chcemy wybrać te przedmioty, które łącznie dadzą nam jak największą sumę wartości.
maximize suma_wartosci: sum{i in 1..przedmioty} czy_zabrac_przedmiot[i] * wartosci_przedmiotow[i];  

# Ograniczenia 
# Suma wag wszystkich wybranych przedmiotów nie może przekroczyć maksymalnej wagi paczki. Ma to zapobiec sytuacji, w której paczka byłaby zbyt ciężka.
o_wagi: sum{i in 1..przedmioty} czy_zabrac_przedmiot[i] * wagi_przedmiotow[i] <= maksymalna_waga;   
# Każda para przedmiotów z L1 może zawierać tylko jeden z tych przedmiotów w paczce.
o_para_L1{(i,j) in para_L1}: czy_zabrac_przedmiot[i] + czy_zabrac_przedmiot[j] <= 1; 
# Każda para przedmiotów z L2 musi zawierać przynajmniej jeden z tych przedmiotów w paczce.		
o_para_L2{(i,j) in para_L2}: czy_zabrac_przedmiot[i] + czy_zabrac_przedmiot[j] >= 1; 
# Dla każdej pary przedmiotów z L3, jeśli jeden z tych przedmiotów zostanie wybrany do paczki, drugi musi również zostać wybrany lub już nie zostać wybrany. 		
o_para_L3{(i,j) in para_L3}: czy_zabrac_przedmiot[i] <= czy_zabrac_przedmiot[j]; 				

data;
set para_L1:= 2 5 3 4 7 11 10 11;
set para_L2:= 5 8 1 14 13 20 6 3;
set para_L3:= 2 19 4 15;
param przedmioty:=20;
param maksymalna_waga:= 45;
param wagi_przedmiotow:= 1 7 2 4 3 8 4 1 5 9 6 7 7 8 8 1 9 10 10 4 11 5 12 5 13 5 14 2 15 8 16 7 17 9 18 2 19 6 20 4;
param wartosci_przedmiotow:=1 7 2 2 3 10 4 2 5 5 6 4 7 5 8 3 9 9 10 6 11 7 12 7 13 3 14 1 15 10 16 9 17 8 18 6 19 1 20 8;

solve;
display suma_wartosci, czy_zabrac_przedmiot;
end;