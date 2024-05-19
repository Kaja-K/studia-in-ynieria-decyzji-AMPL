option solver cplex;
reset;

# Parametry
param n;               # Liczba miesięcy inwestowania
param procent{1..n};   # Procent z lokat (1+oprocentowanie)
param przychody{1..n}; # Przychody w każdym miesiącu
param rachunki{1..n};  # Rachunki do zapłacenia w każdym miesiącu

# Zmienne decyzyjne - Lokaty
var lokata_1{1..n} >= 0; # Lokaty miesięczne w okresie 1 - miesiąc
var lokata_2{1..n} >= 0; # Lokaty dwu-miesięczne w okresie 1 - miesiąc
var lokata_3{1..n} >= 0; # Lokaty trzy-miesięczne w okresie 1 - miesiąc
var lokata_4{1..n} >= 0; # Lokaty cztero-miesięczne w okresie 1 - miesiąc

# Funkcja celu - Maksymalizacja gotówki na koniec czwartego miesiąca
maximize zysk: procent[1]*lokata_1[n] + procent[2]*lokata_2[n-1] + procent[3]*lokata_3[n-2] + procent[4]*lokata_4[n-3];

# Ograniczenia - Dostępna gotówka na koniec każdego miesiąca
o_gotowka{i in 1..n}: przychody[i] +
    (if i > 1 then lokata_1[i-1] * procent[1] else 0) +
    (if i > 2 then lokata_2[i-2] * procent[2] else 0) +
    (if i > 3 then lokata_3[i-3] * procent[3] else 0) +
    (if i > 4 then lokata_4[i-4] * procent[4] else 0) =
    rachunki[i] + lokata_1[i] + lokata_2[i] + lokata_3[i] + lokata_4[i];

data;
param n := 4;
param procent := 	1 1.001 2 1.005 3 1.01 4 1.02;
param przychody := 	1 900 2 800 3 300 4 300;
param rachunki := 	1 600 2 500 3 500 4 250;

solve;
display zysk, lokata_1, lokata_2, lokata_3, lokata_4;
# Wynik: zysk = 457.252
#		lokata_1 lokata_2 lokata_3 lokata_4 
#	1     0        0        0       300
#	2   199.8      0      100.2       0
#	3     0        0        0         0
#	4    50        0        0         0

end;