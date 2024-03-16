option solver cplex;
reset;

# Deklaracja parametrów
set miesiac;  							# Zbiór miesięcy
set lokata;  							# Zbiór lokat
param przychody{miesiac};  				# Przychody w każdym miesiącu
param rachunki{miesiac};  				# Rachunki do zapłacenia w każdym miesiącu
param stopa_odsetek{lokata};  			# Oprocentowanie każdej lokaty
param zwroty{lokata, miesiac, miesiac}; # Czy dana lokata osiąga zwrot w danym miesiącu

# Zmienna decyzyjna - Kwota zainwestowana w każdej lokacie w każdym miesiącu
var kwota{lokata, miesiac} >= 0;

# Funkcja celu - Maksymalizacja gotówki na koncie po wszystkich miesiącach
maximize gotowka: sum {j in miesiac} sum{k in lokata} kwota[k,j] * stopa_odsetek[k] * zwroty [k ,j, "kwi"];

# Ograniczenia 
subject to ograniczenia{ i in miesiac}: przychody[i] - rachunki[i] -  (sum{ j in lokata}  kwota[j,i]) + (sum{n in miesiac}  sum{k in lokata} (kwota[k,n]*stopa_odsetek[k]*zwroty[k,n,i])) = 0;
	
# Dane 
data;
set miesiac:= "sty" "lut" "mar" "kwi" ;
set lokata:= "1_mies" "2_mies" "3_mies" "4_mies";
param: przychody rachunki:= "sty" 900 600 "lut" 800 500 "mar" 300 500 "kwi" 300 250;
param stopa_odsetek := "1_mies" 1.001 "2_mies" 1.005 "3_mies" 1.01 "4_mies" 1.02;
param zwroty:= # Tworzy 64 linijki kombinacji [lokata, miesiac, miesiac] wartość zwrotu (0/1)
	[*,*,sty]: "sty" "lut" "mar" "kwi":= "1_mies" 0 0 0 0 "2_mies" 0 0 0 0 "3_mies" 0 0 0 0 "4_mies" 0 0 0 0 
	[*,*,lut]: "sty" "lut" "mar" "kwi":= "1_mies" 1 0 0 0 "2_mies" 0 0 0 0 "3_mies" 0 0 0 0 "4_mies" 0 0 0 0
	[*,*,mar]: "sty" "lut" "mar" "kwi":= "1_mies" 0 1 0 0 "2_mies" 1 0 0 0 "3_mies" 0 0 0 0 "4_mies" 0 0 0 0
	[*,*,kwi]: "sty" "lut" "mar" "kwi":= "1_mies" 0 0 1 0 "2_mies" 0 1 0 0 "3_mies" 1 0 0 0 "4_mies" 0 0 0 0;

solve;

display gotowka, {i in miesiac, j in lokata: kwota[j,i] <> 0} kwota[j,i];
#Wynik: gotowka = 403.701, kwi 4_mies = 453.701, lut 1_mies = 199.8 ,lut 2_mies = 100.2 ,sty 3_mies = 300

end;
