# Osztatlan NKP riport generátor

A program a TAKAROS-Osztatlan moduljából származó, NKP-ra szűrt "vállalkozói" adatszolgáltatás (azaz "név szerinti lekérdezés") eredményéből előállítja az adatkérő igénye szerinti szerkezetű adatokat. Ezen túlmenően, a betöltés közben a kérelmezőkre, tulajdonosokra és területi adatokra vonatkozóan történik "némi" konzisztencia-vizsgálat is, melynek eredménye szintén bekerül a naplóként funkcionáló, LOG kiterjesztésű állományba. (Az ellenőrzés az "időkövetéses" lekérdezés feldolgozása esetén nem lesz megfelelő, mert annak struktúrája eltér az "Adatszolgáltatás"-sal előállítható fájlok struktúrájától.)

### Rendszer-követelmények:
    Minimális Perl környezet;
    szükség esetén a Data::Dumper modul (a részletes naplózás miatt).

### Használat:
```
ok_nkp_adatszolgaltatas.pl adatfile.csv
```
### Kimenet:
Egy 'Helyrajziszámok.csv', mely tartalmazza a szükséges formátumú hrsz felsorolást, illetve 1-1-1 'Kerelmezok', 'Tulajdonosok', és 'Visszamaradok' könyvtár, melyek hrsz-enként tartalmazzák a könyvtárnév szerinti adatokat és egy fájlnév+'.log' fájl, ami  tartalmazza a valamilyen szempontból 'szokatlan' tételeket, mint például: megszűnt eljárások és ezekhez tartozó adatsorok, vagy hibásnak vélt adatok a kérelmezők, tulajdonosok és területi adatok vonatkozásában.
