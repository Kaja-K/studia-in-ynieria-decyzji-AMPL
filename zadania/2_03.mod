option solver cplex;
reset;

# Deklaracja parametrów
param projekty > 0, integer; 				# Liczba projektów
param koszt{1..projekty}; 					# Koszt każdego z projektów
param przychod{1..projekty}; 				# Przychód z każdego z projektów
param ukonczenie{1..projekty} >=0, <=1; 	# Informacja czy projekt został ukończony
param lata > 0, integer; 					# Liczba lat
param budzet{1..lata}; 						# Budżet na każdy rok
param inwestowanie{1..lata, 1..projekty}; 	# Możliwość inwestowania w projekty w każdym roku

# Zmienna decyzyjna - zainwestowane pieniądze w projekt i w roku j
var pieniadze{j in 1..lata, i in 1..projekty} >= 0; 

# Funkcja celu - maksymalizacja zysku
maximize zysk: sum{i in 1..projekty} sum{j in 2..lata} (przychod[i] * (pieniadze[j-1,i] / koszt[i]) * (lata-j+1));
 
# Ograniczenia
subject to
o_budzetowe{j in 1..lata}: sum{i in 1..projekty} pieniadze[j,i] <= budzet[j]; 						# Maksymalny budżet na rok
o_ukonczenie{i in 1..projekty}: ukonczenie[i] <= (sum{j in 1..lata} pieniadze[j,i]) / koszt[i] <= 1;# Ukonczenie projektu w roku
o_inwestowanie{j in 1..lata, i in 1..projekty}: pieniadze[j,i] = pieniadze[j,i] * inwestowanie[j,i];# Inwestowanie w kolejne lata
 
# Dane
data;
param projekty:=4;
param koszt:= [1] 5 [2] 8 [3] 15 [4] 1.2;
param przychod:= [1] 0.05 [2] 0.07 [3] 0.15 [4] 0.02;
param ukonczenie:= [1] 1 [2] 0.25 [3] 0.25 [4] 1;
param lata:=5;
param budzet:= [1] 3 [2] 6 [3] 7 [4] 7 [5] 7;
param inwestowanie:= 1 1 1 1 2 0 1 3 1 1 4 0 2 1 1 2 2 1 2 3 1 2 4 0 3 1 1 3 2 1 3 3 1 3 4 1 4 1 0 4 2 1 4 3 1 4 4 1 5 1 0 5 2 1 5 3 1 5 4 0;

solve;
display pieniadze, zysk;
# Wynik:
# W trzecim roku zainwestowano 0.8 jednostek pieniędzy w projekt 3.
# W trzecim roku zainwestowano 1.2 jednostek pieniędzy w projekt 4.
# W czwartym roku zainwestowano 1.8 jednostek pieniędzy w projekt 2.
# W czwartym roku zainwestowano 5.2 jednostek pieniędzy w projekt 3.
# W piątym roku zainwestowano 0.2 jednostek pieniędzy w projekt 2. 
# zysk = 0.52375

end;
