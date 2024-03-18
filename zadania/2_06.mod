option solver cplex;
reset;

# Definicja zestawu danych
param miasta > 0, integer; 							# Liczba miast, z których pochodzą odpady
param spalarnie > 0, integer; 						# Liczba spalarni, do których odpady są transportowane
param wysypiska > 0, integer; 						# Liczba wysypisk, do których jest transportowany popioł
param m_s{i in 1..miasta, j in 1..spalarnie}; 		# Koszt transportu odpadów z miasta i do spalarni (w tony)
param s_w{j in 1..spalarnie, k in 1..wysypiska}; 	# Koszt transportu popiołu ze spalarni do wysypiska (w tony)
param spalanie{j in 1..spalarnie};					# Koszt spalania odpadów w każdej z spalarni (w tony)
param popiol{j in 1..spalarnie}; 					# Ilość popiołu wytwarzanego przez każdą z spalarni (w tony)
param l_spalania{j in 1..spalarnie}; 				# Limit spalania odpadów w każdej z spalarni (w tony)
param l_wysypisk{k in 1..wysypiska}; 				# Limit ilości odpadów, które mogą być składowane w każdym z wysypisk (w tony)
param odpady{1..miasta}; 							# Ilość odpadów w każdym z miast (w tony)
param transport; 									# Koszt transportu jednej tony odpadów lub popiołu

# Zmienne decyzyjne
var odpady_m_s{i in 1..miasta, j in 1..spalarnie} >= 0; 	# Ilość ton odpadów wysyłanych z miasta i do spalarni j
var popiol_s_w{j in 1..spalarnie, k in 1..wysypiska} >= 0; 	# Ilość ton popiołu transportowanych ze spalarni j do wysypiska k

# Funkcja celu - minimalizacja kosztu transportu

minimize koszt: 
sum{i in 1..miasta, j in 1..spalarnie} m_s[i,j] * transport * odpady_m_s[i,j] +  	# Koszt transportu odpadów z miast do spalarni
sum{i in 1..miasta, j in 1..spalarnie} spalanie[j] * odpady_m_s[i,j] +             	# Koszt spalania odpadów w poszczególnych spalarniach
sum{j in 1..spalarnie, k in 1..wysypiska} s_w[j,k] * transport * popiol_s_w[j,k];  	# Koszt transportu popiołu ze spalarni do wysypiska

# Ograniczenia
subject to
o_l_spalania{j in 1..spalarnie}: sum{i in 1..miasta} odpady_m_s[i,j] <= l_spalania[j];           				 	# Limit spalania w poszczególnych spalarniach
o_limit_wysypiska{k in 1..wysypiska}: sum{j in 1..spalarnie} popiol_s_w[j,k] <= l_wysypisk[k];   					# Limit składowania popiołu w wysypisku
o_p{j in 1..spalarnie}: sum{k in 1..wysypiska} popiol_s_w[j,k] >= sum{i in 1..miasta} popiol[j] * odpady_m_s[i,j];  # Wywóz popiołu z spalarni do wysypiska
o_o{i in 1..miasta}: sum{j in 1..spalarnie} odpady_m_s[i,j] >= odpady[i];           								# Wywóz odpadów z miast

# Dane
data;
param miasta:=2;
param spalarnie:=2; 
param wysypiska:=2;
param m_s:= 1 1 30 1 2 5 2 1 36 2 2 42;
param s_w:= 1 1 5 1 2 8 2 1 9 2 2 6 ;
param spalanie:= 1 40 2 30;
param popiol:= 1 0.3 2 0.3;
param l_spalania:= 1 1500 2 1500;
param l_wysypisk:= 1 500 2 500;
param odpady:= 1 1500 2 1400;
param transport:=3;

solve;
display odpady_m_s, popiol_s_w, koszt;
# Wynik: 	
# 1 1        0       420 - Oznacza, że z miasta 1 do spalarni 1 nie jest transportowany żaden ton odpadów, a koszt transportu odpadów z miasta 1 do spalarni 2 wynosi 420.
# 1 2     1500         0 - Oznacza, że z miasta 1 do spalarni 2 jest transportowanych 1500 ton odpadów, a koszt transportu popiołu ze spalarni 1 do wysypiska 2 wynosi 0.
# 2 1     1400         0 - Oznacza, że z miasta 2 do spalarni 1 jest transportowanych 1400 ton odpadów, a koszt transportu popiołu ze spalarni 2 do wysypiska 1 wynosi 0.
# 2 2        0       450 - Oznacza, że z miasta 2 do spalarni 2 nie jest transportowany żaden ton odpadów, a koszt transportu popiołu ze spalarni 2 do wysypiska 2 wynosi 450.
#koszt = 289100

end;
