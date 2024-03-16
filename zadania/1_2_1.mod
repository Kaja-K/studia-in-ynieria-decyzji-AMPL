option solver cplex;
reset;

# Zmienne decyzyjne
var zyto >= 0, <= 560/10;      # Hektary obsiane żytem
var pszenica >= 0, <= 480/8;   # Hektary obsiane pszenicą

# Funkcja celu do zmaksymalizowania zysku
maximize zysk: 30*10*zyto + 50*8*pszenica - 12*10*zyto - 20*10*pszenica;

# Ograniczenia
subject to 
o_pole: zyto + pszenica <= 100;  			# Łączna powierzchnię pola
o_godziny: 12*zyto +20*pszenica <=1400;  	# Dostępne godziny pracy

solve;

display zyto, pszenica, zysk;
# Wynik: zyto = 56, pszenica = 36.4, Profit = 17360

end;