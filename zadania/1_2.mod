# Czyszcenie pamięci AMPL
reset;

# Zmienne decyzyjne
var zyto >= 0;      # Hektary obsiane żytem
var pszenica >= 0;  # Hektary obsiane pszenicą
var kukurydza >= 0; # Hektary obsiane kukurydzą

# Funkcja celu do zmaxymalizowania
maximize Zysk: 30 * 10 * zyto + 50 * 8 * pszenica + 40 * 5 * kukurydza - (10 * (12 * zyto + 20 * pszenica + 7 * kukurydza));

# Ograniczenia
subject to 
O_Pracy: 12 * zyto + 20 * pszenica + 7 * kukurydza <= 1400;
O_Zyto: 10 * zyto <= 560;
O_Pszenica: 8 * pszenica <= 480;
O_Kukurydza: 5 * kukurydza <= 500;

# Rozwiązanie
solve;

# Wyświetlenie wyników
display zyto, pszenica, kukurydza, Zysk;

end;

# Wynik: zyto = 56, pszenica = 1.4, kukurydza = 100, Zysk = 23360