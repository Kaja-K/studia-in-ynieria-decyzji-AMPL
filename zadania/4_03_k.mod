option solver cplex;
reset;

# Parametry
param paczki; # Liczba paczek
param maksymalna_waga; # Maksymalna waga paczek na statku
param wagi_paczek{p1 in 1..paczki}; # Wagi paczek
param wartosci_paczek{p1 in 1..paczki}; # Wartości paczek
set para_L1 within 1..paczki cross 1..paczki; # Zbiór par paczek z L1
set para_L2 within 1..paczki cross 1..paczki; # Zbiór par paczek z L2
set para_L3 within 1..paczki cross 1..paczki; # Zbiór par paczek z L3

# Zmienna decyzyjna - Binarna zmienna decyzyjna, która określa, czy paczka i zostanie zabrana.
var czy_zabrac_paczke{p1 in 1..paczki} binary; 

# Funkcja celu -  Maksymalizacja sumy wartości paczek, które zostaną zabrane. Każda paczka może mieć różną wartość, więc chcemy wybrać te paczki, które łącznie dadzą nam jak największą sumę wartości.
maximize suma_wartosci: sum{p1 in 1..paczki} czy_zabrac_paczke[p1] * wartosci_paczek[p1];  

# Ograniczenia 
# Suma wag wszystkich wybranych paczek nie może przekroczyć możliwości załadunkowej statku.
o_wagi: sum{p1 in 1..paczki} czy_zabrac_paczke[p1] * wagi_paczek[p1] <= maksymalna_waga;   
# Każda para paczek z L1 może zawierać tylko jeden z tych przedmiotów w paczce.
o_para_L1{(p1,p2) in para_L1}: czy_zabrac_paczke[p1] + czy_zabrac_paczke[p2] <= 1; 
# Każda para paczek z L2 musi zawierać przynajmniej jeden z tych przedmiotów w paczce.		
o_para_L2{(p1,p2) in para_L2}: czy_zabrac_paczke[p1] + czy_zabrac_paczke[p2] >= 1; 
# Dla każdej pary paczek z L3, jeśli jedna z tych paczek zostanie zabrana, druga musi również zostać zabrana lub nie może zostać zabrana w ogóle. 		
o_para_L3{(p1,p2) in para_L3}: czy_zabrac_paczke[p1] <= czy_zabrac_paczke[p2]; 				

data;
set para_L1:= 2 5 3 4 7 11 10 11;
set para_L2:= 5 8 1 14 13 20 6 3;
set para_L3:= 2 19 4 15;
param paczki:=20;
param maksymalna_waga:= 45;
param wagi_paczek:= 1 7 2 4 3 8 4 1 5 9 6 7 7 8 8 1 9 10 10 4 11 5 12 5 13 5 14 2 15 8 16 7 17 9 18 2 19 6 20 4;
param wartosci_paczek:=1 7 2 2 3 10 4 2 5 5 6 4 7 5 8 3 9 9 10 6 11 7 12 7 13 3 14 1 15 10 16 9 17 8 18 6 19 1 20 8;

solve;
display suma_wartosci, czy_zabrac_paczke;
end;