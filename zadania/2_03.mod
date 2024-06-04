option solver cplex;
reset;

# Parametry
param projekty > 0, integer; # Liczba projektów
param lata > 0, integer; # Liczba lat
param koszt{1..projekty}; # Koszt każdego z projektów
param przychod{1..projekty}; # Przychód z każdego z projektów
param ukonczenie{1..projekty} >=0, <=1; # Informacja czy projekt został ukończony
param budzet{1..lata}; # Budżet na każdy rok
param inwestowanie{1..lata, 1..projekty}; # Możliwość inwestowania w dany projekt w każdym roku

# Zmienna decyzyjna - Zainwestowane pieniądze w projekcie p w roku r
var pieniadze{r in 1..lata, p in 1..projekty} >= 0; 

# Funkcja celu - Maksymalizacja zysku. Zysk jest obliczany jako suma przychodów z projektów, ważonych przez stopień ich realizacji i odległość w latach od momentu rozpoczęcia do zakończenia.
maximize zysk: sum{p in 1..projekty} sum{r in 2..lata} (przychod[p] * (pieniadze[r-1,p] / koszt[p]) * (lata-r+1));
 
# Ograniczenia
# Suma pieniędzy zainwestowanych we wszystkie projekty nie może przekroczyć budżetu na dany rok.
o_budzetowe{r in 1..lata}: sum{p in 1..projekty} pieniadze[r,p] <= budzet[r];
# Suma pieniędzy zainwestowanych w projekt do momentu końca jego realizacji podzielona przez koszt projektu musi wynosić od 0 do 1.
o_ukonczenie{p in 1..projekty}: ukonczenie[p] <= (sum{r in 1..lata} pieniadze[r,p]) / koszt[p] <= 1; 
# Zainwestowane pieniądze w projekty w danym roku zależą od możliwości inwestowania w dane projekty w danym roku.
o_inwestowanie{r in 1..lata, p in 1..projekty}: pieniadze[r,p] = pieniadze[r,p] * inwestowanie[r,p]; 

data;
param projekty:=4;
param lata:=5;
param koszt:= 1 5 2 8 3 15 4 1.2;
param przychod:= 1 0.05 2 0.07 3 0.15 4 0.02;
param ukonczenie:= 1 1 2 0.25 3 0.25 4 1;
param budzet:= 1 3 2 6 3 7 4 7 5 7;
param inwestowanie:= 1 1 1 1 2 0 1 3 1 1 4 0 2 1 1 2 2 1 2 3 1 2 4 0 3 1 1 3 2 1 3 3 1 3 4 1 4 1 0 4 2 1 4 3 1 4 4 1 5 1 0 5 2 1 5 3 1 5 4 0;

solve;
display zysk, pieniadze;
end;