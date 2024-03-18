option solver cplex;
reset;

# Deklaracja parametrów
param miesiac;                      # Zbiór miesięcy inwestowania
param odsetki{1..miesiac};          # Odsetki w każdym miesiącu
param przychody{1..miesiac};        # Przychody w każdym miesiącu
param rachunki{1..miesiac};         # Rachunki do zapłacenia w każdym miesiącu

# Zmienne decyzyjne - lokaty
var lokata_1{1..miesiac} >= 0;       # lokaty miesięczne w okresie 1 - miesiąc
var lokata_2{1..miesiac} >= 0;       # lokaty dwu-miesięczne w okresie 1 - miesiąc
var lokata_3{1..miesiac} >= 0;       # lokaty trzy-miesięczne w okresie 1 - miesiąc
var lokata_4{1..miesiac} >= 0;       # lokaty cztero-miesięczne w okresie 1 - miesiąc

# Funkcja celu - gotówka na koniec kazdego miesiąca
maximize zysk: sum{i in 1..miesiac} (odsetki[i]*(lokata_1[i] + lokata_2[i] + lokata_3[i] + lokata_4[i]));

# Ograniczenia gotóweka na koniec każdego miesiąca
subject to o{ i in 1..miesiac}: przychody[i] 
							+ if i>1 then odsetki[1]*lokata_1[i-1]
							+ if i>2 then odsetki[2]*lokata_1[i-2]
							+ if i>3 then odsetki[3]*lokata_1[i-3]
							+ if i>4 then odsetki[4]*lokata_1[i-4]
	 = rachunki[i]+lokata_1[i]+lokata_2[i]+lokata_3[i]+lokata_4[i];

# Dane 
data;
param miesiac := 4;
param odsetki := 1 1.001 2 1.005 3 1.01 4 1.02;
param przychody := 1 900 2 800 3 300 4 300;
param rachunki := 1 600 2 500 3 500 4 250;

solve;
display lokata_1, lokata_2, lokata_3, lokata_4, zysk;
# Wynik:  	
#						lokata_1 lokata_2 lokata_3 lokata_4
#	styczeń 	 300         0        0        0
#	luty   		 600.3       0        0        0
#	marzec    	 702.4       0        0        0
#	kwiecień	   0         0        0     1659.4
# zysk = 3305.62

end;
