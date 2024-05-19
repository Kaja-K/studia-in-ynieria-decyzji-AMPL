option solver cplex;
reset;

# Parametry
param m > 0, integer; 							# Liczba miast produkujących odpady
param s > 0, integer; 							# Liczba spalarni odpadów
param w > 0, integer; 							# Liczba wysypisk dla popiołu
param koszt_transportu_ms{i in 1..m, j in 1..s};# Koszt transportu odpadów z miasta i do spalarni j (w tonach)
param koszt_transportu_sw{j in 1..s, k in 1..w};# Koszt transportu popiołu ze spalarni j do wysypiska k (w tonach)
param koszt_spalania{j in 1..s}; 				# Koszt spalania jednej tony odpadów w każdej spalarni (w tonach)
param ilosc_popiolu{j in 1..s}; 				# Ilość popiołu wytworzonego przez każdą spalarnię (w tonach)
param limit_spalania{j in 1..s}; 				# Limit spalania odpadów w każdej spalarni (w tonach)
param limit_wysypiska{k in 1..w}; 				# Limit ilości popiołu składowanego w każdym wysypisku (w tonach)
param ilosc_odpadow{1..m}; 						# Ilość odpadów wytworzonych w każdym z miast (w tonach)
param koszt_transportu; 						# Koszt transportu jednej tony odpadów lub popiołu ($/tona)

# Zmienne decyzyjne
var ilosc_odpadow_ms{i in 1..m, j in 1..s} >= 0;# Ilość ton odpadów transportowanych z miasta i do spalarni j
var ilosc_popiolu_sw{j in 1..s, k in 1..w} >= 0;# Ilość ton popiołu transportowanych ze spalarni j do wysypiska k

# Funkcja celu - minimalizacja kosztu transportu
minimize koszt_transportu_calkowity: 
		sum{i in 1..m, j in 1..s} koszt_transportu_ms[i,j] * koszt_transportu * ilosc_odpadow_ms[i,j] +  	# Koszt transportu odpadów z miast do spalarni
		sum{i in 1..m, j in 1..s} koszt_spalania[j] * ilosc_odpadow_ms[i,j] +             					# Koszt spalania odpadów w poszczególnych spalarniach
		sum{j in 1..s, k in 1..w} koszt_transportu_sw[j,k] * koszt_transportu * ilosc_popiolu_sw[j,k];  	# Koszt transportu popiołu ze spalarni do wysypiska

# Ograniczenia
o_limit_spalania{j in 1..s}: sum{i in 1..m} ilosc_odpadow_ms[i,j] <= limit_spalania[j];           				 		# Limit spalania w poszczególnych spalarniach
o_limit_wysypiska{k in 1..w}: sum{j in 1..s} ilosc_popiolu_sw[j,k] <= limit_wysypiska[k];   							# Limit składowania popiołu w wysypisku
o_popiol {j in 1..s}: sum{k in 1..w} ilosc_popiolu_sw[j,k] >= sum{i in 1..m} ilosc_popiolu[j] * ilosc_odpadow_ms[i,j]; 	# Wywóz popiołu z spalarni do wysypiska
o_odpady_miasta{i in 1..m}: sum{j in 1..s} ilosc_odpadow_ms[i,j] >= ilosc_odpadow[i];           						# Wywóz odpadów z miast

data;
param m := 2;
param s := 2; 
param w := 2;
param koszt_transportu_ms:= 1 1 30 1 2 5 2 1 36 2 2 42;
param koszt_transportu_sw:= 1 1 5 1 2 8 2 1 9 2 2 6;
param koszt_spalania:= 1 40 2 30;
param ilosc_popiolu:= 1 0.3 2 0.3;
param limit_spalania:= 1 1500 2 1500;
param limit_wysypiska:= 1 500 2 500;
param ilosc_odpadow:= 1 1500 2 1400;
param koszt_transportu:= 3;

solve;
display koszt_transportu_calkowity, ilosc_odpadow_ms, ilosc_popiolu_sw;
# Wynik: koszt_transportu_calkowity = 289100
#    ilosc_odpadow_ms ilosc_popiolu_sw 
# 1 1                  0                             420
# 1 2               1500                               0
# 2 1               1400                               0
# 2 2                  0                             450

end;