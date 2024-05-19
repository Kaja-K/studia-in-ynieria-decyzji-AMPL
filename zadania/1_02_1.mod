option solver cplex;
reset;

# Zmienne decyzyjne
var zyto >= 0, <= 560 / 10;  	# Liczba hektarów obsianych żytem, ograniczona przez maksymalny popyt (560 ton / 10 ton z hektara)
var pszenica >= 0, <= 480 / 8;  # Liczba hektarów obsianych pszenicą, ograniczona przez maksymalny popyt (480 ton / 8 ton z hektara)

# Funkcja celu - Maksymalizacja zysku (Przychody ze sprzedaży - Koszty pracy)
maximize zysk: 30 * 10 * zyto + 50 * 8 * pszenica - 12 * 10 * zyto - 20 * 10 * pszenica;  

# Ograniczenia
o_pole: zyto + pszenica <= 100;  				# Maksymalna powierzchnia pola (100 hektarów)
o_godziny: 12 * zyto + 20 * pszenica <= 1400;  	# Dostępne godziny pracy (1400 godzin)

solve;  
display zysk, zyto, pszenica;  
# Wynik: zysk = 17360
# zyto = 56
# pszenica = 36.4

end;