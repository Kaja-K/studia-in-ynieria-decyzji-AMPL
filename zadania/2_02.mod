option solver cplex; 
reset;              

# Parametry
param lokaty;           		# Liczba dostępnych lokat
param okresy;         			# Liczba okresów
param oprocentowanie{1..lokaty};# Oprocentowanie każdej lokaty
param przychody{1..okresy};     # Przychody w każdym okresie
param wydatki{1..okresy};       # Wydatki w każdym okresie

# Zmienna decyzyjna - Ilość lokat każdego rodzaju w każdym okresie
var lokata{1..lokaty, 1..okresy} >= 0;

# Funkcja celu - Maksymalizacja sumy oprocentowania lokat w ostatnim okresie
maximize zysk: sum{i in 1..lokaty} oprocentowanie[i] * lokata[i, okresy - i + 1];

# Ograniczenie bilansu - Zapewnia równowagę między przychodami, lokatami oraz wydatkami w każdym okresie. Suma lokat w bieżącym okresie, z oprocentowaniem z poprzednich okresów, musi równać się sumie przychodów minus wydatków w danym okresie.
o_bilans{j in 1..okresy}: wydatki[j] + sum{i in 1..lokaty} lokata[i, j] = przychody[j] + sum{i in 1..lokaty: i < j} oprocentowanie[i] * lokata[i, j - i]; 

data;
param lokaty := 4;
param okresy := 4;
param oprocentowanie := 1 1.001
					    2 1.005
					    3 1.01
					    4 1.02;
param przychody :=      1 900
					    2 800
					    3 300
					    4 300;
param wydatki :=  		1 600
					    2 500
					    3 500
					    4 250;
solve;
display lokata, zysk;
end;