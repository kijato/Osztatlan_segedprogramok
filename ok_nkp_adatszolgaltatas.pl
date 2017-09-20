#!/usr/bin/perl
#
#	Copyright (c) Kis János Tamás, 2015. január 22.
#	VERZIOSZAM ='1.13 (2017. február 15.)'
#

use strict;
#use warnings;
#use Encoding;
#use Data::Dumper;
#use locale; # Ez kell(het) az ABC szerinti helyes rendezéshez.
$| = 1; # STDOUT buffer out;

#if ( @ARGV<1 ) { die "Hibás paraméterezés...!" }
if ( @ARGV!=1 ) { die <<END

A program a TAKAROS-Osztatlan moduljából származó, NKP-ra szûrt "vállalkozói"
adatszolgáltatás (azaz "név szerinti lekérdezés") eredményébõl elõállítja az
NKP igénye szerinti szerkezetû adatokat.
Aa betöltés közben a kérelmezõkre, tulajdonosokra és területi adatokra
vonatkozóan történik "némi" konzisztencia-vizsgálat is, melynek eredménye
szintén bekerül a naplóként funkcionáló, LOG kiterjesztésû állományba.

(Az ellenõrzés az "idõkövetéses" lekérdezés feldolgozása esetén nem lesz
megfelelõ, mert annak struktúrája eltér az "Adatszolgáltatás"-sal elõállítható
fájlok struktúrájától.)

Rendszer-követelmények:
------------------------
- Minimális Perl környezet;
+ szükség esetén a Data::Dumper modul (a részletes naplózás miatt).

Használat:
----------
[perl.exe] $0 adatfile.csv

Kimenet:
--------
1.
Egy 'Helyrajziszámok.csv', mely tartalmazza a szükéges formátumú hrsz felsorolást,
illetve 1-1-1 'Kerelmezok', 'Tulajdonosok', és 'Visszamaradok' könyvtár, melyek
hrsz-enként tartalmazzák a könyvtárnév szerinti szûrt adatokat.
2.
A paraméterként kapott fájlnév+'.log' fájl tartalmazza a valamilyen szempontból
'szokatlan' tételeket, mint például:
- megszûnt eljárások és ezekhez tartozó adatsorok;
- hibásnak vélt adatok a kérelmezõk, a tulajdonosok, illetve a területi adatok vonatkozásában.

END
}

my $riport_file = my $log_file = shift(@ARGV);
unless (-f $riport_file) { die "\nA(z) '$riport_file' nem létezik...!\n"; }
my ($fajlnev,$hrszsorok)='';
my ($sorszam,$ervenyes_sor,$ervenyes_sorok,$ervenytelen_sorok)=0;
my %adatok;

$log_file=~s/(\.\w*)$//;
open LOG,">$log_file.log" || die "$!\n";
print LOG "A feldolgozás kezdete: ".`date`."\n";

open FH,$riport_file || die "$!\n";
print "\nA feldolgozás indul...\n";
while(<FH>) {
	chomp;
	print "\tFeldolgozott sorok száma: ".++$sorszam."\tÉrvényes HRSZ-ek száma: ".$ervenyes_sorok."\tÉrvénytelen HRSZ-ek száma: ".$ervenytelen_sorok.".\r";
	my @sor = split(/;/);
	if ( $sor[0] == 1 && $sor[17] == 1) {
		$ervenyes_sor=1;
		$ervenyes_sorok++;
		$fajlnev = $sor[2]."_".$sor[3]."_".$sor[4]."_".$sor[5].".csv";
		$hrszsorok .= $sor[1].";".$sor[2].";".$sor[3].";".$sor[4].";".$sor[5].";".$sor[6].";".$sor[9].";".$sor[8].";".$fajlnev.";".$sor[10].";".$sor[11].";".$sor[12].";".$sor[15].";\n";

		if ( $sor[7] > $sor[6] ) { print LOG "\n\n$sor[2], $sor[3], $sor[4]/$sor[5] esetében nagyobb a kiosztandó terület, mint az ingatlan teljes területe!\n\n"; }
		if ( $sor[8] > $sor[9] ) { print LOG "\n\n$sor[2], $sor[3], $sor[4]/$sor[5] esetében nagyobb a kérelmezõk száma, mint a tulajdonosok száma!\n\n"; }
		if ( $sor[8] == 0 || $sor[8] == '' || !defined($sor[8]) )  { print LOG "\n\n$sor[2], $sor[3], $sor[4]/$sor[5] esetében a kérelmezõk száma: '$sor[8]'!\n\n"; }
		if ( $sor[9] == 1 || $sor[9] == '' || !defined($sor[9]) )  { print LOG "\n\n$sor[2], $sor[3], $sor[4]/$sor[5] esetében a tulajdonosok száma: '$sor[9]'!\n\n"; }

		$adatok{$fajlnev} = {'Kerelmezok'=>'', 'Tulajdonosok'=>'', 'Visszamaradok'=>''};
	} elsif ( $sor[0] == 1 && $sor[17] != 1) {
		$ervenyes_sor=0;
		$ervenytelen_sorok++;
		print LOG "\nA(z) $sorszam. sort a státuszkód ($sor[17]) miatt kihagyom ($sor[2]_$sor[3]_$sor[4]_$sor[5])!\n";
	} elsif ( $ervenyes_sor && $sor[0] == 2 ) {
		$adatok{$fajlnev}{'Kerelmezok'} .= $sor[1].";".";".";".";".$sor[3].";".$sor[4].";\n";
	} elsif ( $ervenyes_sor && $sor[0] == 3 ) {
		$adatok{$fajlnev}{'Tulajdonosok'} .= $sor[1].";".";".";".";".$sor[3].";".$sor[4].";\n";
	} elsif ( $ervenyes_sor && $sor[0] == 4 ) {
		$adatok{$fajlnev}{'Visszamaradok'} .= $sor[1].";".";".";".";".$sor[3].";".$sor[4].";\n";
	} elsif ( !$ervenyes_sor ) {
		print LOG "A(z) $sorszam. sort 'földrészlet' státusz-kódja miatt kihagyom: ($sor[1] [$sor[3]/$sor[4]])\n";
	#} elsif (/^\D+/) {
	#	next; # A fejléc sor csendes átlépése... sorszámozás...?
	} else {
		die "Ez meg ($sorszam.) miféle sor lehet...?";
	}
}
close FH;
print "\nA feldolgozás kész!\n\n";

#print Dumper(%adatok);

print "A kiírás indul...\n";
open FH,">Helyrajziszamok.csv";
print FH "Települési sorszám;Település név;Fekvés;Helyrajziszám;Alátörés;Érintett földrészletek területe;Tulajdonosok száma;Kérelmet benyújtók száma;Kérelmezõnkénti összesített tulajdoni hányad;Állami tulajdon megjelölése;Perfeljegyzés darabszáma;Terhek darabszáma;Széljegyek darabszáma;\n";
print FH $hrszsorok;
close FH;

my $i=0;
foreach my $fajlnev (keys %adatok) {
	foreach my $tipus (keys %{$adatok{$fajlnev}}) {
		unless (-d $tipus) { mkdir $tipus; }
		if( !defined(${$adatok{$fajlnev}}{$tipus}) || length(${$adatok{$fajlnev}}{$tipus})==0 ) {
			print LOG "\nA(z) '$tipus\\$fajlnev' nem tartalmazna adatot, ezért nem hozom létre!\n";
		} else {
			open FH, ">$tipus\\$fajlnev";
			print FH "Név;Születési év;Anyja neve;Lakcím;Kérelmezõnkénti összesített tulajdoni hányad számláló;Kérelmezõnkénti összesített tulajdoni hányad nevezõ;\n";
			print FH ${$adatok{$fajlnev}}{$tipus};

			#my @sorok = split(/^/m,${$adatok{$fajlnev}}{$tipus});
			#my $szemelyek={};
			#foreach(@sorok) {
			#    my @sor=split(/;/);
			#    $szemelyek->{$sor[0]} += $sor[1];
			#    $szemelyek->{'nevezo'} = chomp($sor[2]);
			#}
			## print LOG Dumper($szemelyek);
			#if($szemelyek->{$sor[0]} >= $szemelyek->{'nevezo'}) {
			#    print LOG "\n\nhiba a $tipus\\$fajlnev' fájlban:".$szemelyek->{$sor[0]}.' >= '.$szemelyek->{'nevezo'};
			#}
			#    if ( ( $sor[0] == 2 || $sor[0] == 3 ) && $sor[3]==$sor[4] ) 

			close FH;
		}
	}
	print "\tA feldolgozott HRSZ-ek száma: ".++$i."/".(keys %adatok)."\r";
}
print "\nA kiírás kész!\n";

print LOG "\n\nA feldolgozás vége: ".`date`;
close LOG;

#print "A folytatáshoz nyomj ENTER-t...!";
#<>;

exit;

__END__

#
#   A program szabad szoftver, bárki továbbadhatja és/vagy módosíthatja
#   a legfrissebb GNU General Public Licence feltételei szerint, ahogy
#   azt a Free Software Foundation közli. A program módosított változatai,
#   a változatlan másolatokkal megegyezô feltételek alapján másolhatók
#   és terjeszthetôk, ha a módosított változatot is, az ezzel az enge-
#   déllyel megegyezô feltételek szerint terjesztik. A lefordított kód
#   is a módosított változat kategóriájába tartozik. Az üzleti célú
#   terjesztés NEM MEGENGEDETT. Módosítás és terjesztés elôtt a dolgok
#   naprakészségének biztosítása végett ajánlott kapcsolatba lépni a
#   szerzôvel. A program módosítása esetén, kérlek juttatsd el a szerzô-
#   nek a módosított forráskódot valamilyen formában, hogy a hasznos
#   változás mihamarabb bekerüljön a szoftver "hivatalos" disztribúció-
#   jába. A nyomtatott változat jobban néz ki...   :-)
#   E programot (én, a szerzô) azzal a reménnyel terjesztem, hogy hasznos
#   lesz, de MINDENFÉLE GARANCIA VÁLLALÁSA NÉLKÜL. A részletek a GNU
#   General Public Licence-ben találhatók. A programmal együtt kapnod
#   kellett egy másolatot a GNU General Public Licence-bôl, ha nem kaptál,
#   írj a következô címre:
#   Free Software Foundation, Inc. 675 Mass Ave, Cambridge, MA 02139, USA
#   A program szerzôje a következô címeken érhetô el :
#   ×----------------------------------------------------------------×
#   |  Kis János Tamás, E-mail: kjt@takarnet.hu, kijato@gmail.com    |
#   |                   Tel.: (76) 502-562                           |
#   ×----------------------------------------------------------------×
#   *================================================================×
#   |       A PROGRAM SZABADON TERJESZTHETÖ, HA A COPYRIGHT ÉS       |
#   |         AZ ENGEDÉLY SZÖVEGÉT MINDEN MÁSOLATON MEGÕRZIK.        |
#   ×================================================================*
#
