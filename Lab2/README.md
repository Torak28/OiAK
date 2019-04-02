# Notatki
	
### Komendy

| Komenda | Tłumaczenie|
| --- | --- |
| sub A B | Od B odejmuje A i wynik przechowuje w A |
| add A B | Do B dodaje A i wynik trzyma w A |
| shr A B | Robi przesuniecie bitowe w prawo o A, czyli przy A = 1, dzielenie przez 2 |
| shl A B | To samo co powyższe ale w lewno |

### Debugowanie gcc

+ Zmieniamy **start** na **main**
+ Kompilujemy przez gcc z flagą *-gstabs*

### Protpip

```asm
movb textin(,%edi,1), %bl	#w %bl jest litera
movb $0x5a, %al			#w %al jest Z
cmp %al, %bl			#Porównuje zawartosc bl z al
je Z				#Przeskok
```
