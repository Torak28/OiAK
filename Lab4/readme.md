# make Fib, by sie udalo


Jak na razie wyliczam element ciągu fiabanaciego o podanym w kodzie indexie i trzymam go w buforze.
Całość działa na zasadzie arytmetyki adresów i opiera się o prostą zamiane adresów dwóch buforów.

Problem jest taki że całą odpowiedź przetrzymuje pod konkretnym adresem w pamięci w jednej 64-bitowej komórce przez co moge zapisać tam tylko do 47 wyrazu ciągu fibanaciego, potem przekręca się INT

Do tego za nic na świecie nie wiem jak się zabrać z BigEndianem do tego. W sensie że jak.

Pomysł jest taki żeby nie zapisywać np."55" jako "55" tylko jako "0x37". Ale to też wiąże mnie limitem jak się chociażby przekonałem przy ostatnim programie. Chociaż... w sumie to nie jestem do końca pewien. W sensie pewien jestem że do hexdumpa potrzebuje wypisywania na ekran, a do tego potrzebuje przeniesienia bufora do rejestru. I tu się zaczyna zabawa bo resjetr ma maks 64 bity.

Można też rozdzielić całą liczbe na poszczególne komórki, tak żeby miało to BigEndianowy sens ale to wymagałoby żebym w jakiś sposób znał długośc liczby po dodaniu dwóch. Nie jestem pewien czy to jest jakoś możliwe. Może jakoś biotowo to rozegrać? Przekształcać na binarkę i potem jakoś w zależności od tego... :C

x/tb &wynik
./Fib | hexdump -c wynik w LE



00000080  82 3f a5 43 00 00 00 00  00 00 00 00 00 00 00 00  |.?.C............|



Pierwsze wczytanie:
(gdb) x/24bt &druga
0x6002a0 <druga>:	00000000	00000000	00000000	00000000	00000000	00000000	00000000	00000000
0x6002a8 <druga+8>:	00000000	00000000	00000000	00000000	00000000	00000000	00000000	00000000
0x6002b0 <druga+16>:	00000101	00000000	00000000	00000000	00000000	00000000	00000000	00000000
(gdb) x/24bt &pierwsza
0x600ca0 <pierwsza>:	00000000	00000000	00000000	00000000	00000000	00000000	00000000	00000000
0x600ca8 <pierwsza+8>:	00000000	00000000	00000000	00000000	00000000	00000000	00000000	00000000
0x600cb0 <pierwsza+16>:	00000010	00000000	00000000	00000000	00000000	00000000	00000000	00000000

(gdb) i r r13
r13            0x600cb0	6294704
(gdb) i r r14
r14            0x6002b0	6292144

r13 pierwsza
r14 druga
