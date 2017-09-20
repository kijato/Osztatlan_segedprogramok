#!/usr/bin/perl
#
#	Copyright (c) Kis J�nos Tam�s, 2015. janu�r 22.
#	VERZIOSZAM ='1.13 (2017. febru�r 15.)'
#

use strict;
#use warnings;
#use Encoding;
#use Data::Dumper;
#use locale; # Ez kell(het) az ABC szerinti helyes rendez�shez.
$| = 1; # STDOUT buffer out;

#if ( @ARGV<1 ) { die "Hib�s param�terez�s...!" }
if ( @ARGV!=1 ) { die <<END

A program a TAKAROS-Osztatlan modulj�b�l sz�rmaz�, NKP-ra sz�rt "v�llalkoz�i"
adatszolg�ltat�s (azaz "n�v szerinti lek�rdez�s") eredm�ny�b�l el��ll�tja az
NKP ig�nye szerinti szerkezet� adatokat.
Aa bet�lt�s k�zben a k�relmez�kre, tulajdonosokra �s ter�leti adatokra
vonatkoz�an t�rt�nik "n�mi" konzisztencia-vizsg�lat is, melynek eredm�nye
szint�n beker�l a napl�k�nt funkcion�l�, LOG kiterjeszt�s� �llom�nyba.

(Az ellen�rz�s az "id�k�vet�ses" lek�rdez�s feldolgoz�sa eset�n nem lesz
megfelel�, mert annak strukt�r�ja elt�r az "Adatszolg�ltat�s"-sal el��ll�that�
f�jlok strukt�r�j�t�l.)

Rendszer-k�vetelm�nyek:
------------------------
- Minim�lis Perl k�rnyezet;
+ sz�ks�g eset�n a Data::Dumper modul (a r�szletes napl�z�s miatt).

Haszn�lat:
----------
[perl.exe] $0 adatfile.csv

Kimenet:
--------
1.
Egy 'Helyrajzisz�mok.csv', mely tartalmazza a sz�k�ges form�tum� hrsz felsorol�st,
illetve 1-1-1 'Kerelmezok', 'Tulajdonosok', �s 'Visszamaradok' k�nyvt�r, melyek
hrsz-enk�nt tartalmazz�k a k�nyvt�rn�v szerinti sz�rt adatokat.
2.
A param�terk�nt kapott f�jln�v+'.log' f�jl tartalmazza a valamilyen szempontb�l
'szokatlan' t�teleket, mint p�ld�ul:
- megsz�nt elj�r�sok �s ezekhez tartoz� adatsorok;
- hib�snak v�lt adatok a k�relmez�k, a tulajdonosok, illetve a ter�leti adatok vonatkoz�s�ban.

END
}

my $riport_file = my $log_file = shift(@ARGV);
unless (-f $riport_file) { die "\nA(z) '$riport_file' nem l�tezik...!\n"; }
my ($fajlnev,$hrszsorok)='';
my ($sorszam,$ervenyes_sor,$ervenyes_sorok,$ervenytelen_sorok)=0;
my %adatok;

$log_file=~s/(\.\w*)$//;
open LOG,">$log_file.log" || die "$!\n";
print LOG "A feldolgoz�s kezdete: ".`date`."\n";

open FH,$riport_file || die "$!\n";
print "\nA feldolgoz�s indul...\n";
while(<FH>) {
	chomp;
	print "\tFeldolgozott sorok sz�ma: ".++$sorszam."\t�rv�nyes HRSZ-ek sz�ma: ".$ervenyes_sorok."\t�rv�nytelen HRSZ-ek sz�ma: ".$ervenytelen_sorok.".\r";
	my @sor = split(/;/);
	if ( $sor[0] == 1 && $sor[17] == 1) {
		$ervenyes_sor=1;
		$ervenyes_sorok++;
		$fajlnev = $sor[2]."_".$sor[3]."_".$sor[4]."_".$sor[5].".csv";
		$hrszsorok .= $sor[1].";".$sor[2].";".$sor[3].";".$sor[4].";".$sor[5].";".$sor[6].";".$sor[9].";".$sor[8].";".$fajlnev.";".$sor[10].";".$sor[11].";".$sor[12].";".$sor[15].";\n";

		if ( $sor[7] > $sor[6] ) { print LOG "\n\n$sor[2], $sor[3], $sor[4]/$sor[5] eset�ben nagyobb a kiosztand� ter�let, mint az ingatlan teljes ter�lete!\n\n"; }
		if ( $sor[8] > $sor[9] ) { print LOG "\n\n$sor[2], $sor[3], $sor[4]/$sor[5] eset�ben nagyobb a k�relmez�k sz�ma, mint a tulajdonosok sz�ma!\n\n"; }
		if ( $sor[8] == 0 || $sor[8] == '' || !defined($sor[8]) )  { print LOG "\n\n$sor[2], $sor[3], $sor[4]/$sor[5] eset�ben a k�relmez�k sz�ma: '$sor[8]'!\n\n"; }
		if ( $sor[9] == 1 || $sor[9] == '' || !defined($sor[9]) )  { print LOG "\n\n$sor[2], $sor[3], $sor[4]/$sor[5] eset�ben a tulajdonosok sz�ma: '$sor[9]'!\n\n"; }

		$adatok{$fajlnev} = {'Kerelmezok'=>'', 'Tulajdonosok'=>'', 'Visszamaradok'=>''};
	} elsif ( $sor[0] == 1 && $sor[17] != 1) {
		$ervenyes_sor=0;
		$ervenytelen_sorok++;
		print LOG "\nA(z) $sorszam. sort a st�tuszk�d ($sor[17]) miatt kihagyom ($sor[2]_$sor[3]_$sor[4]_$sor[5])!\n";
	} elsif ( $ervenyes_sor && $sor[0] == 2 ) {
		$adatok{$fajlnev}{'Kerelmezok'} .= $sor[1].";".";".";".";".$sor[3].";".$sor[4].";\n";
	} elsif ( $ervenyes_sor && $sor[0] == 3 ) {
		$adatok{$fajlnev}{'Tulajdonosok'} .= $sor[1].";".";".";".";".$sor[3].";".$sor[4].";\n";
	} elsif ( $ervenyes_sor && $sor[0] == 4 ) {
		$adatok{$fajlnev}{'Visszamaradok'} .= $sor[1].";".";".";".";".$sor[3].";".$sor[4].";\n";
	} elsif ( !$ervenyes_sor ) {
		print LOG "A(z) $sorszam. sort 'f�ldr�szlet' st�tusz-k�dja miatt kihagyom: ($sor[1] [$sor[3]/$sor[4]])\n";
	#} elsif (/^\D+/) {
	#	next; # A fejl�c sor csendes �tl�p�se... sorsz�moz�s...?
	} else {
		die "Ez meg ($sorszam.) mif�le sor lehet...?";
	}
}
close FH;
print "\nA feldolgoz�s k�sz!\n\n";

#print Dumper(%adatok);

print "A ki�r�s indul...\n";
open FH,">Helyrajziszamok.csv";
print FH "Telep�l�si sorsz�m;Telep�l�s n�v;Fekv�s;Helyrajzisz�m;Al�t�r�s;�rintett f�ldr�szletek ter�lete;Tulajdonosok sz�ma;K�relmet beny�jt�k sz�ma;K�relmez�nk�nti �sszes�tett tulajdoni h�nyad;�llami tulajdon megjel�l�se;Perfeljegyz�s darabsz�ma;Terhek darabsz�ma;Sz�ljegyek darabsz�ma;\n";
print FH $hrszsorok;
close FH;

my $i=0;
foreach my $fajlnev (keys %adatok) {
	foreach my $tipus (keys %{$adatok{$fajlnev}}) {
		unless (-d $tipus) { mkdir $tipus; }
		if( !defined(${$adatok{$fajlnev}}{$tipus}) || length(${$adatok{$fajlnev}}{$tipus})==0 ) {
			print LOG "\nA(z) '$tipus\\$fajlnev' nem tartalmazna adatot, ez�rt nem hozom l�tre!\n";
		} else {
			open FH, ">$tipus\\$fajlnev";
			print FH "N�v;Sz�let�si �v;Anyja neve;Lakc�m;K�relmez�nk�nti �sszes�tett tulajdoni h�nyad sz�ml�l�;K�relmez�nk�nti �sszes�tett tulajdoni h�nyad nevez�;\n";
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
			#    print LOG "\n\nhiba a $tipus\\$fajlnev' f�jlban:".$szemelyek->{$sor[0]}.' >= '.$szemelyek->{'nevezo'};
			#}
			#    if ( ( $sor[0] == 2 || $sor[0] == 3 ) && $sor[3]==$sor[4] ) 

			close FH;
		}
	}
	print "\tA feldolgozott HRSZ-ek sz�ma: ".++$i."/".(keys %adatok)."\r";
}
print "\nA ki�r�s k�sz!\n";

print LOG "\n\nA feldolgoz�s v�ge: ".`date`;
close LOG;

#print "A folytat�shoz nyomj ENTER-t...!";
#<>;

exit;

__END__

#
#   A program szabad szoftver, b�rki tov�bbadhatja �s/vagy m�dos�thatja
#   a legfrissebb GNU General Public Licence felt�telei szerint, ahogy
#   azt a Free Software Foundation k�zli. A program m�dos�tott v�ltozatai,
#   a v�ltozatlan m�solatokkal megegyez� felt�telek alapj�n m�solhat�k
#   �s terjeszthet�k, ha a m�dos�tott v�ltozatot is, az ezzel az enge-
#   d�llyel megegyez� felt�telek szerint terjesztik. A leford�tott k�d
#   is a m�dos�tott v�ltozat kateg�ri�j�ba tartozik. Az �zleti c�l�
#   terjeszt�s NEM MEGENGEDETT. M�dos�t�s �s terjeszt�s el�tt a dolgok
#   naprak�szs�g�nek biztos�t�sa v�gett aj�nlott kapcsolatba l�pni a
#   szerz�vel. A program m�dos�t�sa eset�n, k�rlek juttatsd el a szerz�-
#   nek a m�dos�tott forr�sk�dot valamilyen form�ban, hogy a hasznos
#   v�ltoz�s mihamarabb beker�lj�n a szoftver "hivatalos" disztrib�ci�-
#   j�ba. A nyomtatott v�ltozat jobban n�z ki...   :-)
#   E programot (�n, a szerz�) azzal a rem�nnyel terjesztem, hogy hasznos
#   lesz, de MINDENF�LE GARANCIA V�LLAL�SA N�LK�L. A r�szletek a GNU
#   General Public Licence-ben tal�lhat�k. A programmal egy�tt kapnod
#   kellett egy m�solatot a GNU General Public Licence-b�l, ha nem kapt�l,
#   �rj a k�vetkez� c�mre:
#   Free Software Foundation, Inc. 675 Mass Ave, Cambridge, MA 02139, USA
#   A program szerz�je a k�vetkez� c�meken �rhet� el :
#   �----------------------------------------------------------------�
#   |  Kis J�nos Tam�s, E-mail: kjt@takarnet.hu, kijato@gmail.com    |
#   |                   Tel.: (76) 502-562                           |
#   �----------------------------------------------------------------�
#   *================================================================�
#   |       A PROGRAM SZABADON TERJESZTHET�, HA A COPYRIGHT �S       |
#   |         AZ ENGED�LY SZ�VEG�T MINDEN M�SOLATON MEG�RZIK.        |
#   �================================================================*
#
