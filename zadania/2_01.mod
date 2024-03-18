option solver cplex;
reset;

# Deklaracja parametrów
param produkty>0, integer;  		# Liczba dostępnych produktów
param cena{1..produkty};  			# Cena każdego produktu
param limit{1..produkty};  			# Limit dostępności każdego produktu
param witaminy{1..produkty};  		# Zawartość witamin w każdym produkcie
param białko{1..produkty};  		# Zawartość białka w każdym produkcie
param sole_mineralne{1..produkty};  # Zawartość soli mineralnych w każdym produkcie
param tłuszcz{1..produkty};  		# Zawartość tłuszczu w każdym produkcie
param popyt;  						# Wielkość popytu na paszę
param wit_limit1;  					# Dolne ograniczenie zawartości witamin w paszy
param wit_limit2;  					# Górne ograniczenie zawartości witamin w paszy
param białko_limit; 				# Dolne ograniczenie zawartości białka w paszy
param sol_min_limit;  				# Dolne ograniczenie zawartości soli mineralnych w paszy
param limit_tłuszcz;  				# Górne ograniczenie zawartości tłuszczu w paszy

# Zmienna decyzyjna - ilość każdego produktu użytego w paszy (w kg)
var liczebność{i in 1..produkty} >= 0, <= limit[i]; 

# Definicja funkcji celu - minimalizacja kosztu paszy
minimize koszt: sum{i in 1..produkty} liczebność[i] * cena[i];  

# Ograniczenia
subject to
o_witaminy1: sum{i in 1..produkty} liczebność[i] * witaminy[i] >= wit_limit1 * popyt;  	 # Minimalna zawartość witamin w paszy
o_witaminy2: sum{i in 1..produkty} liczebność[i] * witaminy[i] <= wit_limit2 * popyt;  	 # Maksymalna zawartość witamin w paszy
o_białko: sum{i in 1..produkty} liczebność[i] * białko[i] >= białko_limit * popyt;  	 # Minimalna zawartość białka w paszy
o_sole: sum{i in 1..produkty} liczebność[i] * sole_mineralne[i] >= sol_min_limit * popyt;# Minimalna zawartość soli mineralnych w paszy
o_tłuszcz: sum{i in 1..produkty} liczebność[i] * tłuszcz[i] <= limit_tłuszcz * popyt;  	 # Maksymalna zawartość tłuszczu w paszy
o_popyt: sum{i in 1..produkty} liczebność[i] = popyt;  									 # Ilość użytych produktów równą popytowi

# Dane wejściowe
data;
param produkty:=4;  									
param cena:= [1] 200 [2] 120 [3] 240 [4] 120;  		
param limit:= [1] 6 [2] 10 [3] 4 [4] 5;  			
param witaminy:= [1] 8 [2] 10 [3] 6 [4] 8;  		
param białko:= [1] 6 [2] 5 [3] 10 [4] 6; 		 	
param sole_mineralne:= [1] 10 [2] 12 [3] 6 [4] 6;  
param tłuszcz:= [1] 4 [2] 8 [3] 6 [4] 9;  			
param popyt:= 10;  									
param wit_limit1:= 6;  							
param wit_limit2:= 10;  							
param białko_limit:= 6;  						
param sol_min_limit:= 7; 			 			
param limit_tłuszcz:= 8;  							

solve;
display  liczebność, koszt; 
# Wynik:
# 1 = 0.833333 - Oznacza, że użyto 0.833333 kg produktu 1 w paszy.
# 2 = 3.33333 - Oznacza, że użyto 3.33333 kg produktu 2 w paszy.
# 3 = 0.833333 - Oznacza, że użyto 0.833333 kg produktu 3 w paszy.
# 4 = 5 - Oznacza, że użyto 5 kg produktu 4 w paszy.
#koszt = 1366.67

end;
