option solver cplex;
reset;

# Zdefiniowanie parametrów
param stopy>0, integer;   # Liczba stopów
param koszt{1..stopy};    # Koszt za tonę każdego stopu
param C{1..stopy};        # Zawartość pierwiastka C w każdym stopie
param Si{1..stopy};       # Zawartość pierwiastka Si w każdym stopie
param Mn{1..stopy};       # Zawartość pierwiastka Mn w każdym stopie
param P{1..stopy};        # Zawartość pierwiastka P w każdym stopie
param mix_limit;      	  # Limit mieszanki
param C_limit;        	  # Limit zawartości pierwiastka C w mieszance
param Si_limit;       	  # Limit zawartości pierwiastka Si w mieszance
param Mn_limit;       	  # Minimalna zawartość pierwiastka Mn w mieszance
param P_limit;        	  # Minimalna zawartość pierwiastka P w mieszance

# Definicja zmiennych decyzyjnych -  Ilość ton każdego stopu użytego w mieszance
var ilość_ton{i in 1..stopy} >= 0;

# Funkcja celu do zminimalizowania kosztów mieszanki
minimize Profit: sum{i in 1..stopy} koszt[i]*ilość_ton[i];  

# Ograniczenia
subject to
o_C: sum{i in 1..stopy} ilość_ton[i]*C[i] <= C_limit*mix_limit;    	# Zawartość pierwiastka C w mieszance
o_Si: sum{i in 1..stopy} ilość_ton[i]*Si[i] <= Si_limit*mix_limit;  # Zawartość pierwiastka Si w mieszance
o_Mn: sum{i in 1..stopy} ilość_ton[i]*Mn[i] >= Mn_limit*mix_limit;  # Minimalna zawartość pierwiastka Mn w mieszance
o_P: sum{i in 1..stopy} ilość_ton[i]*P[i] >= P_limit*mix_limit;    	# Minimalna zawartość pierwiastka P w mieszance
o_Mix: sum{i in 1..stopy} ilość_ton[i] = mix_limit;                 # Ilość ton mieszanki

# Dane
data;
param stopy:=3;                        
param koszt:= 1 200 2 150 3 400; 
param C:= 1 0.28 2 0.14 3 0.1; 
param Si:= 1 0.1 2 0.12 3 0.06; 
param Mn:= 1 0.3 2 0.2 3 0.3;   
param P:= 1 0.1 2 0.1 3 0.15;   
param mix_limit:=5000;           
param C_limit:=0.14;               
param Si_limit:=0.08;               
param Mn_limit:=0.25;                
param P_limit:=0.12;                 

solve;
display ilość_ton, Profit;
# Wynik: 1 = 869.565, 2 = 1086.96, 3 = 3043.48, Profit = 1554350

end;
