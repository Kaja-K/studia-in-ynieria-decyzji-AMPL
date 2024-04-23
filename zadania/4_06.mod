
# Dane
data;
param n:=10;
param r:=4;
set PACZKI:= 2 4 1 6 4 7 2 7 1 3 4 4 2 9 8 3 9 5 5 1 8 10 7 7;


solve;
for{i in 1..n}{for{j in 1..n} 
		printf "%s", if x[i,j]==1 then " c " else if (i,j) in PACZKI then  " P " else " . ";
		printf "\n";}

end;
