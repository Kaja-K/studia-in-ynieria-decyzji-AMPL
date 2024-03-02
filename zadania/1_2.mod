# Czyszcenie pamięci AMPL
reset;

param cena_zyta := 30;        # Cena żyta za tonę
param cena_pszenicy := 50;    # Cena pszenicy za tonę
param cena_kukurydzy := 40;   # Cena kukurydzy za tonę

param wydajnosc_zyta := 10;      # Wydajność żyta (tony na hektar)
param wydajnosc_pszenicy := 8;   # Wydajność pszenicy (tony na hektar)
param wydajnosc_kukurydzy := 5;  # Wydajność kukurydzy (tony na hektar)

param praca_zyto := 12;      # Praca na hektarze żyta (godziny)
param praca_pszenica := 20;  # Praca na hektarze pszenicy (godziny)
param praca_kukurydza := 7;  # Praca na hektarze kukurydzy (godziny)

param dostepna_praca := 1400;  # Dostępna liczba godzin pracy
param koszt_pracy := 10;        # Koszt jednej godziny pracy

param popyt_zyto := 560;  # Popyt na żyto (tony)
param popyt_pszenica := 480;  # Popyt na pszenicę (tony)
param popyt_kukurydza := 500;  # Popyt na kukurydzę (tony)

param koszt_zyto := 0;    # Koszt produkcji żyta za hektar (dla uproszczenia)
param koszt_pszenica := 0;  # Koszt produkcji pszenicy za hektar (dla uproszczenia)
param koszt_kukurydza := 0;  # Koszt produkcji kukurydzy za hektar (dla uproszczenia)

# Zmienne decyzyjne
var x_zyto >= 0;      # Hektary obsiane żytem
var x_pszenica >= 0;  # Hektary obsiane pszenicą
var x_kukurydza >= 0; # Hektary obsiane kukurydzą

# Funkcja celu do zmaxymalizowania
maximize Zysk:
    cena_zyta * wydajnosc_zyta * x_zyto +
    cena_pszenicy * wydajnosc_pszenicy * x_pszenica +
    cena_kukurydzy * wydajnosc_kukurydzy * x_kukurydza -
    (koszt_pracy * (praca_zyto * x_zyto + praca_pszenica * x_pszenica + praca_kukurydza * x_kukurydza) +
    koszt_zyto * x_zyto + koszt_pszenica * x_pszenica + koszt_kukurydza * x_kukurydza);

# Ograniczenia
subject to 
Ograniczenie_Pracy: praca_zyto * x_zyto + praca_pszenica * x_pszenica + praca_kukurydza * x_kukurydza <= dostepna_praca;
Ograniczenie_Zyto: wydajnosc_zyta * x_zyto <= popyt_zyto;
Ograniczenie_Pszenica: wydajnosc_pszenicy * x_pszenica <= popyt_pszenica;
Ograniczenie_Kukurydza: wydajnosc_kukurydzy * x_kukurydza <= popyt_kukurydza;

# Rozwiązanie
solve;

# Wyświetlenie wyników
display x_zyto, x_pszenica, x_kukurydza, Zysk;

end;

# Wynik: x_zyto = 56, x_pszenica = 1.4, x_kukurydza = 100, Zysk = 23360