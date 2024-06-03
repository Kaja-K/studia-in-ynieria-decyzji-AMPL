option solver cplex;
reset;

# Parametry
set miasta; # Liczba miast
set spalarnie; # Liczba spalarni
set wysypiska; # Liczba wysypisk
param odpady{miasta}; # Ilość odpadów w każdym z miast
param limit_spalania{spalarnie}; # Limit spalania w każdej z spalarni
param koszt_spalania{spalarnie}; # koszt spalania w każdej z spalarni
param wsp_spalania; # Współczynnik spalania odpadów
param limit_wysypiska{wysypiska}; # Limit ilości odpadów składowanych w każdym z wysypisk
param koszt_transportu; # koszt transportu jednej tony odpadów
param odleglosc_1{miasta, spalarnie}; # Odległość między miastami a spalarniami
param odleglosc_2{spalarnie, wysypiska}; # Odległość między spalarniami a wysypiskami

# Zmienne decyzyjne
# Ilość ton odpadów przewieziona z miasta i do spalarni j
var ilosc_odpadow{miasta, spalarnie} >= 0; 
# Ilość ton popiołu przewieziona ze spalarni j do wysypiska k
var ilosc_popiolu{spalarnie, wysypiska} >= 0; 

# Funkcja celu - Minimalizacja całkowitego kosztu
minimize koszt: sum{m in miasta, s in spalarnie} koszt_transportu * odleglosc_1[m,s] * ilosc_odpadow[m,s] + 
                sum{m in miasta, s in spalarnie} koszt_spalania[s] * ilosc_odpadow[m,s] + 
                sum{s in spalarnie, w in wysypiska} koszt_transportu * odleglosc_2[s,w] * ilosc_popiolu[s,w]; 

# Ograniczenia
# Określa, że ilość odpadów w każdym z miast musi być równa ilości odpadów wyprodukowanych w tym mieście.
o_limit_odpady{m in miasta}: sum{s in spalarnie} ilosc_odpadow[m,s] = odpady[m]; 	
# Nakłada limit na ilość odpadów, które mogą być spalane w każdej z spalarni.					
o_limit_spalarnie{s in spalarnie}: sum{m in miasta} ilosc_odpadow[m,s] <= limit_spalania[s];
# Określa limit ilości popiołu, który może być składowany w każdym z wysypisk. 							
o_limit_wysypiska{w in wysypiska}: sum{s in spalarnie} ilosc_popiolu[s,w] <= limit_wysypiska[w];
# Wymusza, że ilość popiołu wytwarzana w każdej spalarni musi być równa ilości odpadów, które zostały spalone.			
o_spalanie{s in spalarnie}: sum{m in miasta} ilosc_odpadow[m,s] * wsp_spalania = sum{w in wysypiska} ilosc_popiolu[s,w];

data;
param wsp_spalania := 0.3; 
param koszt_transportu := 3; 
param: miasta: odpady:= 'Miasto-1' 1500 'Miasto-2' 1400;
param: spalarnie: limit_spalania, koszt_spalania:= 'Spalarnia-A' 1500 40 'Spalarnia-B' 1500 30;
param: wysypiska: limit_wysypiska:= 'Wysypisko-1' 500 'Wysypisko-2' 500;
param odleglosc_1: 'Spalarnia-A' 'Spalarnia-B':='Miasto-1' 30 5 'Miasto-2' 36 42;
param odleglosc_2: 'Wysypisko-1' 'Wysypisko-2':= 'Spalarnia-A' 5 8 'Spalarnia-B' 9 6;

solve;
display ilosc_odpadow, ilosc_popiolu, koszt;
end;