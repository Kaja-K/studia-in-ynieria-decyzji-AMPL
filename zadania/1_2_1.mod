option solver cplex;
reset;

# Zmienne decyzyjne
var zyto >= 0, <= 560/10;      # Hektary obsiane żytem
var pszenica >= 0, <= 480/8;   # Hektary obsiane pszenicą

# Funkcja celu do zmaxymalizowania zysku
maximize Profit: 30*10*zyto + 50*8*pszenica - 12*10*zyto - 20*10*pszenica;

# Ograniczenia
subject to 
Field: zyto + pszenica <= 100;
Labour_Hours: 12*zyto +20*pszenica <=1400;

solve;

display zyto, pszenica, Profit;
# Wynik: zyto = 56, pszenica = 36.4, Profit = 17360

end;