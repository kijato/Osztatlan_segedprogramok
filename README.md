# Osztatlan (1..4)

Az alábbi programok az osztatlan közös tulajdon megszüntetésével kapcsolatos "1-2-3-4-es" jelentés összeállítására és az összesítő elkészítésére készültek.

## Előfeltételek
A feldolgozás alapját mindkét esetben a járásonként elkészített 1-2-3-4-es típusú CSV állományok jelentik.
A programok feltételezik, hogy a feldolgozandó CSV állományok (járásonként 4-4 darab) a következők szerint vannak elnevezve:

* A fájlnévben az azonosító adatokat "_" jel választja el egymástól.
* Az 1. adat az "osztatlan" szó.
* A 2. adat az eljárás típusának sorszáma.
* A 3. adat a hónap kódja.
* A 4. adat a járás neve.

Azaz például egy "1-es típusú" eljárásokhoz tartozó fájl neve:
> oszatlan_1_2015-05_Kecskemét.csv

### A megoldás Perl-ben

A Perl program első paraméterként a megye nevét, másodikként pedig egy fájl listát vár, amit megadhatunk egyenként, vagy helyettesítő karakterekkel is. (Én ez utóbbi módszert használom.) Kimenetként az összemásolt állományok mellett elkészül az összesítő is, melyből az adatokat például az Excel-lel történő megnyitás után, kijelöléssel és Ctrl+C & Ctrl+V-vel könnyedén bemásolhatjuk az előre megadott Excel állományba.

#### Gyakorlati példa:
Esetemben a járások által elkészített CSV állományok egyetlen, a program melletti "Adatok" könytárba vannak másolva. Így készítettem egy batch fájlt ("osztatlan_1-4_minden.bat" néven, hogy kevesebbet kelljen gépelni és hogy ne kelljen megjegyeznem a paraméterezést...), a következő tartalommal:
```
chcp 1250
set honap=2015-05
perl osztatlan_1-4_minden.pl Bács-Kiskun adatok\osztatlan_?_%HONAP%*.csv > %HONAP%_Napló.log
```
*A "perl ... %HONAP%_Napló.log" a fájlban természetesen egy sorban van.*
A batch fájlt futtatva elkészülnek a típusonként összemásolt (2015-05_Bács-Kiskun_*.csv) állományok és az összesítő (2015-05_Bács-Kiskun_Osszesites.csv) és kapok egy naplót amiben minden lényeges mozzanat és tárolt adat látható. Hónapról-hónapra változtatni csupán a batch fájlon kell, a hónap helyes megadásával, illetve a továbbítás előtt a hónap megírásokat törölni kell a fájl nevekből.

#### Letöltés: [osztatlan_1-4_minden.zip](https://mega.nz/#!PxQj0ZhT!3YCsi4wiYhbDSpXQwEYMrur76Ypo5v-SuZajWKPRdVI)

### A megoldás C#(.NET)-ben

Bár a Perl-es megoldás évek óta remekül működik, sajnos Perl környezet kell hozzá, ami nálam ugyan alapfeltétel, de másnál már nem annyira... ebből következett, hogy a feladatot meg kellett oldanom más módon is: így született a C#-ban megírt grafikus felületű összesítő program, ami tulajdonképpen a batch fájl és a Perl szkript munkáját egyesíti.

A program a mellette található *.Config állománnyal konfigurálható: itt leginkább az olyan "állandó" jellegű beállításokat érdemes elvégezni, mint például a megye nevének beállítása, vagy ha az általam használt fájlnév-szisztéma nem felel meg, a fájlok nevében lévő adatok sorendjét is meg lehet változtatni.
Az indítást követően ki kell választani a munka könyvtárat, ahol a korábbiakban megadott CSV állományok találhatóak és be kell állítani a szűrőfeltételt, ami nagyjából a Perl program második paraméterével azonos célokat szolgál.
A szűrőfeltételek módosításakor a felső részben fájlonként, az alsó részben az Excel-es struktúrának megfelelően láthatóak az összesítések. Ez utóbbiból az adatokat kijelöléssel és Ctrl+C & Ctrl+V-vel könnyedén bemásolhatjuk az előre megadott Excel állományba.
Képernyőkép

#### Megjegyzés:
A program legutolsó CSV szerkezettel működik jól, a két korábbi változatot (ahol az oszlopok száma a jelenleginél kevesebb volt) nem kezeli!

#### Letöltés: [Osztatlan_1-4.zip](https://mega.nz/#!r8AhkbYa!4o4pWtBZqW2knoszN3pGa6BMdqFiUZVZIDV488FlM2U)


# Osztatlan - NKP riport generátor

A program a TAKAROS-Osztatlan moduljából származó, NKP-ra szűrt "vállalkozói" adatszolgáltatás (azaz "név szerinti lekérdezés") eredményéből előállítja az adatkérő igénye szerinti szerkezetű adatokat. Ezen túlmenően, a betöltés közben a kérelmezőkre, tulajdonosokra és területi adatokra vonatkozóan történik "némi" konzisztencia-vizsgálat is, melynek eredménye szintén bekerül a naplóként funkcionáló, LOG kiterjesztésű állományba. (Az ellenőrzés az "időkövetéses" lekérdezés feldolgozása esetén nem lesz megfelelő, mert annak struktúrája eltér az "Adatszolgáltatás"-sal előállítható fájlok struktúrájától.)

### Rendszer-követelmények:
* Minimális Perl környezet;
* szükség esetén a Data::Dumper modul (a részletes naplózás miatt).

### Használat:
```
[perl.exe] ok_nkp_adatszolgaltatas.pl <adatfile.csv>
```
### Kimenet:
Egy 'Helyrajziszámok.csv', mely tartalmazza a szükséges formátumú hrsz felsorolást, illetve 1-1-1 'Kerelmezok', 'Tulajdonosok', és 'Visszamaradok' könyvtár, melyek hrsz-enként tartalmazzák a könyvtárnév szerinti adatokat és egy fájlnév+'.log' fájl, ami  tartalmazza a valamilyen szempontból 'szokatlan' tételeket, mint például:
* megszűnt eljárások és ezekhez tartozó adatsorok;
* hibásnak vélt adatok a kérelmezők, tulajdonosok és területi adatok vonatkozásában.


# Osztatlan - Körlevél adatforrás generátor a postázáshoz

A program a TAKAROS-Osztatlan moduljából származó, NKP-ra szűrt "vállalkozói" adatszolgáltatás (azaz "név szerinti lekérdezés") eredményéből előállítja a körlevelekhez felhasználható adatforrást.

### Rendszer-követelmények:
* Minimális Perl környezet;

### Használat:
```
[perl.exe] ok_posta.pl <adatfile.csv>
```

### Kimenet:
Egy olyan CSV fájl, mely alkalmas a körlevelek adatforrásaként történő felhasználásra. A kimeneti fájl neve a bemeneti fájl nevéből képződik,
a fájlnév '_ok_posta' karakterekkel történő kiegészítésével.
