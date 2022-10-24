# 
reemplaza la rama del NO del ST > VD

```
if 		(FLL - T >= 0 && FLL - T <= 2)  k = 0;
else if (FLL - T >= 3 && FLL - T <= 5) 	k = 0.4;
else if (FLL - T >= 6 && FLL - T <= 8) 	k = 0.8;
else if (FLL - T >= 9) 					k = 1;

CVA = CVA + (VD - ST) * (1 - k) * (FLL - T) * CVAu;
CVP = CVP + (VD - ST) * k * CVPu;

VAC = VAC + (VD - ST) * (1 - k);
ST = 0;
```