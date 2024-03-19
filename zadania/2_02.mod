option solver cplex;
reset;

# Deklaracja parametrów
param miesiac;                      # Zbiór miesięcy inwestowania
param procent{1..miesiac};          # procent z lokat 1+procent
param przychody{1..miesiac};        # Przychody w każdym miesiącu
param rachunki{1..miesiac};         # Rachunki do zapłacenia w każdym miesiącu

# Zmienne decyzyjne - lokaty
var lokata_1{1..miesiac} >= 0;       # lokaty miesięczne w okresie 1 - miesiąc
var lokata_2{1..miesiac} >= 0;       # lokaty dwu-miesięczne w okresie 1 - miesiąc
var lokata_3{1..miesiac} >= 0;       # lokaty trzy-miesięczne w okresie 1 - miesiąc
var lokata_4{1..miesiac} >= 0;       # lokaty cztero-miesięczne w okresie 1 - miesiąc

# Funkcja celu - gotówka na koniec kazdego miesiąca
maximize zysk: procent[1]*lokata_1[miesiac] + procent[2]*lokata_2[miesiac-1] + procent[3]*lokata_3[miesiac-2] + procent[4]*lokata_4[miesiac-3];

# Ograniczenia gotóweka na koniec każdego miesiąca
subject to o{i in 1..miesiac}: przychody[i] 
							+ if i>1 then procent[1]*lokata_1[i-1]
							+ if i>2 then procent[2]*lokata_2[i-2]
							+ if i>3 then procent[3]*lokata_3[i-3]
							+ if i>4 then procent[4]*lokata_4[i-4]
	 = rachunki[i]+lokata_1[i]+lokata_2[i]+lokata_3[i]+lokata_4[i];

# Dane 
data;
param miesiac := 4;
param procent := 1 1.001 2 1.005 3 1.01 4 1.02;
param przychody := 1 900 2 800 3 300 4 300;
param rachunki := 1 600 2 500 3 500 4 250;

solve;
display lokata_1, lokata_2, lokata_3, lokata_4, zysk;
# Wynik:  	
#		lokata_1 lokata_2 lokata_3 lokata_4 
#	1     0        0        0       300
#	2   199.8      0      100.2       0
#	3     0        0        0         0
#	4    50        0        0         0
#zysk = 457.252

end;
